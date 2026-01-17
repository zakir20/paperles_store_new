import 'package:flutter/material.dart';

class SimpleLocationPicker extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLocationSelected;

  const SimpleLocationPicker({
    Key? key,
    required this.selectedLanguage,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(selectedLanguage == 'বাংলা' ? 'অবস্থান নির্বাচন করুন' : 'Select Location'),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Dhaka - Basabo'),
              onTap: () {
                onLocationSelected('Dhaka - Basabo');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Dhaka - Mirpur'),
              onTap: () {
                onLocationSelected('Dhaka - Mirpur');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Dhaka - Dhanmondi'),
              onTap: () {
                onLocationSelected('Dhaka - Dhanmondi');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Chittagong'),
              onTap: () {
                onLocationSelected('Chittagong');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}