import 'package:flutter/material.dart';

class TradeLicenseSection extends StatelessWidget {
  final String selectedLanguage;
  final TextEditingController licenseController;
  final String? licenseDocument;
  final VoidCallback onDocumentUpload;
  final VoidCallback onDocumentRemove;

  const TradeLicenseSection({
    Key? key,
    required this.selectedLanguage,
    required this.licenseController,
    required this.licenseDocument,
    required this.onDocumentUpload,
    required this.onDocumentRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedLanguage == 'বাংলা' ? 'ট্রেড লাইসেন্স' : 'Trade License',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          selectedLanguage == 'বাংলা' ? 'ঐচ্ছিক' : 'Optional',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 12),
        _buildLicenseNumberField(),
        const SizedBox(height: 12),
        _buildDocumentUpload(),
      ],
    );
  }

  Widget _buildLicenseNumberField() {
    return TextField(
      controller: licenseController,
      decoration: InputDecoration(
        labelText: selectedLanguage == 'বাংলা' ? 'ট্রেড লাইসেন্স নম্বর' : 'Trade License Number',
        labelStyle: const TextStyle(color: Color(0xFF667085)),
        floatingLabelStyle: const TextStyle(color: Color(0xFF2E90FA)),
        hintText: selectedLanguage == 'বাংলা' ? 'ট্রেড লাইসেন্স নম্বর লিখুন' : 'Enter trade license number',
        hintStyle: const TextStyle(color: Color(0xFF667085), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2E90FA)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        prefixIcon: const Icon(Icons.description, color: Color(0xFF667085), size: 20),
      ),
    );
  }

  Widget _buildDocumentUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedLanguage == 'বাংলা' ? 'ট্রেড লাইসেন্স ডকুমেন্ট' : 'Trade License Document',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF344054),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onDocumentUpload,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: licenseDocument != null ? Colors.green : const Color(0xFFD0D5DD),
                width: licenseDocument != null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: licenseDocument != null ? Colors.green[50] : Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  licenseDocument != null ? Icons.check_circle : Icons.upload_file,
                  color: licenseDocument != null ? Colors.green : const Color(0xFF667085),
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  licenseDocument != null 
                      ? licenseDocument!
                      : selectedLanguage == 'বাংলা' ? 'ডকুমেন্ট আপলোড করুন' : 'Upload Document',
                  style: TextStyle(
                    color: licenseDocument != null ? Colors.green : const Color(0xFF667085),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (licenseDocument != null)
                  TextButton(
                    onPressed: onDocumentRemove,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      backgroundColor: Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      selectedLanguage == 'বাংলা' ? 'মুছে ফেলুন' : 'Remove',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}