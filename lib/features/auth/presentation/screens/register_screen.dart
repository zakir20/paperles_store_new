import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color greenColor = const Color(0xFF2EB14B);
  final Color bgColor = const Color(0xFFF1F8F1);

  // Controllers
  final _registrarNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _proprietorNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _tradeLicenseController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isProprietorSame = false;
  String? _selectedShopType;
  String? _selectedLocation;
  File? _profileImage;
  File? _tradeDocument;

  final ImagePicker _picker = ImagePicker();

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
      Get.snackbar('error'.tr, 'Please upload a profile image', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_registrarNameController.text.isEmpty) {
      Get.snackbar('error'.tr, 'registrant_name'.tr + " is required", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_shopNameController.text.isEmpty) {
      Get.snackbar('error'.tr, 'shop_name'.tr + " is required", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_phoneController.text.length < 11) {
      Get.snackbar('error'.tr, 'valid_phone'.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (!GetUtils.isEmail(_emailController.text)) {
      Get.snackbar('error'.tr, 'valid_email'.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_selectedShopType == null) {
      Get.snackbar('error'.tr, 'select_shop_type'.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_selectedLocation == null) {
      Get.snackbar('error'.tr, 'select_location'.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_passwordController.text.length < 6) {
      Get.snackbar('error'.tr, 'Password must be at least 6 characters', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar('error'.tr, 'Passwords do not match', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    context.read<AuthBloc>().add(RegisterSubmitted(
      registrantName: _registrarNameController.text,
      shopName: _shopNameController.text,
      proprietorName: _proprietorNameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      shopType: _selectedShopType!,
      address: _addressController.text,
      tradeLicense: _tradeLicenseController.text,
      password: _passwordController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: bgColor,
       appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    context.pop(); 
                  },
                ),
                title: Text(
                  'user_registration'.tr, 
                  style: const TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kalpurush', 
                  ),
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

              // 2. Registrant's Name
              _buildInputCard('registrant_name'.tr, 'enter_registrant_name'.tr, _registrarNameController, onChanged: (val) {
                if (_isProprietorSame) setState(() => _proprietorNameController.text = val);
              }),

              // 3. Shop Name
              _buildInputCard('shop_name'.tr, 'enter_shop_name'.tr, _shopNameController),

              // 4. Proprietor Name (Logic Fixed)
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

              _buildInputCard('phone_number'.tr, 'enter_phone_number'.tr, _phoneController, helperText: 'valid_phone'.tr, helperIcon: Icons.shield_outlined),
              _buildInputCard('email'.tr, 'enter_your_email'.tr, _emailController, helperText: 'valid_email'.tr, helperIcon: Icons.shield_outlined),

              // Shop Type
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('shop_type'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('select_shop_type'.tr),
                      items: ['Retail', 'Wholesale', 'Groceries'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedShopType = val),
                    ),
                  ],
                ),
              ),

              _buildInputCard('full_store_address'.tr, 'address_hint'.tr, _addressController, maxLines: 3),

              // Location
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('shop_location'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('select_location'.tr).copyWith(prefixIcon: const Icon(Icons.add_location_alt)),
                      items: ['Dhaka', 'Chittagong', 'Sylhet'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedLocation = val),
                    ),
                  ],
                ),
              ),

              // Trade License
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('trade_license'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('optional'.tr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField('trade_hint'.tr, _tradeLicenseController),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _showImageSourceActionSheet(context, false),
                      child: Row(
                        children: [
                          Icon(Icons.upload, color: greenColor, size: 20),
                          const SizedBox(width: 8),
                          Text(_tradeDocument == null ? 'upload_document'.tr : "Document Selected ✅", style: TextStyle(color: greenColor, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              _buildPasswordCard('password'.tr, 'enter_your_password'.tr, _passwordController),
              _buildPasswordCard('re_type_password'.tr, 'retype_password_hint'.tr, _confirmPasswordController),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey[300]!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text('cancel'.tr, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) Get.offAllNamed('/dashboard');
                        if (state is AuthError) Get.snackbar('error'.tr, state.message);
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading ? null : () => _validateAndSubmit(context),
                            style: ElevatedButton.styleFrom(backgroundColor: greenColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            child: state is AuthLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text('register'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: child,
    );
  }

  Widget _buildInputCard(String label, String hint, TextEditingController controller, {String? helperText, IconData? helperIcon, int maxLines = 1, Function(String)? onChanged}) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField(hint, controller, maxLines: maxLines, onChanged: onChanged),
          if (helperText != null) ...[
            const SizedBox(height: 8),
            Row(children: [if (helperIcon != null) Icon(helperIcon, size: 14), const SizedBox(width: 4), Text(helperText, style: const TextStyle(fontSize: 12))])
          ]
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
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return TextField(
                controller: controller, obscureText: !state.isPasswordVisible,
                style: const TextStyle(color: Colors.black),
                decoration: _inputDecoration(hint).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(state.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => context.read<AuthBloc>().add(TogglePasswordVisibilityEvent()),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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
      // Hint is pure black
      hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: greenColor)),
    );
  }
}