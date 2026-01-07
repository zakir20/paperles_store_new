import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add this import

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
        title: Text('uploadDocument'.tr), // CHANGED: Already exists from trade license
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF2E90FA)),
              title: Text('camera'.tr), // CHANGED: Need to add key
              onTap: () {
                Navigator.pop(context);
                onCameraPressed();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF2E90FA)),
              title: Text('gallery'.tr), // CHANGED: Need to add key
              onTap: () {
                Navigator.pop(context);
                onGalleryPressed();
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Color(0xFF2E90FA)),
              title: Text('chooseFile'.tr), // CHANGED: Need to add key
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