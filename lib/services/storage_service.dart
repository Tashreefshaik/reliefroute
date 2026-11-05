import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String?> uploadPrescription(String userId, dynamic image) async {
    try {
      final fileName = 'prescription_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('prescriptions/$userId/$fileName');
      
      await ref.putFile(image);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading prescription: $e');
      return null;
    }
  }

  Future<dynamic> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<dynamic> captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      return image;
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }
}
