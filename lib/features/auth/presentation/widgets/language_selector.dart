import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/language_controller.dart'; 

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() {
      final isBangla = languageController.isBangla.value;
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD0D5DD)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(isBangla ? '🇧🇩' : '🇺🇸', style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              isBangla ? 'বাংলা' : 'English',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF344054),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF667085), size: 20),
          ],
        ),
      );
    });
  }
}