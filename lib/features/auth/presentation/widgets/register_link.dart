import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

class RegisterLink extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterLink({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'dontHaveAccount'.tr,  
          style: const TextStyle(
            color: Color(0xFF475467),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'register'.tr,  
            style: const TextStyle(
              color: Color(0xFF7F56D9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}