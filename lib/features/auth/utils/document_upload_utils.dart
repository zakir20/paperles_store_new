import 'package:flutter/material.dart';

class DocumentUploadUtils {
  static void showDocumentSourceDialog({
    required BuildContext context,
    required String language,
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
    required VoidCallback onFilePressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(language == 'বাংলা' ? 'ডকুমেন্ট আপলোড করুন' : 'Upload Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFF2E90FA)),
              title: Text(language == 'বাংলা' ? 'ক্যামেরা' : 'Camera'),
              onTap: () {
                Navigator.pop(context);
                onCameraPressed();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(0xFF2E90FA)),
              title: Text(language == 'বাংলা' ? 'গ্যালারি' : 'Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGalleryPressed();
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file, color: Color(0xFF2E90FA)),
              title: Text(language == 'বাংলা' ? 'ফাইল নির্বাচন করুন' : 'Choose File'),
              onTap: () {
                Navigator.pop(context);
                onFilePressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}