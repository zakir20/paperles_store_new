import 'package:flutter/material.dart';
import 'dart:io';

class ProfileImagePicker extends StatelessWidget {
  final String selectedLanguage;
  final File? profileImage;
  final VoidCallback onImagePressed;
  final VoidCallback onRemoveImage;

  const ProfileImagePicker({
    Key? key,
    required this.selectedLanguage,
    required this.profileImage,
    required this.onImagePressed,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedLanguage == 'বাংলা' ? 'প্রোফাইল ছবি' : 'Profile Image',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          selectedLanguage == 'বাংলা' ? 'ছবি আপলোড বা তুলুন' : 'Upload or take a photo',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onImagePressed,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: profileImage != null ? Colors.green : const Color(0xFFD0D5DD),
                width: profileImage != null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: profileImage != null ? Colors.green[50] : Colors.grey[50],
            ),
            child: profileImage != null
                ? _buildImagePreview()
                : _buildPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            profileImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              onPressed: onRemoveImage,
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.check, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  selectedLanguage == 'বাংলা' ? 'ছবি নির্বাচিত' : 'Image Selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          color: const Color(0xFF667085),
          size: 40,
        ),
        const SizedBox(height: 10),
        Text(
          selectedLanguage == 'বাংলা' ? 'ছবি যোগ করুন' : 'Add Photo',
          style: const TextStyle(
            color: Color(0xFF667085),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          selectedLanguage == 'বাংলা' 
              ? 'ক্লিক করে ছবি আপলোড করুন' 
              : 'Click to upload photo',
          style: const TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}