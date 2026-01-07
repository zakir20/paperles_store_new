import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/language_controller.dart'; 

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<bool> onVisibilityChanged;
  final bool isPasswordVisible;

  const PasswordField({
    Key? key,
    required this.controller,
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
              labelText: 'password'.tr,
              labelStyle: const TextStyle(color: Color(0xFF667085)),
              floatingLabelStyle: const TextStyle(color: Color(0xFF2E90FA)),
              hintText: 'enterPassword'.tr,
              hintStyle: const TextStyle(color: Color(0xFF667085)),
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
            child: GetBuilder<LanguageController>(  
              builder: (languageController) {
                return Text(
                  widget.isPasswordVisible ? 'hide'.tr : 'show'.tr,
                  style: const TextStyle(
                    color: Color(0xFF344054),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}