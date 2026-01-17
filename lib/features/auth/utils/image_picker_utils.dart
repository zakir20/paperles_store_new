import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static Future<File?> pickImageFromCamera(ImagePicker picker, String language) async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      throw Exception(language == 'বাংলা' 
          ? 'ক্যামেরা ত্রুটি: $e' 
          : 'Camera error: $e');
    }
    return null;
  }

  static Future<File?> pickImageFromGallery(ImagePicker picker, String language) async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      throw Exception(language == 'বাংলা' 
          ? 'গ্যালারি ত্রুটি: $e' 
          : 'Gallery error: $e');
    }
    return null;
  }

  static void showImageSourceDialog({
    required BuildContext context,
    required String language,
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(language == 'বাংলা' ? 'ছবি নির্বাচন করুন' : 'Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF2E90FA)),
              title: Text(language == 'বাংলা' ? 'ক্যামেরা' : 'Camera'),
              onTap: () {
                Navigator.pop(context);
                onCameraPressed();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF2E90FA)),
              title: Text(language == 'বাংলা' ? 'গ্যালারি' : 'Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGalleryPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}