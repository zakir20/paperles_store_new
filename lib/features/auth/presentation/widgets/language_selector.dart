import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/bloc/language_bloc.dart';  
import '../../../../core/bloc/language_event.dart'; 

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2EB14B), width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: state.localeCode,
              icon: Icon(Icons.arrow_drop_down,
                  color: const Color(0xFF2EB14B), size: 20),
              iconSize: 20,
              style: TextStyle(
                color: const Color(0xFF2EB14B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  context.read<LanguageBloc>().add(
                    ChangeLanguageEvent(localeCode: newValue),
                  );
                  
                  if (newValue == 'bn_BD') {
                    Get.updateLocale(const Locale('bn', 'BD'));
                  } else {
                    Get.updateLocale(const Locale('en', 'US'));
                  }
                }
              },
              items: <String>['en_US', 'bn_BD'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Text(value == 'en_US' ? '🇺🇸' : '🇧🇩'),
                      const SizedBox(width: 6),
                      Text(
                        value == 'en_US' ? 'English' : 'বাংলা',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}