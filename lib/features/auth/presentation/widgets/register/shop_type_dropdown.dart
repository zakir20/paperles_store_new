import 'package:flutter/material.dart';

class ShopTypeDropdown extends StatelessWidget {
  final String selectedLanguage;
  final String? selectedShopType;
  final List<String> shopTypes;
  final ValueChanged<String?> onChanged;

  const ShopTypeDropdown({
    Key? key,
    required this.selectedLanguage,
    required this.selectedShopType,
    required this.shopTypes,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedLanguage == 'বাংলা' ? 'দোকানের ধরন' : 'Shop Type',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD0D5DD)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedShopType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              prefixIcon: const Icon(Icons.category, color: Color(0xFF667085), size: 20),
            ),
            hint: Text(
              selectedLanguage == 'বাংলা' ? 'দোকানের ধরন নির্বাচন করুন' : 'Select shop type',
              style: const TextStyle(color: Color(0xFF667085)),
            ),
            items: shopTypes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}