import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../services/auth_service.dart';
import '../../models/prescription.dart';

class SubmitPrescriptionScreen extends StatefulWidget {
  const SubmitPrescriptionScreen({super.key});

  @override
  State<SubmitPrescriptionScreen> createState() => _SubmitPrescriptionScreenState();
}

class _SubmitPrescriptionScreenState extends State<SubmitPrescriptionScreen> {
  final StorageService _storageService = StorageService();
  XFile? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final image = await _storageService.pickImage();
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _captureImage() async {
    final image = await _storageService.captureImage();
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _submitPrescription() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or capture a prescription image')),
      );
      return;
    }

    setState(() => _isUploading = true);
    try {
      final authService = context.read<AuthService>();
      final firestoreService = context.read<FirestoreService>();
      
      if (authService.currentUser == null) {
        throw Exception('User not logged in');
      }

      // Upload image to Firebase Storage
      final imageUrl = await _storageService.uploadPrescription(
        authService.currentUser!.userId,
        _selectedImage,
      );

      if (imageUrl == null) {
        throw Exception('Failed to upload image');
      }

      // Create prescription record in Firestore
      final prescription = Prescription(
        prescriptionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: authService.currentUser!.userId,
        imageUrl: imageUrl,
        medicationName: 'Uploaded Prescription',
        dosage: 'As prescribed',
        instructions: 'Follow doctor instructions',
        status: 'pending',
        submittedAt: DateTime.now(),
      );

      await firestoreService.addPrescription(prescription);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription submitted successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting prescription: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Prescription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.description,
                      size: 64,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Upload your prescription',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please ensure the prescription is clear and readable',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedImage != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 8),
                      const Text('Image selected'),
                      const SizedBox(height: 8),
                      Text(
                        _selectedImage!.name,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Select from Gallery'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _captureImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitPrescription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Prescription'),
            ),
          ],
        ),
      ),
    );
  }
}
