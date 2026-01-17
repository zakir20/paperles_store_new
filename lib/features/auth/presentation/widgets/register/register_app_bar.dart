import 'package:flutter/material.dart';

class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedLanguage;
  final String selectedFlag;
  final VoidCallback onBackPressed;
  final VoidCallback onLanguagePressed;
  final VoidCallback onLanguageDialog;

  const RegisterAppBar({
    Key? key,
    required this.selectedLanguage,
    required this.selectedFlag,
    required this.onBackPressed,
    required this.onLanguagePressed,
    required this.onLanguageDialog,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed,
      ),
      title: Text(
        selectedLanguage == 'বাংলা' ? 'ব্যবহারকারী নিবন্ধন' : 'User Registration',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onLanguagePressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD0D5DD)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(selectedFlag, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  selectedLanguage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF344054),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}