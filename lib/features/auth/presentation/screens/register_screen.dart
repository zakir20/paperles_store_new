import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';
import 'package:paperless_store_upd/core/bloc/language_cubit.dart';
import 'package:paperless_store_upd/core/bloc/language_state.dart';
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import '../bloc/register_cubit.dart';
import '../bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  void _showMsg(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.primary,
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
                context.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera, isProfile);
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSubmit(BuildContext context) {
    if (_profileImage == null) {
      _showMsg("Please upload a profile image");
      return;
    }
    if (_registrarNameController.text.isEmpty) {
      _showMsg("registrant_name".tr() + " is required");
      return;
    }
    if (_phoneController.text.length < 11) {
      _showMsg("valid_phone".tr());
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showMsg("Password is required");
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

    // 2. CALL REGISTER CUBIT
    context.read<RegisterCubit>().register(registrationData);
  }

  @override
  Widget build(BuildContext context) {
    // 3. PROVIDE REGISTER CUBIT
    return BlocProvider<RegisterCubit>(
      create: (context) => sl<RegisterCubit>(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, langState) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            appBar: AppBar(
              backgroundColor: AppColors.cardWhite,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'user_registration'.tr(),
                style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kalpurush'),
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
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.greyBorder),
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                          child: _profileImage == null
                              ? const Icon(Icons.person,
                                  size: 40, color: AppColors.black)
                              : null,
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('profile_image'.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('upload_photo'.tr(),
                                  style: const TextStyle(
                                      color: AppColors.greyText, fontSize: 13)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              _showImageSourceActionSheet(context, true),
                          child: Text('choose'.tr(),
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        )
                      ],
                    ),
                  ),

                  // 2. Name Field
                  _buildInputCard('registrant_name'.tr(), 'enter_registrant_name'.tr(),
                      _registrarNameController, onChanged: (val) {
                    if (_isProprietorSame) {
                      setState(() => _proprietorNameController.text = val);
                    }
                  }),

                  // 3. Shop Name
                  _buildInputCard(
                      'shop_name'.tr(), 'enter_shop_name'.tr(), _shopNameController),

                  // 4. Proprietor Logic
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('proprietor_name'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Gap(8),
                        _buildTextField(
                            'enter_proprietor_name'.tr(), _proprietorNameController,
                            enabled: !_isProprietorSame),
                        Row(
                          children: [
                            Checkbox(
                              value: _isProprietorSame,
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                setState(() {
                                  _isProprietorSame = val!;
                                  if (_isProprietorSame) {
                                    _proprietorNameController.text =
                                        _registrarNameController.text;
                                  }
                                });
                              },
                            ),
                            Expanded(
                                child: Text('same_as_registrar'.tr(),
                                    style: const TextStyle(fontSize: 12))),
                          ],
                        )
                      ],
                    ),
                  ),

                  _buildInputCard(
                      'phone_number'.tr(), 'enter_phone_number'.tr(), _phoneController),
                  _buildInputCard(
                      'email'.tr(), 'enter_your_email'.tr(), _emailController),

                  // Shop Type Dropdown
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('shop_type'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Gap(8),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration('select_shop_type'.tr()),
                          items: ['Retail', 'Wholesale', 'Pharmacy']
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedShopType = val),
                        ),
                      ],
                    ),
                  ),

                  _buildInputCard('full_store_address'.tr(), 'address_hint'.tr(),
                      _addressController,
                      maxLines: 2),

                  _buildPasswordCard('password'.tr(), 'enter_your_password'.tr(),
                      _passwordController),
                  _buildPasswordCard('re_type_password'.tr(),
                      'retype_password_hint'.tr(), _confirmPasswordController),

                  const Gap(25),

                  // 4. SUBMIT BUTTON SECTION WITH RegisterCubit
                  BlocConsumer<RegisterCubit, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterSuccess) {
                        _showMsg('Registration Successful! Please Login.',
                            isError: false);
                        context.go('/login');
                      }
                      if (state is RegisterError) {
                        _showMsg(state.message);
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 54),
                                  side: const BorderSide(color: AppColors.greyBorder)),
                              child: Text('cancel'.tr(),
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const Gap(15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: state is RegisterLoading
                                  ? null
                                  : () => _validateAndSubmit(context),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: const Size(0, 54)),
                              child: state is RegisterLoading
                                  ? const SizedBox(
                                      height: 20, width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text('register'.tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Gap(50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 4)
          ]),
      child: child,
    );
  }

  Widget _buildInputCard(String label, String hint, TextEditingController controller,
      {int maxLines = 1, Function(String)? onChanged}) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Gap(8),
          _buildTextField(hint, controller,
              maxLines: maxLines, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildPasswordCard(
      String label, String hint, TextEditingController controller) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Gap(8),
          // 5. USE REGISTER CUBIT FOR PASSWORD TOGGLE
          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              return TextField(
                controller: controller,
                obscureText: !state.isPasswordVisible,
                style: const TextStyle(color: AppColors.black),
                decoration: _inputDecoration(hint).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                        state.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.black),
                    onPressed: () =>
                        context.read<RegisterCubit>().togglePassword(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {int maxLines = 1, bool enabled = true, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w500),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.black, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.greyBorder)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.greyBorder)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary)),
    );
  }
}