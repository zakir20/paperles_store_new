import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Form controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _skuCodeController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _lowStockThresholdController = TextEditingController();
  final TextEditingController _vatPercentageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dropdown values
  String? _selectedCategory;
  String? _selectedBrand;
  String? _selectedSupplier;
  String? _selectedUnit;

  // Lists for dropdowns
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _brands = [];
  List<Map<String, dynamic>> _suppliers = [];
  
  // Unit options
  final List<String> _unitOptions = [
    'Piece',
    'Kilogram',
    'Gram',
    'Liter',
    'Milliliter',
    'Box',
    'Pack',
    'Carton',
    'Dozen'
  ];

  // Product images
  final List<File> _productImages = [];
  final ImagePicker _picker = ImagePicker();
  
  // Loading states
  bool _isLoadingCategories = false;
  bool _isLoadingBrands = false;
  bool _isLoadingSuppliers = false;
  bool _isSavingProduct = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingCategories = true;
      _isLoadingBrands = true;
      _isLoadingSuppliers = true;
    });

    try {
      // Load all data in parallel
      final categoriesFuture = ApiService.getAllCategories();
      final brandsFuture = ApiService.getAllBrands();
      final suppliersFuture = ApiService.getAllSuppliers();

      final results = await Future.wait([
        categoriesFuture,
        brandsFuture,
        suppliersFuture,
      ]);

      setState(() {
        _categories = results[0];
        _brands = results[1];
        _suppliers = results[2];
        
        _isLoadingCategories = false;
        _isLoadingBrands = false;
        _isLoadingSuppliers = false;
      });

      print('📊 Loaded: ${_categories.length} categories, ${_brands.length} brands, ${_suppliers.length} suppliers');
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
        _isLoadingBrands = false;
        _isLoadingSuppliers = false;
      });
      _showErrorMessage('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isSavingProduct
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Saving product to JSON storage...'),
                  Text('(Working offline - No server needed)', 
                       style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Title
                  const Center(
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Product Image Section
                  const Text(
                    'Product image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Take images using the camera or\nupload existing product photos from your device',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Image Grid
                  _buildImageGrid(),
                  
                  const SizedBox(height: 24),

                  // Basic Details Section
                  _buildSectionHeader('Basic Details', isRequired: true),
                  
                  // Product Name Field
                  _buildTextFieldWithIcon(
                    controller: _productNameController,
                    label: 'Product Name',
                    icon: Icons.shopping_bag,
                    hintText: 'Enter product name',
                    isRequired: true,
                  ),
                  
                  const SizedBox(height: 16),

                  // Category Dropdown
                  _buildDropdownWithIcon(
                    value: _selectedCategory,
                    label: 'Select Category',
                    icon: Icons.category,
                    hint: 'Select category',
                    isLoading: _isLoadingCategories,
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['name'],
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),

                  // Brand Dropdown
                  _buildDropdownWithIcon(
                    value: _selectedBrand,
                    label: 'Select Brand',
                    icon: Icons.branding_watermark,
                    hint: 'Select brand',
                    isLoading: _isLoadingBrands,
                    items: _brands.map((brand) {
                      return DropdownMenuItem<String>(
                        value: brand['name'],
                        child: Text(brand['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBrand = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),

                  // Supplier Dropdown
                  _buildDropdownWithIcon(
                    value: _selectedSupplier,
                    label: 'Select Supplier',
                    icon: Icons.person,
                    hint: 'Select supplier',
                    isLoading: _isLoadingSuppliers,
                    items: _suppliers.map((supplier) {
                      return DropdownMenuItem<String>(
                        value: supplier['name'],
                        child: Text(supplier['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplier = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),

                  // SKU/Code Field
                  _buildTextFieldWithIcon(
                    controller: _skuCodeController,
                    label: 'SKU / Code',
                    icon: Icons.code,
                    hintText: 'Enter SKU or product code',
                    isRequired: true,
                  ),

                  const SizedBox(height: 24),

                  // Unit, Pricing, Stock Info Section
                  _buildSectionHeader('Unit, Pricing, Stock Info', isRequired: true),
                  
                  // Unit Dropdown
                  _buildDropdownWithIcon(
                    value: _selectedUnit,
                    label: 'Select Unit',
                    icon: Icons.scale,
                    hint: 'Select unit',
                    isLoading: false,
                    items: _unitOptions.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUnit = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),

                  // Cost Price and Selling Price Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFieldWithIcon(
                          controller: _costPriceController,
                          label: 'Cost Price',
                          icon: Icons.attach_money,
                          hintText: '0.00',
                          isRequired: true,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFieldWithIcon(
                          controller: _sellingPriceController,
                          label: 'Selling Price',
                          icon: Icons.money,
                          hintText: '0.00',
                          isRequired: true,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  // Low Stock Threshold
                  _buildTextFieldWithIcon(
                    controller: _lowStockThresholdController,
                    label: 'Low Stock Threshold',
                    icon: Icons.warning,
                    hintText: 'Enter minimum stock level',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 24),

                  // VAT Section (Optional)
                  _buildSectionHeader('VAT', isRequired: false),
                  
                  _buildTextFieldWithIcon(
                    controller: _vatPercentageController,
                    label: 'VAT Percentage %',
                    icon: Icons.percent,
                    hintText: '0.00',
                    isRequired: false,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 24),

                  // Description Section (Optional)
                  _buildSectionHeader('Description', isRequired: false),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter product description (optional)',
                        hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save Product',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildImageGrid() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Image grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _productImages.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == _productImages.length) {
                // Add image button
                return GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFF9FAFB),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, color: Color(0xFF6B7280), size: 30),
                        SizedBox(height: 4),
                        Text(
                          'Add Image',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Display uploaded image
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_productImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _productImages.removeAt(index);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          
          // Image count indicator
          if (_productImages.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFD1D5DB))),
              ),
              child: Text(
                '${_productImages.length} image${_productImages.length > 1 ? 's' : ''} selected',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

Widget _buildSectionHeader(String title, {required bool isRequired}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(width: 4),
        if (isRequired)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Required',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF6B7280),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Optional',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    ), // ← This closes the Padding widget
  ); // ← This closes the return statement
}

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
    required bool isRequired,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Icon(icon, color: const Color(0xFF6B7280), size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownWithIcon({
  required String? value,
  required String label,
  required IconData icon,
  required String hint,
  required bool isLoading,
  required List<DropdownMenuItem<String>> items,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Icon(icon, color: const Color(0xFF6B7280), size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: value,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                hint: Text(
                  isLoading ? 'Loading...' : hint,
                  style: const TextStyle(color: Color(0xFF9CA3AF)),
                ),
                items: items,
                onChanged: isLoading ? null : onChanged,
                isExpanded: true,
              ),
            ),
          ],
        ),
      ), // ← THIS WAS MISSING
    ],
  );
}

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Product Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF10B981)),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF10B981)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _productImages.add(File(image.path));
        });
      }
    } catch (e) {
      _showErrorMessage('Camera error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (images != null) {
        setState(() {
          for (final image in images) {
            _productImages.add(File(image.path));
          }
        });
      }
    } catch (e) {
      _showErrorMessage('Gallery error: $e');
    }
  }

  void _saveProduct() async {
    // Validate required fields
    if (_productNameController.text.isEmpty) {
      _showErrorMessage('Please enter product name');
      return;
    }

    if (_selectedCategory == null) {
      _showErrorMessage('Please select a category');
      return;
    }

    if (_selectedBrand == null) {
      _showErrorMessage('Please select a brand');
      return;
    }

    if (_selectedSupplier == null) {
      _showErrorMessage('Please select a supplier');
      return;
    }

    if (_skuCodeController.text.isEmpty) {
      _showErrorMessage('Please enter SKU/Code');
      return;
    }

    if (_selectedUnit == null) {
      _showErrorMessage('Please select a unit');
      return;
    }

    if (_costPriceController.text.isEmpty) {
      _showErrorMessage('Please enter cost price');
      return;
    }

    if (_sellingPriceController.text.isEmpty) {
      _showErrorMessage('Please enter selling price');
      return;
    }

    if (_lowStockThresholdController.text.isEmpty) {
      _showErrorMessage('Please enter low stock threshold');
      return;
    }

    // Validate numeric fields
    final costPrice = double.tryParse(_costPriceController.text);
    final sellingPrice = double.tryParse(_sellingPriceController.text);
    final lowStockThreshold = int.tryParse(_lowStockThresholdController.text);
    final vatPercentage = _vatPercentageController.text.isNotEmpty 
        ? double.tryParse(_vatPercentageController.text) 
        : 0.0;

    if (costPrice == null || costPrice <= 0) {
      _showErrorMessage('Please enter a valid cost price');
      return;
    }

    if (sellingPrice == null || sellingPrice <= 0) {
      _showErrorMessage('Please enter a valid selling price');
      return;
    }

    if (lowStockThreshold == null || lowStockThreshold <= 0) {
      _showErrorMessage('Please enter a valid low stock threshold');
      return;
    }

    if (vatPercentage != null && (vatPercentage < 0 || vatPercentage > 100)) {
      _showErrorMessage('VAT percentage must be between 0 and 100');
      return;
    }

    setState(() {
      _isSavingProduct = true;
    });

    try {
      // Create product object
      final productData = {
        'name': _productNameController.text.trim(),
        'category': _selectedCategory,
        'brand': _selectedBrand,
        'supplier': _selectedSupplier,
        'sku_code': _skuCodeController.text.trim(),
        'unit': _selectedUnit,
        'cost_price': costPrice,
        'selling_price': sellingPrice,
        'low_stock_threshold': lowStockThreshold,
        'current_stock': 0, // New products start with 0 stock
        'vat_percentage': vatPercentage ?? 0.0,
        'description': _descriptionController.text.trim(),
        'image_paths': _productImages.map((file) => file.path).toList(),
      };

      print('📦 Saving product: $productData');

      // Show loading
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text('Saving product to JSON storage...'),
      //     backgroundColor: Colors.blue,
      //     duration: const Duration(seconds: 2),
      //   ),
      // );

      // Save product to JSON storage
      final result = await ApiService.addProduct(productData);

      if (result['success'] == true) {
        print('✅ New Product Added to JSON: ${result['product_data']}');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Product saved successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate back
        Navigator.pop(context);
        
        // Test: Print all products
        final allProducts = await ApiService.getAllProducts();
        print('📦 Total Products in JSON: ${allProducts.length}');
        
      } else {
        // Show error message
        _showErrorMessage(result['message'] ?? 'Failed to save product');
      }
    } catch (e) {
      _showErrorMessage('Error saving product: $e');
    } finally {
      setState(() {
        _isSavingProduct = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _skuCodeController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _lowStockThresholdController.dispose();
    _vatPercentageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}