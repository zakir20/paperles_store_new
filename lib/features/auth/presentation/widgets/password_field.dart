import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String selectedLanguage;
  final ValueChanged<bool> onVisibilityChanged;
  final bool isPasswordVisible;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.selectedLanguage,
    required this.onVisibilityChanged,
    required this.isPasswordVisible,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            obscureText: !widget.isPasswordVisible,
            decoration: InputDecoration(
              labelText: widget.selectedLanguage == 'বাংলা' ? 'পাসওয়ার্ড' : 'Password',
              labelStyle: TextStyle(
                color: const Color(0xFF667085),
                fontFamily: widget.selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
              ),
              floatingLabelStyle: const TextStyle(color: Color(0xFF2E90FA)),
              hintText: widget.selectedLanguage == 'বাংলা' ? 'আপনার পাসওয়ার্ড লিখুন' : 'Enter your password',
              hintStyle: TextStyle(
                color: const Color(0xFF667085),
                fontFamily: widget.selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
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
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF667085), size: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextButton(
            onPressed: () => widget.onVisibilityChanged(!widget.isPasswordVisible),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              minimumSize: Size.zero,
            ),
            child: Text(
              widget.isPasswordVisible
                ? widget.selectedLanguage == 'বাংলা' ? 'লুকান' : 'Hide'
                : widget.selectedLanguage == 'বাংলা' ? 'দেখান' : 'Show',
              style: TextStyle(
                color: const Color(0xFF344054),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: widget.selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}