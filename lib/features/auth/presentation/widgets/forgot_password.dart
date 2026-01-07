import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

class ForgotPassword extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPassword({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'forgotPassword'.tr,  
          style: const TextStyle(
            color: Color(0xFF475467),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}