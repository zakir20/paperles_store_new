import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart';
import '../widgets/register/register_app_bar.dart';
import '../widgets/register/profile_image_picker.dart';
import '../widgets/register/form_field_builder.dart';
import '../widgets/register/shop_type_dropdown.dart';
import '../widgets/register/trade_license_section.dart';
import '../widgets/register/register_button.dart';
import '../../utils/register_utils.dart';
import '../../utils/image_picker_utils.dart';
import '../../utils/form_utils.dart';
import '../../utils/language_utils.dart';
import '../../utils/document_upload_utils.dart';
import '../../utils/registration_service.dart';
import 'simple_location_picker.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  
  // GetX Controller
  final RegisterController registerController = Get.put(RegisterController());
  
  final _fullNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _proprietorNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _tradeLicenseController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final List<String> _shopTypes = [
    'Grocery Store', 'Electronics', 'Clothing', 'Pharmacy',
    'Hardware', 'Restaurant', 'Book Store', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: RegisterAppBar(
        selectedLanguage: registerController.selectedLanguage.value,
        selectedFlag: registerController.selectedFlag.value,
        onBackPressed: () => Get.back(),
        onLanguagePressed: () => _showLanguageDialog(context),
        onLanguageDialog: () => _showLanguageDialog(context),
      ),
      body: Obx(() => registerController.isLoading.value
          ? _buildLoadingScreen()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileImagePicker(
                    selectedLanguage: registerController.selectedLanguage.value,
                    profileImage: registerController.profileImage.value,
                    onImagePressed: () => _showImageSourceDialog(context),
                    onRemoveImage: () => registerController.profileImage.value = null,
                  ),
                  const SizedBox(height: 24),
                  _buildFormFields(),
                  const SizedBox(height: 24),
                  ShopTypeDropdown(
                    selectedLanguage: registerController.selectedLanguage.value,
                    selectedShopType: registerController.selectedShopType.value,
                    shopTypes: _shopTypes,
                    onChanged: (value) => registerController.selectedShopType.value = value,
                  ),
                  const SizedBox(height: 20),
                  _buildAddressFields(context),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFEAECF0)),
                  const SizedBox(height: 24),
                  TradeLicenseSection(
                    selectedLanguage: registerController.selectedLanguage.value,
                    licenseController: _tradeLicenseController,
                    licenseDocument: registerController.tradeLicenseDocument.value,
                    onDocumentUpload: () => _showDocumentSourceDialog(context),
                    onDocumentRemove: () => registerController.tradeLicenseDocument.value = null,
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFEAECF0)),
                  const SizedBox(height: 24),
                  _buildPasswordFields(),
                  const SizedBox(height: 40),
                  RegisterButton(
                    selectedLanguage: registerController.selectedLanguage.value,
                    isLoading: registerController.isLoading.value,
                    onPressed: _register,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Obx(() => Text(
            registerController.selectedLanguage.value == 'বাংলা' 
                ? 'নিবন্ধন করা হচ্ছে... JSON এ সংরক্ষণ করা হচ্ছে'
                : 'Registering... ',
          )),
          const Text('(Working offline - No server needed)', 
               style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Obx(() => Column(
      children: [
        RegisterFormField(
          controller: _fullNameController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'পুরো নাম' : 'Full Name',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'আপনার পুরো নাম লিখুন' : 'Enter your full name',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _shopNameController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'দোকানের নাম' : 'Shop Name',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'আপনার দোকানের নাম লিখুন' : 'Enter your shop name',
          icon: Icons.store,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _proprietorNameController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'মালিকের নাম' : 'Proprietor Name',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'মালিকের নাম লিখুন' : 'Enter proprietor name',
          icon: Icons.business_center,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _phoneController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'ফোন নম্বর' : 'Phone Number',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'আপনার ফোন নম্বর লিখুন' : 'Enter your phone number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _emailController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'ইমেইল' : 'Email',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'আপনার ইমেইল লিখুন' : 'Enter your email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    ));
  }

  Widget _buildAddressFields(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterFormField(
          controller: _storeAddressController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'দোকানের ঠিকানা' : 'Store Address',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'আপনার দোকানের সম্পূর্ণ ঠিকানা লিখুন' : 'Enter your complete store address',
          icon: Icons.location_on,
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _openLocationPicker(context),
          child: TextField(
            readOnly: true,
            controller: _locationController,
            decoration: InputDecoration(
              labelText: registerController.selectedLanguage.value == 'বাংলা' ? 'দোকানের অবস্থান' : 'Shop Location',
              labelStyle: const TextStyle(color: Color(0xFF667085)),
              floatingLabelStyle: const TextStyle(color: Color(0xFF2E90FA)),
              hintText: registerController.selectedLanguage.value == 'বাংলা' ? 'অবস্থান নির্বাচন করুন' : 'Select Location',
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
              prefixIcon: const Icon(Icons.location_on, color: Color(0xFF667085), size: 20),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF667085)),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildPasswordFields() {
    return Obx(() => Column(
      children: [
        RegisterFormField(
          controller: _passwordController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'পাসওয়ার্ড' : 'Password',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'আপনার পাসওয়ার্ড লিখুন' : 'Enter your password',
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: registerController.isPasswordVisible.value,
          onPasswordVisibilityToggle: () => registerController.isPasswordVisible.value = !registerController.isPasswordVisible.value,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _confirmPasswordController,
          label: registerController.selectedLanguage.value == 'বাংলা' ? 'পাসওয়ার্ড নিশ্চিত করুন' : 'Confirm Password',
          hint: registerController.selectedLanguage.value == 'বাংলা' ? 'পাসওয়ার্ড আবার লিখুন' : 'Re-enter your password',
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: registerController.isConfirmPasswordVisible.value,
          onPasswordVisibilityToggle: () => registerController.isConfirmPasswordVisible.value = !registerController.isConfirmPasswordVisible.value,
        ),
      ],
    ));
  }

  void _showImageSourceDialog(BuildContext context) {
    ImagePickerUtils.showImageSourceDialog(
      context: context,
      language: registerController.selectedLanguage.value,
      onCameraPressed: () => _pickImageFromCamera(context),
      onGalleryPressed: () => _pickImageFromGallery(context),
    );
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    try {
      final image = await ImagePickerUtils.pickImageFromCamera(_picker, registerController.selectedLanguage.value);
      if (image != null) {
        registerController.profileImage.value = image;
        Get.snackbar(
          registerController.selectedLanguage.value == 'বাংলা' ? 'সফল' : 'Success',
          registerController.selectedLanguage.value == 'বাংলা' 
              ? 'ছবি সফলভাবে তোলা হয়েছে' 
              : 'Image captured successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        registerController.selectedLanguage.value == 'বাংলা' ? 'ত্রুটি' : 'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    try {
      final image = await ImagePickerUtils.pickImageFromGallery(_picker, registerController.selectedLanguage.value);
      if (image != null) {
        registerController.profileImage.value = image;
        Get.snackbar(
          registerController.selectedLanguage.value == 'বাংলা' ? 'সফল' : 'Success',
          registerController.selectedLanguage.value == 'বাংলা' 
              ? 'ছবি সফলভাবে নির্বাচিত হয়েছে' 
              : 'Image selected successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        registerController.selectedLanguage.value == 'বাংলা' ? 'ত্রুটি' : 'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  void _showDocumentSourceDialog(BuildContext context) {
    DocumentUploadUtils.showDocumentSourceDialog(
      context: context,
      language: registerController.selectedLanguage.value,
      onCameraPressed: () => _simulateDocumentUpload('trade_license_camera.jpg'),
      onGalleryPressed: () => _simulateDocumentUpload('trade_license_gallery.jpg'),
      onFilePressed: () => _simulateDocumentUpload('trade_license_document.pdf'),
    );
  }

  void _simulateDocumentUpload(String fileName) {
    registerController.tradeLicenseDocument.value = fileName;
    Get.snackbar(
      registerController.selectedLanguage.value == 'বাংলা' ? 'সফল' : 'Success',
      registerController.selectedLanguage.value == 'বাংলা' 
          ? 'ডকুমেন্ট আপলোড করা হয়েছে: $fileName' 
          : 'Document uploaded: $fileName',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
  }

  void _openLocationPicker(BuildContext context) {
  // Test if the problem is in SimpleLocationPicker
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Obx(() => Text(
        registerController.selectedLanguage.value == 'বাংলা' 
          ? 'অবস্থান নির্বাচন করুন' 
          : 'Select Location'
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Dhaka, Bangladesh'),
            onTap: () {
              _locationController.text = 'Dhaka, Bangladesh';
              Navigator.pop(context); // Close dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Chittagong, Bangladesh'),
            onTap: () {
              _locationController.text = 'Chittagong, Bangladesh';
              Navigator.pop(context); // Close dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Sylhet, Bangladesh'),
            onTap: () {
              _locationController.text = 'Sylhet, Bangladesh';
              Navigator.pop(context); // Close dialog
            },
          ),
        ],
      ),
    ),
  );
}

  void _showLanguageDialog(BuildContext context) {
    LanguageUtils.showLanguageDialog(
      context: context,
      currentLanguage: registerController.selectedLanguage.value,
      onLanguageChanged: (language) => registerController.selectedLanguage.value = language,
      onFlagChanged: (flag) => registerController.selectedFlag.value = flag,
    );
  }

  Future<void> _register() async {
    // Simple validation
    if (_fullNameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      Get.snackbar(
        registerController.selectedLanguage.value == 'বাংলা' ? 'সতর্কতা' : 'Warning',
        registerController.selectedLanguage.value == 'বাংলা' 
            ? 'দয়া করে প্রয়োজনীয় তথ্য পূরণ করুন' 
            : 'Please fill required information',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
      );
      return;
    }

    // Use GetX controller to handle registration
    await registerController.register(
      fullName: _fullNameController.text,
      shopName: _shopNameController.text,
      proprietorName: _proprietorNameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      storeAddress: _storeAddressController.text,
      location: _locationController.text,
      tradeLicense: _tradeLicenseController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }
}