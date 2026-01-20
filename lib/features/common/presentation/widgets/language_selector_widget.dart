import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:paperless_store_upd/core/bloc/language_cubit.dart';
import 'package:paperless_store_upd/core/bloc/language_state.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        return PopupMenuButton<String>(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          offset: const Offset(0, 50),
          elevation: 4,
          onSelected: (String newValue) {
            context.read<LanguageCubit>().changeLanguage(context, newValue);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'en_US',
              child: Row(
                children: [
                  const Text("🇺🇸", style: TextStyle(fontSize: 20)),
                  const Gap(12),
                  const Expanded(
                      child: Text("English (EN)",
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600))),
                  if (langState.localeCode == 'en_US')
                    const Icon(Icons.check, color: AppColors.primary, size: 20),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'bn_BD',
              child: Row(
                children: [
                  const Text("🇧🇩", style: TextStyle(fontSize: 20)),
                  const Gap(12),
                  const Expanded(
                      child: Text("বাংলা (BN)",
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600))),
                  if (langState.localeCode == 'bn_BD')
                    const Icon(Icons.check, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardWhite.withAlpha(204),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(langState.flag, style: const TextStyle(fontSize: 18)),
                const Gap(8),
                Text(
                  langState.localeCode == 'en_US' ? "EN" : "BN",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.black),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    size: 18, color: AppColors.greyText),
              ],
            ),
          ),
        );
      },
    );
  }
}
