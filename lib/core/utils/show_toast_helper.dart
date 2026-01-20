import 'package:flutter/material.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';

void showToast(BuildContext context,
    {required String message, bool isError = true}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
