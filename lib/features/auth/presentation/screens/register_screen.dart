import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
import '../../../../core/controllers/language_controller.dart';
import '../../../../core/services/json_registration.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => ProfileImagePicker(
                  selectedLanguage: registerController.selectedLanguage.value,
                  profileImage: registerController.profileImage.value,
                  onImagePressed: () => _showImageSourceDialog(context),
                  onRemoveImage: () => registerController.profileImage.value = null,
                )),
                const SizedBox(height: 24),
                _buildFormFields(),
                const SizedBox(height: 24),
                Obx(() => ShopTypeDropdown(
                  selectedLanguage: registerController.selectedLanguage.value,
                  selectedShopType: registerController.selectedShopType.value,
                  shopTypes: _shopTypes,
                  onChanged: (value) => registerController.selectedShopType.value = value,
                )),
                const SizedBox(height: 20),
                _buildAddressFields(context),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAECF0)),
                const SizedBox(height: 24),
                Obx(() => TradeLicenseSection(
                  selectedLanguage: registerController.selectedLanguage.value,
                  licenseController: _tradeLicenseController,
                  licenseDocument: registerController.tradeLicenseDocument.value,
                  onDocumentUpload: () => _showDocumentSourceDialog(context),
                  onDocumentRemove: () => registerController.tradeLicenseDocument.value = null,
                )),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAECF0)),
                const SizedBox(height: 24),
                _buildPasswordFields(),
                const SizedBox(height: 40),
                Obx(() => RegisterButton(
                  selectedLanguage: registerController.selectedLanguage.value,
                  isLoading: registerController.isLoading.value,
                  onPressed: _register,
                )),
                const SizedBox(height: 20),
              ],
            ),
          ),
          
          Obx(() {
            if (registerController.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text('registering'.tr),
                      const SizedBox(height: 8),
                      const Text(
                        '(Working offline - No server needed)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        RegisterFormField(
          controller: _fullNameController,
          label: 'fullName'.tr,
          hint: 'enterFullName'.tr,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _shopNameController,
          label: 'shopName'.tr,
          hint: 'enterShopName'.tr,
          icon: Icons.store,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _proprietorNameController,
          label: 'proprietorName'.tr,
          hint: 'enterProprietorName'.tr,
          icon: Icons.business_center,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _phoneController,
          label: 'phoneNumber'.tr,
          hint: 'enterPhoneNumber'.tr,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        RegisterFormField(
          controller: _emailController,
          label: 'email'.tr,
          hint: 'enterEmail'.tr,
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildAddressFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterFormField(
          controller: _storeAddressController,
          label: 'storeAddress'.tr,
          hint: 'enterStoreAddress'.tr,
          icon: Icons.location_on,
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _openLocationPicker(context),
          child: AbsorbPointer(
            child: TextField(
              readOnly: true,
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'shopLocation'.tr,
                labelStyle: TextStyle(
                  color: _locationController.text.isEmpty ? Colors.red : Color(0xFF667085),
                  fontWeight: _locationController.text.isEmpty ? FontWeight.normal : FontWeight.bold,
                ),
                hintText: 'selectLocation'.tr,
                hintStyle: const TextStyle(color: Color(0xFF667085), fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _locationController.text.isEmpty ? Colors.red : Color(0xFFD0D5DD),
                    width: _locationController.text.isEmpty ? 2 : 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _locationController.text.isEmpty ? Colors.red : Color(0xFF2E90FA),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                prefixIcon: Icon(
                  Icons.location_on, 
                  color: _locationController.text.isEmpty ? Colors.red : Color(0xFF667085), 
                  size: 20
                ),
                suffixIcon: Icon(
                  _locationController.text.isEmpty ? Icons.arrow_drop_down : Icons.check_circle,
                  color: _locationController.text.isEmpty ? Color(0xFF667085) : Colors.green,
                ),
                filled: _locationController.text.isNotEmpty,
                fillColor: _locationController.text.isNotEmpty ? Colors.green[50] : null,
              ),
            ),
          ),
        ),
        if (_locationController.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              '⚠️ Please select a location',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (_locationController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              '✅ Selected: ${_locationController.text}',
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        Obx(() => RegisterFormField(
          controller: _passwordController,
          label: 'password'.tr,
          hint: 'enterPassword'.tr,
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: registerController.isPasswordVisible.value,
          onPasswordVisibilityToggle: () => registerController.isPasswordVisible.toggle(),
        )),
        const SizedBox(height: 20),
        Obx(() => RegisterFormField(
          controller: _confirmPasswordController,
          label: 'confirmPassword'.tr,
          hint: 'reEnterPassword'.tr,
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: registerController.isConfirmPasswordVisible.value,
          onPasswordVisibilityToggle: () => registerController.isConfirmPasswordVisible.toggle(),
        )),
      ],
    );
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
          'success'.tr,
          'imageCapturedSuccessfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'cameraError'.tr}: $e',
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
          'success'.tr,
          'imageSelectedSuccessfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'galleryError'.tr}: $e',
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
      'success'.tr,
      'documentUploaded'.tr.replaceAll('{fileName}', fileName),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
  }

  void _openLocationPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('selectLocation'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Dhaka, Bangladesh'),
              onTap: () {
                setState(() {
                  _locationController.text = 'Dhaka, Bangladesh';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Chittagong, Bangladesh'),
              onTap: () {
                setState(() {
                  _locationController.text = 'Chittagong, Bangladesh';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Sylhet, Bangladesh'),
              onTap: () {
                setState(() {
                  _locationController.text = 'Sylhet, Bangladesh';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('selectLanguage'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸'),
              title: Text('english'.tr),
              onTap: () {
                registerController.selectedLanguage.value = 'English';
                registerController.selectedFlag.value = '🇺🇸';
                Get.find<LanguageController>().changeLanguage('English', '🇺🇸', 'en_US');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇧🇩'),
              title: Text('bangla'.tr),
              onTap: () {
                registerController.selectedLanguage.value = 'বাংলা';
                registerController.selectedFlag.value = '🇧🇩';
                Get.find<LanguageController>().changeLanguage('বাংলা', '🇧🇩', 'bn_BD');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    // Check ALL required fields
    if (_fullNameController.text.isEmpty) {
      Get.snackbar('Missing Information', 'Full Name is required', backgroundColor: Colors.orange);
      return;
    }
    if (_emailController.text.isEmpty) {
      Get.snackbar('Missing Information', 'Email is required', backgroundColor: Colors.orange);
      return;
    }
    if (_passwordController.text.isEmpty) {
      Get.snackbar('Missing Information', 'Password is required', backgroundColor: Colors.orange);
      return;
    }
    if (_locationController.text.isEmpty) {
      Get.snackbar('Missing Information', 'Please select shop location', backgroundColor: Colors.orange);
      return;
    }
    if (_tradeLicenseController.text.isEmpty) {
      Get.snackbar('Missing Information', 'Trade License is required', backgroundColor: Colors.orange);
      return;
    }

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