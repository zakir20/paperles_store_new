import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final String selectedLanguage;
  final VoidCallback onPressed;

  const ForgotPassword({
    Key? key,
    required this.selectedLanguage,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          selectedLanguage == 'বাংলা' ? 'পাসওয়ার্ড ভুলে গেছেন?' : 'Forgot Password?',
          style: TextStyle(
            color: const Color(0xFF475467),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
          ),
        ),
      ),
    );
  }
}