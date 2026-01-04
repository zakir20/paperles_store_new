import 'package:flutter/material.dart';

class RegisterLink extends StatelessWidget {
  final String selectedLanguage;
  final VoidCallback onPressed;

  const RegisterLink({
    Key? key,
    required this.selectedLanguage,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          selectedLanguage == 'বাংলা' ? 'অ্যাকাউন্ট নেই?' : "Don't have an account?",
          style: TextStyle(
            color: const Color(0xFF475467),
            fontSize: 14,
            fontFamily: selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: onPressed,
          child: Text(
            selectedLanguage == 'বাংলা' ? 'রেজিস্টার' : 'Register',
            style: TextStyle(
              color: const Color(0xFF7F56D9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
            ),
          ),
        ),
      ],
    );
  }
}