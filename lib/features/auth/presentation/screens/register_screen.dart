<<<<<<< HEAD
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart'; 
import 'package:paperless_store_upd/injection/injection_container.dart';
import '../bloc/auth_cubit.dart'; 
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
=======
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
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
<<<<<<< HEAD
  final Color greenColor = const Color(0xFF2EB14B);
  final Color bgColor = const Color(0xFFF1F8F1);

  // Controllers
  final _registrarNameController = TextEditingController();
=======
  final _fullNameController = TextEditingController();
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
  final _shopNameController = TextEditingController();
  final _proprietorNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
<<<<<<< HEAD
  final _addressController = TextEditingController();
  final _tradeLicenseController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isProprietorSame = false;
  String? _selectedShopType;
  File? _profileImage;
  File? _tradeDocument;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _registrarNameController.dispose();
    _shopNameController.dispose();
    _proprietorNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _tradeLicenseController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, bool isProfile) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(pickedFile.path);
        } else {
          _tradeDocument = File(pickedFile.path);
        }
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context, bool isProfile) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery, isProfile);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera, isProfile);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSubmit(BuildContext context) {
    if (_profileImage == null) {
      _showSnackBar('Please upload a profile image');
      return;
    }
    if (_registrarNameController.text.isEmpty) {
      _showSnackBar('registrant_name'.tr + " is required");
      return;
    }
    if (_phoneController.text.length < 11) {
      _showSnackBar('valid_phone'.tr);
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Password is required');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return;
    }

    final registrationData = {
      "registrantName": _registrarNameController.text.trim(),
      "shopName": _shopNameController.text.trim(),
      "proprietorName": _proprietorNameController.text.trim(),
      "phoneNumber": _phoneController.text.trim(),
      "email": _emailController.text.trim(),
      "shopType": _selectedShopType ?? "Retail",
      "address": _addressController.text.trim(),
      "tradeLicense": _tradeLicenseController.text.trim(),
      "password": _passwordController.text,
      "profileImagePath": _profileImage?.path, 
      "tradeLicensePath": _tradeDocument?.path,
    };

    context.read<AuthCubit>().register(registrationData);
=======
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
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(), 
          ),
          title: Text(
            'user_registration'.tr, 
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Kalpurush'),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 1. Profile Image Card
              _buildCard(
                child: Row(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[100], borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                        image: _profileImage != null ? DecorationImage(image: FileImage(_profileImage!), fit: BoxFit.cover) : null,
                      ),
                      child: _profileImage == null ? const Icon(Icons.person, size: 40, color: Colors.black87) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('profile_image'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('upload_photo'.tr, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showImageSourceActionSheet(context, true),
                      child: Text('choose'.tr, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    )
                  ],
                ),
              ),

              // 2. Name Field
              _buildInputCard('registrant_name'.tr, 'enter_registrant_name'.tr, _registrarNameController, onChanged: (val) {
                if (_isProprietorSame) setState(() => _proprietorNameController.text = val);
              }),

              // 3. Shop Name
              _buildInputCard('shop_name'.tr, 'enter_shop_name'.tr, _shopNameController),

              // 4. Proprietor Logic
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('proprietor_name'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildTextField('enter_proprietor_name'.tr, _proprietorNameController, enabled: !_isProprietorSame),
                    Row(
                      children: [
                        Checkbox(
                          value: _isProprietorSame, activeColor: greenColor,
                          onChanged: (val) {
                            setState(() {
                              _isProprietorSame = val!;
                              if (_isProprietorSame) _proprietorNameController.text = _registrarNameController.text;
                            });
                          },
                        ),
                        Expanded(child: Text('same_as_registrar'.tr, style: const TextStyle(fontSize: 12))),
                      ],
                    )
                  ],
                ),
              ),

              _buildInputCard('phone_number'.tr, 'enter_phone_number'.tr, _phoneController),
              _buildInputCard('email'.tr, 'enter_your_email'.tr, _emailController),

              // Shop Type Dropdown
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('shop_type'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('select_shop_type'.tr),
                      items: ['Retail', 'Wholesale', 'Pharmacy'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedShopType = val),
                    ),
                  ],
                ),
              ),

              _buildInputCard('full_store_address'.tr, 'address_hint'.tr, _addressController, maxLines: 2),

              _buildPasswordCard('password'.tr, 'enter_your_password'.tr, _passwordController),
              _buildPasswordCard('re_type_password'.tr, 'retype_password_hint'.tr, _confirmPasswordController),

              const SizedBox(height: 25),

              // SUBMIT BUTTON SECTION
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    _showSnackBar('Registration Successful! Please Login.', isError: false);
                    context.go('/login'); 
                  }
                  if (state is AuthError) {
                    _showSnackBar(state.message);
                  }
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 54)),
                          child: Text('cancel'.tr, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? null : () => _validateAndSubmit(context),
                          style: ElevatedButton.styleFrom(backgroundColor: greenColor, minimumSize: const Size(0, 54)),
                          child: state is AuthLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text('register'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: child,
    );
  }

  Widget _buildInputCard(String label, String hint, TextEditingController controller, {int maxLines = 1, Function(String)? onChanged}) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField(hint, controller, maxLines: maxLines, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(String label, String hint, TextEditingController controller) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return TextField(
                controller: controller, obscureText: !state.isPasswordVisible,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration(hint).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(state.isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.black),
                    onPressed: () => context.read<AuthCubit>().togglePassword(), // CALL CUBIT
                  ),
                ),
              );
            },
          ),
=======
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
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTextField(String hint, TextEditingController controller, {int maxLines = 1, bool enabled = true, Function(String)? onChanged}) {
    return TextField(
      controller: controller, maxLines: maxLines, enabled: enabled, onChanged: onChanged,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: greenColor)),
    );
  }
=======
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
>>>>>>> 80e79e0d57498f8285b6aee913ad20e8f7441117
}