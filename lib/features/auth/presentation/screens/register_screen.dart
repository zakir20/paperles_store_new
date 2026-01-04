import 'package:flutter/material.dart';
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


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String _selectedLanguage = 'English (EN)';
  String _selectedFlag = '🇺🇸';
  String? _selectedShopType;
  String? _tradeLicenseDocument;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _shopTypes = [
    'Grocery Store', 'Electronics', 'Clothing', 'Pharmacy',
    'Hardware', 'Restaurant', 'Book Store', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _locationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: RegisterAppBar(
        selectedLanguage: _selectedLanguage,
        selectedFlag: _selectedFlag,
        onBackPressed: () => Navigator.pop(context),
        onLanguagePressed: _showLanguageDialog,
        onLanguageDialog: _showLanguageDialog,
      ),
      body: _isLoading
          ? _buildLoadingScreen()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileImagePicker(
                    selectedLanguage: _selectedLanguage,
                    profileImage: _profileImage,
                    onImagePressed: _showImageSourceDialog,
                    onRemoveImage: () => setState(() => _profileImage = null),
                  ),
                  const SizedBox(height: 24),
                  _buildFormFields(),
                  const SizedBox(height: 24),
                  ShopTypeDropdown(
                    selectedLanguage: _selectedLanguage,
                    selectedShopType: _selectedShopType,
                    shopTypes: _shopTypes,
                    onChanged: (value) => setState(() => _selectedShopType = value),
                  ),
                  const SizedBox(height: 20),
                  _buildAddressFields(),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFEAECF0)),
                  const SizedBox(height: 24),
                  TradeLicenseSection(
                    selectedLanguage: _selectedLanguage,
                    licenseController: _tradeLicenseController,
                    licenseDocument: _tradeLicenseDocument,
                    onDocumentUpload: _showDocumentSourceDialog,
                    onDocumentRemove: () => setState(() => _tradeLicenseDocument = null),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFEAECF0)),
                  const SizedBox(height: 24),
                  _buildPasswordFields(),
                  const SizedBox(height: 40),
                  RegisterButton(
                    selectedLanguage: _selectedLanguage,
                    isLoading: _isLoading,
                    onPressed: _register,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Registering... Saving to JSON'),
          Text('(Working offline - No server needed)', 
               style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        RegisterFormField(
          controller: _fullNameController,
          label: _selectedLanguage == 'বাংলা' ? 'পুরো নাম' : 'Full Name',
          hint: _selectedLanguage == 'বাংলা' ? 'আপনার পুরো নাম লিখুন' : 'Enter your full name',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _shopNameController,
          label: _selectedLanguage == 'বাংলা' ? 'দোকানের নাম' : 'Shop Name',
          hint: _selectedLanguage == 'বাংলা' ? 'আপনার দোকানের নাম লিখুন' : 'Enter your shop name',
          icon: Icons.store,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _proprietorNameController,
          label: _selectedLanguage == 'বাংলা' ? 'মালিকের নাম' : 'Proprietor Name',
          hint: _selectedLanguage == 'বাংলা' ? 'মালিকের নাম লিখুন' : 'Enter proprietor name',
          icon: Icons.business_center,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _phoneController,
          label: _selectedLanguage == 'বাংলা' ? 'ফোন নম্বর' : 'Phone Number',
          hint: _selectedLanguage == 'বাংলা' ? 'আপনার ফোন নম্বর লিখুন' : 'Enter your phone number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _emailController,
          label: _selectedLanguage == 'বাংলা' ? 'ইমেইল' : 'Email',
          hint: _selectedLanguage == 'বাংলা' ? 'আপনার ইমেইল লিখুন' : 'Enter your email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterFormField(
          controller: _storeAddressController,
          label: _selectedLanguage == 'বাংলা' ? 'দোকানের ঠিকানা' : 'Store Address',
          hint: _selectedLanguage == 'বাংলা' ? 'আপনার দোকানের সম্পূর্ণ ঠিকানা লিখুন' : 'Enter your complete store address',
          icon: Icons.location_on,
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _openLocationPicker,
          child: TextField(
            readOnly: true,
            controller: _locationController,
            decoration: InputDecoration(
              labelText: _selectedLanguage == 'বাংলা' ? 'দোকানের অবস্থান' : 'Shop Location',
              labelStyle: const TextStyle(color: Color(0xFF667085)),
              floatingLabelStyle: const TextStyle(color: Color(0xFF2E90FA)),
              hintText: _selectedLanguage == 'বাংলা' ? 'অবস্থান নির্বাচন করুন' : 'Select Location',
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
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        RegisterFormField(
          controller: _passwordController,
          label: _selectedLanguage == 'বাংলা' ? 'পাসওয়ার্ড' : 'Password',
          hint: _selectedLanguage == 'বাংলা' ? 'আপনার পাসওয়ার্ড লিখুন' : 'Enter your password',
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: _isPasswordVisible,
          onPasswordVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _confirmPasswordController,
          label: _selectedLanguage == 'বাংলা' ? 'পাসওয়ার্ড নিশ্চিত করুন' : 'Confirm Password',
          hint: _selectedLanguage == 'বাংলা' ? 'পাসওয়ার্ড আবার লিখুন' : 'Re-enter your password',
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: _isConfirmPasswordVisible,
          onPasswordVisibilityToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
      ],
    );
  }

  void _showImageSourceDialog() {
    ImagePickerUtils.showImageSourceDialog(
      context: context,
      language: _selectedLanguage,
      onCameraPressed: _pickImageFromCamera,
      onGalleryPressed: _pickImageFromGallery,
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final image = await ImagePickerUtils.pickImageFromCamera(_picker, _selectedLanguage);
      if (image != null) {
        setState(() => _profileImage = image);
        FormUtils.showMessage(
          context: context,
          message: _selectedLanguage == 'বাংলা' 
              ? 'ছবি সফলভাবে তোলা হয়েছে' 
              : 'Image captured successfully',
          color: Colors.green,
        );
      }
    } catch (e) {
      FormUtils.showMessage(
        context: context,
        message: e.toString(),
        color: Colors.red,
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final image = await ImagePickerUtils.pickImageFromGallery(_picker, _selectedLanguage);
      if (image != null) {
        setState(() => _profileImage = image);
        FormUtils.showMessage(
          context: context,
          message: _selectedLanguage == 'বাংলা' 
              ? 'ছবি সফলভাবে নির্বাচিত হয়েছে' 
              : 'Image selected successfully',
          color: Colors.green,
        );
      }
    } catch (e) {
      FormUtils.showMessage(
        context: context,
        message: e.toString(),
        color: Colors.red,
      );
    }
  }

  void _showDocumentSourceDialog() {
    DocumentUploadUtils.showDocumentSourceDialog(
      context: context,
      language: _selectedLanguage,
      onCameraPressed: () => _simulateDocumentUpload('trade_license_camera.jpg'),
      onGalleryPressed: () => _simulateDocumentUpload('trade_license_gallery.jpg'),
      onFilePressed: () => _simulateDocumentUpload('trade_license_document.pdf'),
    );
  }

  void _simulateDocumentUpload(String fileName) {
    setState(() => _tradeLicenseDocument = fileName);
    FormUtils.showMessage(
      context: context,
      message: _selectedLanguage == 'বাংলা' 
          ? 'ডকুমেন্ট আপলোড করা হয়েছে: $fileName' 
          : 'Document uploaded: $fileName',
      color: Colors.green,
    );
  }

  void _openLocationPicker() {
    showDialog(
      context: context,
      builder: (context) => SimpleLocationPicker(
        selectedLanguage: _selectedLanguage,
        onLocationSelected: (location) {
          setState(() => _locationController.text = location);
        },
      ),
    );
  }

  void _showLanguageDialog() {
    LanguageUtils.showLanguageDialog(
      context: context,
      currentLanguage: _selectedLanguage,
      onLanguageChanged: (language) => setState(() => _selectedLanguage = language),
      onFlagChanged: (flag) => setState(() => _selectedFlag = flag),
    );
  }

  Future<void> _register() async {
    final validation = RegisterUtils.validateRegistration(
      fullName: _fullNameController.text,
      shopName: _shopNameController.text,
      proprietorName: _proprietorNameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      shopType: _selectedShopType,
      storeAddress: _storeAddressController.text,
      location: _locationController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      selectedLanguage: _selectedLanguage,
    );

    if (validation['valid'] == 'false') {
      FormUtils.showMessage(
        context: context,
        message: validation['message']!,
        color: Colors.orange,
      );
      return;
    }

    setState(() => _isLoading = true);

    final registrationData = RegistrationService.prepareRegistrationData(
      fullName: _fullNameController.text,
      shopName: _shopNameController.text,
      proprietorName: _proprietorNameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      shopType: _selectedShopType,
      storeAddress: _storeAddressController.text,
      location: _locationController.text,
      tradeLicense: _tradeLicenseController.text,
      tradeLicenseDocument: _tradeLicenseDocument,
      password: _passwordController.text,
      profileImagePath: _profileImage?.path,
    );

    await RegistrationService.registerUser(
      context: context,
      registrationData: registrationData,
      language: _selectedLanguage,
      onSuccess: () => Navigator.pushReplacementNamed(context, '/login'),
      clearForm: _clearForm,
    );

    setState(() => _isLoading = false);
  }

  void _clearForm() {
    FormUtils.clearForm(
      controllers: [
        _fullNameController,
        _shopNameController,
        _proprietorNameController,
        _phoneController,
        _emailController,
        _storeAddressController,
        _tradeLicenseController,
        _passwordController,
        _confirmPasswordController,
        _locationController,
      ],
      onClear: () {
        setState(() {
          _selectedShopType = null;
          _tradeLicenseDocument = null;
          _profileImage = null;
        });
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _shopNameController.dispose();
    _proprietorNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storeAddressController.dispose();
    _tradeLicenseController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}