import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedLanguage;

  const EmailField({
    Key? key,
    required this.controller,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: selectedLanguage == 'বাংলা' ? 'ইমেইল' : 'Email',
        labelStyle: TextStyle(
          color: const Color(0xFF667085),
          fontFamily: selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
        ),
        floatingLabelStyle: const TextStyle(color: Color(0xFF2E90FA)),
        hintText: selectedLanguage == 'বাংলা' ? 'আপনার ইমেইল লিখুন' : 'Enter your email',
        hintStyle: TextStyle(
          color: const Color(0xFF667085),
          fontFamily: selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2E90FA)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF667085), size: 20),
      ),
    );
  }
}