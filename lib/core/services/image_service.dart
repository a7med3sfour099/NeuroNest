import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();

  factory ImageService() {
    return _instance;
  }

  ImageService._internal();

  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  Future<String?> pickFromCamera() async {
    try {
      final status = await Permission.camera.request();

      if (!status.isGranted) {
        print('Camera permission denied');
        return null;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageLocally(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking from camera: $e');
      return null;
    }
  }

  /// Pick image from gallery
  Future<String?> pickFromGallery() async {
    try {
      // Try using image_picker directly first (it handles permissions internally)
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageLocally(image.path);
      }

      // If image picker returns null, request permission explicitly
      PermissionStatus status;
      if (Platform.isAndroid) {
        // Try manage external storage first (Android 11+)
        status = await Permission.manageExternalStorage.request();

        // Fallback to storage permission if manage external storage fails
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      } else {
        // For iOS
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        print('Storage permission denied');
        return null;
      }

      // Try picking again after permission
      final XFile? retryImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (retryImage != null) {
        return await _saveImageLocally(retryImage.path);
      }
      return null;
    } catch (e) {
      print('Error picking from gallery: $e');
      return null;
    }
  }

  /// Save image to app's documents directory
  Future<String> _saveImageLocally(String imagePath) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = '${appDir.path}/$fileName';

      final File sourceFile = File(imagePath);
      final File savedFile = await sourceFile.copy(filePath);

      return savedFile.path;
    } catch (e) {
      print('Error saving image: $e');
      rethrow;
    }
  }

  /// Delete image from local storage
  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return;

    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  /// Check if image path is local
  bool isLocalImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return imagePath.startsWith('/') || imagePath.contains('documents');
  }
}
