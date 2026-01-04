import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/api_service.dart'; 
import 'add_product_screen.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  String _selectedView = 'list'; // 'list' or 'grid'
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  bool _isLoadingProducts = false;
  
  // ========== SUPPLIER FORM CONTROLLERS ==========
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _supplierAddressController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _supplierImage;
  
  // ========== BRAND FORM CONTROLLERS ==========
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _brandDescriptionController = TextEditingController();
  File? _brandImage;

  // ========== CATEGORY FORM CONTROLLERS ==========
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDescriptionController = TextEditingController();
  File? _categoryImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      final products = await ApiService.getAllProducts();
      setState(() {
        _products = products;
      });
      print('📦 Loaded ${_products.length} products from JSON storage');
    } catch (e) {
      print('❌ Error loading products: $e');
      _showErrorMessage('Failed to load products: $e');
    } finally {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh products when screen is focused
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
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
          'Manage Products',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  // Search functionality - filter products
                  _filterProducts(value);
                },
              ),
            ),
          ),

          // Add Supplier, Brand, Category Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildAddButton(
                    label: 'Add Supplier',
                    icon: Icons.person_add,
                    color: const Color(0xFF10B981), // Green
                    onPressed: _showAddSupplierDialog,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAddButton(
                    label: 'Add Brand',
                    icon: Icons.branding_watermark,
                    color: const Color(0xFF3B82F6), // Blue
                    onPressed: _showAddBrandDialog,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAddButton(
                    label: 'Add Category',
                    icon: Icons.category,
                    color: const Color(0xFF8B5CF6), // Purple
                    onPressed: _showAddCategoryDialog,
                  ),
                ),
              ],
            ),
          ),

          // View Toggle (List/Grid) and Product Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Count
                Text(
                  'Total Products: ${_products.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                // View Toggle Buttons
                Row(
                  children: [
                    // List View Button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedView = 'list';
                        });
                      },
                      icon: Icon(
                        Icons.list,
                        color: _selectedView == 'list' 
                            ? const Color(0xFF4F46E5) 
                            : const Color(0xFF9CA3AF),
                        size: 24,
                      ),
                    ),
                    // Grid View Button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedView = 'grid';
                        });
                      },
                      icon: Icon(
                        Icons.grid_view,
                        color: _selectedView == 'grid' 
                            ? const Color(0xFF4F46E5) 
                            : const Color(0xFF9CA3AF),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Loading Indicator or Product List
          Expanded(
            child: _isLoadingProducts
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading products...'),
                      ],
                    ),
                  )
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory,
                              size: 60,
                              color: const Color(0xFF9CA3AF),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add your first product',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddProductScreen(),
                                  ),
                                ).then((_) {
                                  // Refresh products after returning from AddProductScreen
                                  _loadProducts();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4F46E5),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Add Product'),
                            ),
                          ],
                        ),
                      )
                    : _selectedView == 'list'
                        ? _buildListView()
                        : _buildGridView(),
          ),

          // Add Product Button at Bottom (150px wide, right side)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to right
              children: [
                Container(
                  width: 150, // 150px width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductScreen(),
                        ),
                      ).then((_) {
                        // Refresh products after returning from AddProductScreen
                        _loadProducts();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5), // Purple
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  void _filterProducts(String query) {
    // If we want to implement real-time filtering, we can create a filtered list
    // For now, we'll just show all products when search is empty
    // You can implement filtering logic here if needed
  }

  // ... [KEEP ALL EXISTING METHODS FOR SUPPLIER/BRAND/CATEGORY DIALOGS] ...
  // ========== ADD SUPPLIER DIALOG ==========
  void _showAddSupplierDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Supplier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                      _clearSupplierForm();
                    },
                  ),
                ],
              ),
              const Divider(color: Color(0xFFE5E7EB)),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Supplier Name and Photo Section
                  const Text(
                    'Supplier Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'upload or take a photo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Supplier Photo Upload
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(imageType: 'supplier'),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _supplierImage != null ? Colors.green : const Color(0xFFD1D5DB),
                          width: _supplierImage != null ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _supplierImage != null ? Colors.green[50] : const Color(0xFFF9FAFB),
                      ),
                      child: _supplierImage != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _supplierImage!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _supplierImage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: const Color(0xFF6B7280),
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Supplier Name Field
                  _buildFormTextField(
                    controller: _supplierNameController,
                    label: 'Supplier Name',
                    icon: Icons.business,
                    hintText: 'Enter supplier name',
                  ),
                  
                  const SizedBox(height: 16),

                  // Address Field
                  _buildFormTextField(
                    controller: _supplierAddressController,
                    label: 'Address',
                    icon: Icons.location_on,
                    hintText: 'Enter supplier address',
                    maxLines: 2,
                  ),
                  
                  const SizedBox(height: 16),

                  // Contact Person Field
                  _buildFormTextField(
                    controller: _contactPersonController,
                    label: 'Contact Person',
                    icon: Icons.person,
                    hintText: 'Enter contact person name',
                  ),
                  
                  const SizedBox(height: 16),

                  // Phone Number Field
                  _buildFormTextField(
                    controller: _phoneNumberController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    hintText: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                  ),
                  
                  const SizedBox(height: 16),

                  // Email Field
                  _buildFormTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    hintText: 'Enter email address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _clearSupplierForm();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addSupplier,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ========== ADD BRAND DIALOG ==========
  void _showAddBrandDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Brand',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                      _clearBrandForm();
                    },
                  ),
                ],
              ),
              const Divider(color: Color(0xFFE5E7EB)),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand Name and Photo Section
                  const Text(
                    'Brand Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'upload or take a photo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Brand Logo Upload
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(imageType: 'brand'),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _brandImage != null ? Colors.blue : const Color(0xFFD1D5DB),
                          width: _brandImage != null ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _brandImage != null ? Colors.blue[50] : const Color(0xFFF9FAFB),
                      ),
                      child: _brandImage != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _brandImage!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _brandImage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: const Color(0xFF6B7280),
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add Logo',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Brand Name Field
                  _buildFormTextField(
                    controller: _brandNameController,
                    label: 'Brand Name',
                    icon: Icons.branding_watermark,
                    hintText: 'Enter brand name',
                  ),
                  
                  const SizedBox(height: 16),

                  // Description Field
                  _buildFormTextField(
                    controller: _brandDescriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    hintText: 'Enter brand description (optional)',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _clearBrandForm();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addBrand,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6), // Blue color for brand
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ========== ADD CATEGORY DIALOG ==========
  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                      _clearCategoryForm();
                    },
                  ),
                ],
              ),
              const Divider(color: Color(0xFFE5E7EB)),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Name and Photo Section
                  const Text(
                    'Category Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'upload or take a photo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Category Image Upload
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(imageType: 'category'),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _categoryImage != null ? Colors.purple : const Color(0xFFD1D5DB),
                          width: _categoryImage != null ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _categoryImage != null ? Colors.purple[50] : const Color(0xFFF9FAFB),
                      ),
                      child: _categoryImage != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _categoryImage!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _categoryImage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: const Color(0xFF6B7280),
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add Image',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Category Name Field
                  _buildFormTextField(
                    controller: _categoryNameController,
                    label: 'Category Name',
                    icon: Icons.category,
                    hintText: 'Enter category name',
                  ),
                  
                  const SizedBox(height: 16),

                  // Description Field
                  _buildFormTextField(
                    controller: _categoryDescriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    hintText: 'Enter category description (optional)',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _clearCategoryForm();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6), // Purple color for category
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
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
                  maxLines: maxLines,
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

  void _showImageSourceDialog({required String imageType}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF10B981)),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera(imageType: imageType);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF10B981)),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery(imageType: imageType);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera({required String imageType}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          if (imageType == 'supplier') {
            _supplierImage = File(image.path);
          } else if (imageType == 'brand') {
            _brandImage = File(image.path);
          } else if (imageType == 'category') {
            _categoryImage = File(image.path);
          }
        });
      }
    } catch (e) {
      _showErrorMessage('Camera error: $e');
    }
  }

  Future<void> _pickImageFromGallery({required String imageType}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          if (imageType == 'supplier') {
            _supplierImage = File(image.path);
          } else if (imageType == 'brand') {
            _brandImage = File(image.path);
          } else if (imageType == 'category') {
            _categoryImage = File(image.path);
          }
        });
      }
    } catch (e) {
      _showErrorMessage('Gallery error: $e');
    }
  }

  // ========== ADD SUPPLIER FUNCTION ==========
  void _addSupplier() async {
    // Validate required fields
    if (_supplierNameController.text.isEmpty) {
      _showErrorMessage('Please enter supplier name');
      return;
    }

    if (_phoneNumberController.text.isEmpty) {
      _showErrorMessage('Please enter phone number');
      return;
    }

    // Create supplier object
    final supplier = {
      'name': _supplierNameController.text.trim(),
      'address': _supplierAddressController.text.trim(),
      'contactPerson': _contactPersonController.text.trim(),
      'phone': _phoneNumberController.text.trim(),
      'email': _emailController.text.trim(),
      'imagePath': _supplierImage?.path ?? '',
    };

    try {
      // Show loading
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text('Saving supplier to JSON storage...'),
      //     backgroundColor: Colors.blue,
      //     duration: const Duration(seconds: 2),
      //   ),
      // );

      // Save supplier to JSON storage
      final result = await ApiService.addSupplier(supplier);

      if (result['success'] == true) {
        print('✅ New Supplier Added to JSON: ${result['supplier_data']}');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Supplier added successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Close dialog and clear form
        Navigator.pop(context);
        _clearSupplierForm();
        
        // Test: Print all suppliers
        final allSuppliers = await ApiService.getAllSuppliers();
        print('📋 Total Suppliers in JSON: ${allSuppliers.length}');
        
      } else {
        // Show error message
        _showErrorMessage(result['message'] ?? 'Failed to add supplier');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    }
  }

  // ========== ADD BRAND FUNCTION ==========
  void _addBrand() async {
    // Validate required fields
    if (_brandNameController.text.isEmpty) {
      _showErrorMessage('Please enter brand name');
      return;
    }

    // Create brand object
    final brand = {
      'name': _brandNameController.text.trim(),
      'description': _brandDescriptionController.text.trim(),
      'imagePath': _brandImage?.path ?? '',
    };

    try {
      // Show loading
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text('Saving brand to JSON storage...'),
      //     backgroundColor: Colors.blue,
      //     duration: const Duration(seconds: 2),
      //   ),
      // );

      // Save brand to JSON storage
      final result = await ApiService.addBrand(brand);

      if (result['success'] == true) {
        print('✅ New Brand Added to JSON: ${result['brand_data']}');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Brand added successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Close dialog and clear form
        Navigator.pop(context);
        _clearBrandForm();
        
        // Test: Print all brands
        final allBrands = await ApiService.getAllBrands();
        print('📋 Total Brands in JSON: ${allBrands.length}');
        
      } else {
        // Show error message
        _showErrorMessage(result['message'] ?? 'Failed to add brand');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    }
  }

  // ========== ADD CATEGORY FUNCTION ==========
  void _addCategory() async {
    // Validate required fields
    if (_categoryNameController.text.isEmpty) {
      _showErrorMessage('Please enter category name');
      return;
    }

    // Create category object
    final category = {
      'name': _categoryNameController.text.trim(),
      'description': _categoryDescriptionController.text.trim(),
      'imagePath': _categoryImage?.path ?? '',
    };

    try {
      // Show loading
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text('Saving category to JSON storage...'),
      //     backgroundColor: Colors.blue,
      //     duration: const Duration(seconds: 2),
      //   ),
      // );

      // Save category to JSON storage
      final result = await ApiService.addCategory(category);

      if (result['success'] == true) {
        print('✅ New Category Added to JSON: ${result['category_data']}');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Category added successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Close dialog and clear form
        Navigator.pop(context);
        _clearCategoryForm();
        
        // Test: Print all categories
        final allCategories = await ApiService.getAllCategories();
        print('📋 Total Categories in JSON: ${allCategories.length}');
        
      } else {
        // Show error message
        _showErrorMessage(result['message'] ?? 'Failed to add category');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    }
  }

  void _clearSupplierForm() {
    _supplierNameController.clear();
    _supplierAddressController.clear();
    _contactPersonController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
    setState(() {
      _supplierImage = null;
    });
  }

  void _clearBrandForm() {
    _brandNameController.clear();
    _brandDescriptionController.clear();
    setState(() {
      _brandImage = null;
    });
  }

  void _clearCategoryForm() {
    _categoryNameController.clear();
    _categoryDescriptionController.clear();
    setState(() {
      _categoryImage = null;
    });
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

  Widget _buildAddButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product, index, isList: true);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _buildProductCard(product, index, isList: false);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index, {bool isList = true}) {
    // Format product data for display
    final productName = product['name'] ?? 'Unnamed Product';
    final brand = product['brand'] ?? 'No Brand';
    final supplier = product['supplier'] ?? 'No Supplier';
    final category = product['category'] ?? 'No Category';
    final costPrice = double.tryParse(product['cost_price']?.toString() ?? '0') ?? 0.0;
    final sellingPrice = double.tryParse(product['selling_price']?.toString() ?? '0') ?? 0.0;
    final currentStock = int.tryParse(product['current_stock']?.toString() ?? '0') ?? 0;
    final lowStockThreshold = int.tryParse(product['low_stock_threshold']?.toString() ?? '0') ?? 10;
    final skuCode = product['sku_code'] ?? 'N/A';
    final productId = product['product_id'];

    if (isList) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: product['image_paths'] != null && 
                   (product['image_paths'] as List).isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File((product['image_paths'] as List).first),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.inventory, color: Color(0xFF9CA3AF));
                      },
                    ),
                  )
                : const Icon(Icons.inventory, color: Color(0xFF9CA3AF)),
          ),
          title: Text(
            productName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Brand: $brand',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                'Supplier: $supplier',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                'Category: $category',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TK ${sellingPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: currentStock <= lowStockThreshold 
                          ? const Color(0xFFFEF2F2) 
                          : const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Stock: $currentStock',
                      style: TextStyle(
                        fontSize: 12,
                        color: currentStock <= lowStockThreshold 
                            ? const Color(0xFFDC2626) 
                            : const Color(0xFF0369A1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF9CA3AF)),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye, size: 16, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Text('View Details'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 16, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'view') {
                _viewProductDetails(product);
              } else if (value == 'edit') {
                _editProduct(product, index);
              } else if (value == 'delete') {
                _deleteProduct(product, index);
              }
            },
          ),
        ),
      );
    } else {
      // Grid View Card
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: product['image_paths'] != null && 
                     (product['image_paths'] as List).isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.file(
                        File((product['image_paths'] as List).first),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.inventory, size: 40, color: Color(0xFF9CA3AF)),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.inventory, size: 40, color: Color(0xFF9CA3AF)),
                    ),
            ),
            
            // Product Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TK ${sellingPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: $currentStock',
                    style: TextStyle(
                      fontSize: 12,
                      color: currentStock <= lowStockThreshold 
                          ? const Color(0xFFDC2626) 
                          : const Color(0xFF0369A1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: $skuCode',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  void _viewProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (product['image_paths'] != null && 
                  (product['image_paths'] as List).isNotEmpty)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File((product['image_paths'] as List).first)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              _buildDetailRow('Name', product['name'] ?? 'N/A'),
              _buildDetailRow('SKU Code', product['sku_code'] ?? 'N/A'),
              _buildDetailRow('Category', product['category'] ?? 'N/A'),
              _buildDetailRow('Brand', product['brand'] ?? 'N/A'),
              _buildDetailRow('Supplier', product['supplier'] ?? 'N/A'),
              _buildDetailRow('Unit', product['unit'] ?? 'N/A'),
              _buildDetailRow('Cost Price', 'TK ${(double.tryParse(product['cost_price']?.toString() ?? '0') ?? 0.0).toStringAsFixed(2)}'),
              _buildDetailRow('Selling Price', 'TK ${(double.tryParse(product['selling_price']?.toString() ?? '0') ?? 0.0).toStringAsFixed(2)}'),
              _buildDetailRow('Current Stock', product['current_stock']?.toString() ?? '0'),
              _buildDetailRow('Low Stock Threshold', product['low_stock_threshold']?.toString() ?? '10'),
              _buildDetailRow('VAT %', product['vat_percentage']?.toString() ?? '0.0'),
              
              if (product['description'] != null && product['description'].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(product['description']),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(Map<String, dynamic> product, int index) {
    // Show edit dialog with current product values
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Initialize controllers with current product data
        final productNameController = TextEditingController(text: product['name']);
        final skuCodeController = TextEditingController(text: product['sku_code']);
        final costPriceController = TextEditingController(text: product['cost_price']?.toString() ?? '0');
        final sellingPriceController = TextEditingController(text: product['selling_price']?.toString() ?? '0');
        final currentStockController = TextEditingController(text: product['current_stock']?.toString() ?? '0');
        final lowStockThresholdController = TextEditingController(text: product['low_stock_threshold']?.toString() ?? '10');
        final vatPercentageController = TextEditingController(text: product['vat_percentage']?.toString() ?? '0');
        final descriptionController = TextEditingController(text: product['description'] ?? '');

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Product',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFE5E7EB)),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Name
                      _buildEditFormTextField(
                        controller: productNameController,
                        label: 'Product Name',
                        icon: Icons.shopping_bag,
                        hintText: 'Enter product name',
                      ),
                      
                      const SizedBox(height: 16),

                      // SKU Code
                      _buildEditFormTextField(
                        controller: skuCodeController,
                        label: 'SKU Code',
                        icon: Icons.code,
                        hintText: 'Enter SKU code',
                      ),
                      
                      const SizedBox(height: 16),

                      // Cost Price
                      _buildEditFormTextField(
                        controller: costPriceController,
                        label: 'Cost Price',
                        icon: Icons.attach_money,
                        hintText: 'Enter cost price',
                        keyboardType: TextInputType.number,
                      ),
                      
                      const SizedBox(height: 16),

                      // Selling Price
                      _buildEditFormTextField(
                        controller: sellingPriceController,
                        label: 'Selling Price',
                        icon: Icons.money,
                        hintText: 'Enter selling price',
                        keyboardType: TextInputType.number,
                      ),
                      
                      const SizedBox(height: 16),

                      // Current Stock
                      _buildEditFormTextField(
                        controller: currentStockController,
                        label: 'Current Stock',
                        icon: Icons.inventory,
                        hintText: 'Enter current stock',
                        keyboardType: TextInputType.number,
                      ),
                      
                      const SizedBox(height: 16),

                      // Low Stock Threshold
                      _buildEditFormTextField(
                        controller: lowStockThresholdController,
                        label: 'Low Stock Threshold',
                        icon: Icons.warning,
                        hintText: 'Enter low stock threshold',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validate fields
                          if (productNameController.text.isEmpty) {
                            _showErrorMessage('Please enter product name');
                            return;
                          }

                          if (costPriceController.text.isEmpty) {
                            _showErrorMessage('Please enter cost price');
                            return;
                          }

                          if (sellingPriceController.text.isEmpty) {
                            _showErrorMessage('Please enter selling price');
                            return;
                          }

                          final updates = {
                            'name': productNameController.text.trim(),
                            'sku_code': skuCodeController.text.trim(),
                            'cost_price': double.tryParse(costPriceController.text) ?? 0.0,
                            'selling_price': double.tryParse(sellingPriceController.text) ?? 0.0,
                            'current_stock': int.tryParse(currentStockController.text) ?? 0,
                            'low_stock_threshold': int.tryParse(lowStockThresholdController.text) ?? 10,
                            'vat_percentage': double.tryParse(vatPercentageController.text) ?? 0.0,
                            'description': descriptionController.text.trim(),
                          };

                          await _updateProduct(product['product_id'], updates, index);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEditFormTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
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

  Future<void> _updateProduct(String productId, Map<String, dynamic> updates, int index) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updating product...'),
          backgroundColor: Colors.blue,
        ),
      );

      // Call API Service to update product
      final result = await ApiService.updateProduct(productId, updates);

      if (result['success'] == true) {
        // Update local list
        setState(() {
          _products[index] = result['product_data'];
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        print('✅ Product updated: ${result['product_data']}');
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      _showErrorMessage('Error updating product: $e');
    }
  }

  void _deleteProduct(Map<String, dynamic> product, int index) {
    final productName = product['name'] ?? 'this product';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performDelete(product, index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete(Map<String, dynamic> product, int index) async {
    final productId = product['product_id'];
    final productName = product['name'] ?? 'Product';
    
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deleting product...'),
          backgroundColor: Colors.orange,
        ),
      );

      // Call API Service to delete product
      final result = await ApiService.deleteProduct(productId);

      if (result['success'] == true) {
        // Remove from local list
        setState(() {
          _products.removeAt(index);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$productName" deleted successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        print('✅ Product deleted: ${result['deleted_product']}');
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      _showErrorMessage('Error deleting product: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Sales',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
      currentIndex: 1, // Inventory is selected
      selectedItemColor: const Color(0xFF4F46E5),
      unselectedItemColor: const Color(0xFF9CA3AF),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      onTap: (index) {
        // Handle navigation
        if (index == 0) {
          Navigator.pop(context); // Go back to dashboard
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _supplierNameController.dispose();
    _supplierAddressController.dispose();
    _contactPersonController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _brandNameController.dispose();
    _brandDescriptionController.dispose();
    _categoryNameController.dispose();
    _categoryDescriptionController.dispose();
    super.dispose();
  }
}