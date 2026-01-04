import 'package:flutter/material.dart';

class FormUtils {
  static void clearForm({
    required List<TextEditingController> controllers,
    required VoidCallback onClear,
  }) {
    for (var controller in controllers) {
      controller.clear();
    }
    onClear();
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}