import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======

class LanguageSelector extends StatefulWidget {
  final String selectedLanguage;
  final String selectedFlag;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onFlagChanged;

  const LanguageSelector({
    Key? key,
    required this.selectedLanguage,
    required this.selectedFlag,
    required this.onLanguageChanged,
    required this.onFlagChanged,
  }) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
              title: const Text('English (EN)'),
              onTap: () {
                widget.onLanguageChanged('English (EN)');
                widget.onFlagChanged('🇺🇸');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇧🇩', style: TextStyle(fontSize: 20)),
              title: const Text('বাংলা', style: TextStyle(fontFamily: 'Kalpurush')),
              onTap: () {
                widget.onLanguageChanged('বাংলা');
                widget.onFlagChanged('🇧🇩');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD0D5DD)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(widget.selectedFlag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              widget.selectedLanguage,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF344054),
                fontWeight: FontWeight.w500,
                fontFamily: widget.selectedLanguage == 'বাংলা' ? 'Kalpurush' : null,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF667085), size: 20),
          ],
        ),
      ),
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
    );
  }
}