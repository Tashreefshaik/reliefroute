import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/prescription.dart';
import '../../services/firestore_service.dart';

class PrescriptionVerificationScreen extends StatefulWidget {
  const PrescriptionVerificationScreen({super.key});

  @override
  State<PrescriptionVerificationScreen> createState() => _PrescriptionVerificationScreenState();
}

class _PrescriptionVerificationScreenState extends State<PrescriptionVerificationScreen> {
  List<Prescription> _prescriptions = [];
  bool _isLoading = true;
  final Map<String, String> _medicationInfo = {
    'RX001': 'Amoxicillin 500mg - Take 1 capsule every 8 hours',
    'RX002': 'Lisinopril 10mg - Take 1 tablet daily',
    'RX003': 'Metformin 500mg - Take 1 tablet twice daily',
  };

  @override
  void initState() {
    super.initState();
    _loadPendingPrescriptions();
  }

  Future<void> _loadPendingPrescriptions() async {
    setState(() => _isLoading = true);
    try {
      final prescriptions = await context
          .read<FirestoreService>()
          .getPendingPrescriptions();

      // Add mock data for demo
      if (prescriptions.isEmpty) {
        setState(() {
          _prescriptions = [
            Prescription(
              prescriptionId: 'RX001',
              userId: 'user123',
              status: 'pending',
              imageUrl: 'https://example.com/prescription1.jpg',
            ),
            Prescription(
              prescriptionId: 'RX002',
              userId: 'user456',
              status: 'pending',
              imageUrl: 'https://example.com/prescription2.jpg',
            ),
            Prescription(
              prescriptionId: 'RX003',
              userId: 'user789',
              status: 'pending',
              imageUrl: 'https://example.com/prescription3.jpg',
            ),
          ];
          _isLoading = false;
        });
      } else {
        setState(() {
          _prescriptions = prescriptions;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading prescriptions: $e')),
        );
      }
    }
  }

  Future<void> _verifyPrescription(Prescription prescription, bool approved) async {
    try {
      await context.read<FirestoreService>().updatePrescriptionStatus(
            prescription.prescriptionId,
            approved ? 'verified' : 'rejected',
            'pharmacist_id', // TODO: Use actual pharmacist ID
          );
      _loadPendingPrescriptions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              approved ? 'Prescription verified' : 'Prescription rejected',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating prescription: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _prescriptions.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 64, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'All caught up!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No pending prescriptions to verify',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = _prescriptions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.description, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Prescription #${prescription.prescriptionId}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('User ID: ${prescription.userId}'),
                          const SizedBox(height: 8),
                          if (_medicationInfo.containsKey(prescription.prescriptionId))
                            Text(
                              _medicationInfo[prescription.prescriptionId]!,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          const SizedBox(height: 8),
                          Text('Status: ${prescription.status.toUpperCase()}'),
                          const SizedBox(height: 8),
                          if (prescription.imageUrl != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Prescription Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image, size: 48, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('Image preview available', style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _verifyPrescription(prescription, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Verify'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _verifyPrescription(prescription, false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Reject'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
