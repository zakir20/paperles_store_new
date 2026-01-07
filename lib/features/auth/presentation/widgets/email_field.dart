import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'email'.tr,  
        labelStyle: const TextStyle(
          color: Color(0xFF667085),
        ),
        floatingLabelStyle: const TextStyle(color: Color(0xFF2E90FA)),
        hintText: 'enterEmail'.tr,  
        hintStyle: const TextStyle(
          color: Color(0xFF667085),
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