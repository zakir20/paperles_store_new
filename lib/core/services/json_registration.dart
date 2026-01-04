import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JsonRegistration {
  static JsonRegistration? _instance;
  factory JsonRegistration() => _instance ??= JsonRegistration._internal();
  JsonRegistration._internal();

  // Files for different data types
  final String _usersFile = 'paperless_store_users.json';
  final String _suppliersFile = 'paperless_store_suppliers.json';
  final String _brandsFile = 'paperless_store_brands.json';
  final String _categoriesFile = 'paperless_store_categories.json';
  final String _productsFile = 'paperless_store_products.json'; // Moved here to avoid duplicate

  // ========== FILE HELPER METHODS ==========
  Future<File> _getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  Future<List<Map<String, dynamic>>> _readJsonFile(String fileName) async {
    try {
      final File file = await _getFile(fileName);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      return List<Map<String, dynamic>>.from(json.decode(contents));
    } catch (e) {
      print('❌ Error reading $fileName: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> _writeJsonFile(
    String fileName, 
    List<Map<String, dynamic>> data
  ) async {
    try {
      final File file = await _getFile(fileName);
      await file.writeAsString(json.encode(data));
      return {'success': true, 'message': 'Data saved to $fileName'};
    } catch (e) {
      return {'success': false, 'message': 'Failed to save to $fileName: $e'};
    }
  }

  // ========== USER MANAGEMENT ==========
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    print('📝 JSON Registration: Starting...');
    
    try {
      final List<Map<String, dynamic>> users = await _readJsonFile(_usersFile);

      // Check if email/phone exists
      final emailExists = users.any((user) => user['email'] == userData['email']);
      final phoneExists = users.any((user) => user['phone'] == userData['phone']);
      
      if (emailExists) {
        return {'success': false, 'message': 'Email already registered'};
      }
      if (phoneExists) {
        return {'success': false, 'message': 'Phone already registered'};
      }

      // Create simple user record
      final userId = 'USER_${DateTime.now().millisecondsSinceEpoch}';
      final userRecord = {
        'user_id': userId,
        'full_name': userData['full_name'] ?? '',
        'shop_name': userData['shop_name'] ?? '',
        'proprietor_name': userData['proprietor_name'] ?? '',
        'phone': userData['phone'] ?? '',
        'email': userData['email'] ?? '',
        'shop_type': userData['shop_type'] ?? '',
        'store_address': userData['store_address'] ?? '',
        'location': userData['location'] ?? '',
        'trade_license': userData['trade_license'] ?? '',
        'password': _simpleHash(userData['password'] ?? ''),
        'registered_at': DateTime.now().toIso8601String(),
        'status': 'active',
      };

      // Save to file
      users.add(userRecord);
      final saveResult = await _writeJsonFile(_usersFile, users);
      if (!saveResult['success']) {
        return saveResult;
      }

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('registered_user', json.encode(userRecord));
      await prefs.setBool('is_registered', true);

      print('✅ JSON Registration: User saved successfully');
      
      return {
        'success': true,
        'message': 'Registration successful!',
        'user_id': userId,
        'user_data': userRecord,
      };
    } catch (e) {
      print('❌ JSON Registration Error: $e');
      return {'success': false, 'message': 'Registration failed: $e'};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final List<Map<String, dynamic>> users = await _readJsonFile(_usersFile);
      
      if (users.isEmpty) {
        return {'success': false, 'message': 'No users found. Please register first.'};
      }

      final hashedPassword = _simpleHash(password);
      
      // Find user
      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == hashedPassword,
        orElse: () => {},
      );

      if (user.isEmpty) {
        return {'success': false, 'message': 'Invalid email or password'};
      }

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(user));
      await prefs.setBool('is_logged_in', true);

      return {
        'success': true,
        'message': 'Login successful!',
        'user_data': user,
      };
    } catch (e) {
      return {'success': false, 'message': 'Login error: $e'};
    }
  }

  // ========== SUPPLIER MANAGEMENT ==========
  Future<Map<String, dynamic>> addSupplier(Map<String, dynamic> supplierData) async {
    print('📝 JSON Supplier: Adding supplier...');
    
    try {
      final List<Map<String, dynamic>> suppliers = await _readJsonFile(_suppliersFile);

      // Check if phone exists
      final phoneExists = suppliers.any((supplier) => supplier['phone'] == supplierData['phone']);
      
      if (phoneExists) {
        return {'success': false, 'message': 'Phone number already registered for another supplier'};
      }

      // Create supplier record
      final supplierId = 'SUP_${DateTime.now().millisecondsSinceEpoch}';
      final supplierRecord = {
        'supplier_id': supplierId,
        'name': supplierData['name'] ?? '',
        'address': supplierData['address'] ?? '',
        'contact_person': supplierData['contactPerson'] ?? '',
        'phone': supplierData['phone'] ?? '',
        'email': supplierData['email'] ?? '',
        'image_path': supplierData['imagePath'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'status': 'active',
      };

      // Save to file
      suppliers.add(supplierRecord);
      final saveResult = await _writeJsonFile(_suppliersFile, suppliers);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Supplier: Supplier saved successfully');
      
      return {
        'success': true,
        'message': 'Supplier added successfully!',
        'supplier_id': supplierId,
        'supplier_data': supplierRecord,
      };
    } catch (e) {
      print('❌ JSON Supplier Error: $e');
      return {'success': false, 'message': 'Failed to add supplier: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> getAllSuppliers() async {
    return await _readJsonFile(_suppliersFile);
  }

  // ========== BRAND MANAGEMENT ==========
  Future<Map<String, dynamic>> addBrand(Map<String, dynamic> brandData) async {
    print('📝 JSON Brand: Adding brand...');
    
    try {
      final List<Map<String, dynamic>> brands = await _readJsonFile(_brandsFile);

      // Check if brand name exists
      final brandExists = brands.any((brand) => 
        brand['name'].toString().toLowerCase() == brandData['name'].toString().toLowerCase()
      );
      
      if (brandExists) {
        return {'success': false, 'message': 'Brand name already exists'};
      }

      // Create brand record
      final brandId = 'BRAND_${DateTime.now().millisecondsSinceEpoch}';
      final brandRecord = {
        'brand_id': brandId,
        'name': brandData['name'] ?? '',
        'description': brandData['description'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'status': 'active',
      };

      // Save to file
      brands.add(brandRecord);
      final saveResult = await _writeJsonFile(_brandsFile, brands);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Brand: Brand saved successfully');
      
      return {
        'success': true,
        'message': 'Brand added successfully!',
        'brand_id': brandId,
        'brand_data': brandRecord,
      };
    } catch (e) {
      print('❌ JSON Brand Error: $e');
      return {'success': false, 'message': 'Failed to add brand: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> getAllBrands() async {
    return await _readJsonFile(_brandsFile);
  }

  // ========== CATEGORY MANAGEMENT ==========
  Future<Map<String, dynamic>> addCategory(Map<String, dynamic> categoryData) async {
    print('📝 JSON Category: Adding category...');
    
    try {
      final List<Map<String, dynamic>> categories = await _readJsonFile(_categoriesFile);

      // Check if category name exists
      final categoryExists = categories.any((category) => 
        category['name'].toString().toLowerCase() == categoryData['name'].toString().toLowerCase()
      );
      
      if (categoryExists) {
        return {'success': false, 'message': 'Category name already exists'};
      }

      // Create category record
      final categoryId = 'CAT_${DateTime.now().millisecondsSinceEpoch}';
      final categoryRecord = {
        'category_id': categoryId,
        'name': categoryData['name'] ?? '',
        'description': categoryData['description'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'status': 'active',
      };

      // Save to file
      categories.add(categoryRecord);
      final saveResult = await _writeJsonFile(_categoriesFile, categories);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Category: Category saved successfully');
      
      return {
        'success': true,
        'message': 'Category added successfully!',
        'category_id': categoryId,
        'category_data': categoryRecord,
      };
    } catch (e) {
      print('❌ JSON Category Error: $e');
      return {'success': false, 'message': 'Failed to add category: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return await _readJsonFile(_categoriesFile);
  }

  // ========== PRODUCT MANAGEMENT ==========
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> productData) async {
    print('📝 JSON Product: Adding product...');
    
    try {
      final List<Map<String, dynamic>> products = await _readJsonFile(_productsFile);

      // Check if SKU code exists
      final skuExists = products.any((product) => product['sku_code'] == productData['sku_code']);
      
      if (skuExists) {
        return {'success': false, 'message': 'SKU code already exists'};
      }

      // Create product record
      final productId = 'PROD_${DateTime.now().millisecondsSinceEpoch}';
      final productRecord = {
        'product_id': productId,
        'name': productData['name'] ?? '',
        'category': productData['category'] ?? '',
        'brand': productData['brand'] ?? '',
        'supplier': productData['supplier'] ?? '',
        'sku_code': productData['sku_code'] ?? '',
        'unit': productData['unit'] ?? '',
        'cost_price': productData['cost_price'] ?? 0.0,
        'selling_price': productData['selling_price'] ?? 0.0,
        'low_stock_threshold': productData['low_stock_threshold'] ?? 0,
        'current_stock': productData['current_stock'] ?? 0,
        'vat_percentage': productData['vat_percentage'] ?? 0.0,
        'description': productData['description'] ?? '',
        'image_paths': productData['image_paths'] ?? [],
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'status': 'active',
      };

      // Save to file
      products.add(productRecord);
      final saveResult = await _writeJsonFile(_productsFile, products);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Product: Product saved successfully');
      
      return {
        'success': true,
        'message': 'Product added successfully!',
        'product_id': productId,
        'product_data': productRecord,
      };
    } catch (e) {
      print('❌ JSON Product Error: $e');
      return {'success': false, 'message': 'Failed to add product: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    return await _readJsonFile(_productsFile);
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    final allProducts = await getAllProducts();
    return allProducts.where((product) => product['category'] == category).toList();
  }

  Future<List<Map<String, dynamic>>> getProductsByBrand(String brand) async {
    final allProducts = await getAllProducts();
    return allProducts.where((product) => product['brand'] == brand).toList();
  }

  Future<List<Map<String, dynamic>>> getProductsBySupplier(String supplier) async {
    final allProducts = await getAllProducts();
    return allProducts.where((product) => product['supplier'] == supplier).toList();
  }

  Future<Map<String, dynamic>?> getProductById(String productId) async {
    final allProducts = await getAllProducts();
    return allProducts.firstWhere(
      (product) => product['product_id'] == productId,
      orElse: () => {},
    );
  }

  Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      final List<Map<String, dynamic>> products = await _readJsonFile(_productsFile);
      
      final index = products.indexWhere((product) => product['product_id'] == productId);
      
      if (index == -1) {
        return {'success': false, 'message': 'Product not found'};
      }

      // Update product
      products[index] = {
        ...products[index],
        ...updates,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final saveResult = await _writeJsonFile(_productsFile, products);
      if (!saveResult['success']) {
        return saveResult;
      }

      return {
        'success': true,
        'message': 'Product updated successfully',
        'product_data': products[index],
      };
    } catch (e) {
      return {'success': false, 'message': 'Failed to update product: $e'};
    }
  }

  // ========== HELPER METHODS ==========
  String _simpleHash(String input) {
    return 'hash_${input.hashCode.abs()}';
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('current_user');
    return userString != null ? Map<String, dynamic>.from(json.decode(userString)) : null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.remove('is_logged_in');
  }

  // ========== TEST METHODS ==========
  Future<void> testJsonStorage() async {
    try {
      final files = [_usersFile, _suppliersFile, _brandsFile, _categoriesFile, _productsFile];
      
      for (final fileName in files) {
        final file = await _getFile(fileName);
        final exists = await file.exists();
        print('📁 $fileName exists: $exists');
        print('📁 $fileName path: ${file.path}');
        
        if (exists) {
          final contents = await file.readAsString();
          print('📁 $fileName size: ${contents.length} characters');
          if (contents.isNotEmpty) {
            final data = json.decode(contents);
            print('📁 Total records in $fileName: ${data.length}');
          }
        }
        print('---');
      }
    } catch (e) {
      print('❌ JSON Test Error: $e');
    }
  }

  Future<void> testSuppliersStorage() async {
    try {
      final file = await _getFile(_suppliersFile);
      final exists = await file.exists();
      print('📁 Suppliers File exists: $exists');
      print('📁 Suppliers File path: ${file.path}');
      
      if (exists) {
        final contents = await file.readAsString();
        print('📁 Suppliers File size: ${contents.length} characters');
        if (contents.isNotEmpty) {
          final suppliers = json.decode(contents);
          print('📁 Total suppliers in file: ${suppliers.length}');
        }
      }
    } catch (e) {
      print('❌ Suppliers Test Error: $e');
    }
  }

  Future<void> testAllData() async {
    print('📊 === TESTING ALL JSON DATA ===');
    
    final users = await getAllSuppliers();
    print('👥 Total Users: ${(await _readJsonFile(_usersFile)).length}');
    print('🏭 Total Suppliers: ${users.length}');
    print('🏷️ Total Brands: ${(await getAllBrands()).length}');
    print('📂 Total Categories: ${(await getAllCategories()).length}');
    print('📦 Total Products: ${(await getAllProducts()).length}');
    
    print('📊 Suppliers List:');
    for (final supplier in users) {
      print('  - ${supplier['name']} (${supplier['phone']})');
    }
    
    print('📊 === TEST COMPLETE ===');
  }
  // ========== DELETE PRODUCT ==========
  Future<Map<String, dynamic>> deleteProduct(String productId) async {
    print('🗑️ JSON Product: Deleting product $productId');
    
    try {
      final List<Map<String, dynamic>> products = await _readJsonFile(_productsFile);
      
      final index = products.indexWhere((product) => product['product_id'] == productId);
      
      if (index == -1) {
        return {'success': false, 'message': 'Product not found'};
      }

      // Remove product
      final deletedProduct = products.removeAt(index);

      final saveResult = await _writeJsonFile(_productsFile, products);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Product: Product deleted successfully');
      
      return {
        'success': true,
        'message': 'Product deleted successfully',
        'deleted_product': deletedProduct,
      };
    } catch (e) {
      print('❌ JSON Product Delete Error: $e');
      return {'success': false, 'message': 'Failed to delete product: $e'};
    }
  }

  // ========== DELETE SUPPLIER ==========
  Future<Map<String, dynamic>> deleteSupplier(String supplierId) async {
    print('🗑️ JSON Supplier: Deleting supplier $supplierId');
    
    try {
      final List<Map<String, dynamic>> suppliers = await _readJsonFile(_suppliersFile);
      
      final index = suppliers.indexWhere((supplier) => supplier['supplier_id'] == supplierId);
      
      if (index == -1) {
        return {'success': false, 'message': 'Supplier not found'};
      }

      // Check if supplier is used in any products
      final products = await getAllProducts();
      final supplierInUse = products.any((product) => product['supplier_id'] == supplierId);
      
      if (supplierInUse) {
        return {'success': false, 'message': 'Cannot delete supplier. Products are associated with this supplier.'};
      }

      // Remove supplier
      final deletedSupplier = suppliers.removeAt(index);

      final saveResult = await _writeJsonFile(_suppliersFile, suppliers);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Supplier: Supplier deleted successfully');
      
      return {
        'success': true,
        'message': 'Supplier deleted successfully',
        'deleted_supplier': deletedSupplier,
      };
    } catch (e) {
      print('❌ JSON Supplier Delete Error: $e');
      return {'success': false, 'message': 'Failed to delete supplier: $e'};
    }
  }

  // ========== DELETE BRAND ==========
  Future<Map<String, dynamic>> deleteBrand(String brandId) async {
    print('🗑️ JSON Brand: Deleting brand $brandId');
    
    try {
      final List<Map<String, dynamic>> brands = await _readJsonFile(_brandsFile);
      
      final index = brands.indexWhere((brand) => brand['brand_id'] == brandId);
      
      if (index == -1) {
        return {'success': false, 'message': 'Brand not found'};
      }

      // Check if brand is used in any products
      final products = await getAllProducts();
      final brandInUse = products.any((product) => product['brand_id'] == brandId);
      
      if (brandInUse) {
        return {'success': false, 'message': 'Cannot delete brand. Products are associated with this brand.'};
      }

      // Remove brand
      final deletedBrand = brands.removeAt(index);

      final saveResult = await _writeJsonFile(_brandsFile, brands);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Brand: Brand deleted successfully');
      
      return {
        'success': true,
        'message': 'Brand deleted successfully',
        'deleted_brand': deletedBrand,
      };
    } catch (e) {
      print('❌ JSON Brand Delete Error: $e');
      return {'success': false, 'message': 'Failed to delete brand: $e'};
    }
  }

  // ========== DELETE CATEGORY ==========
  Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    print('🗑️ JSON Category: Deleting category $categoryId');
    
    try {
      final List<Map<String, dynamic>> categories = await _readJsonFile(_categoriesFile);
      
      final index = categories.indexWhere((category) => category['category_id'] == categoryId);
      
      if (index == -1) {
        return {'success': false, 'message': 'Category not found'};
      }

      // Check if category is used in any products
      final products = await getAllProducts();
      final categoryInUse = products.any((product) => product['category_id'] == categoryId);
      
      if (categoryInUse) {
        return {'success': false, 'message': 'Cannot delete category. Products are associated with this category.'};
      }

      // Remove category
      final deletedCategory = categories.removeAt(index);

      final saveResult = await _writeJsonFile(_categoriesFile, categories);
      if (!saveResult['success']) {
        return saveResult;
      }

      print('✅ JSON Category: Category deleted successfully');
      
      return {
        'success': true,
        'message': 'Category deleted successfully',
        'deleted_category': deletedCategory,
      };
    } catch (e) {
      print('❌ JSON Category Delete Error: $e');
      return {'success': false, 'message': 'Failed to delete category: $e'};
    }
  }
  // ========== CUSTOMER MANAGEMENT ==========
Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> customerData) async {
  print('📝 JSON Customer: Adding customer...');
  
  try {
    final List<Map<String, dynamic>> customers = await _readJsonFile('paperless_store_customers.json');

    // Check if phone exists
    final phoneExists = customers.any((customer) => customer['phone'] == customerData['phone']);
    
    if (phoneExists) {
      return {'success': false, 'message': 'Phone number already registered for another customer'};
    }

    // Create customer record
    final customerId = 'CUST_${DateTime.now().millisecondsSinceEpoch}';
    final customerRecord = {
      'customer_id': customerId,
      'name': customerData['name'] ?? '',
      'address': customerData['address'] ?? '',
      'phone': customerData['phone'] ?? '',
      'profile_image': customerData['profile_image'] ?? '',
      'amount_type': customerData['amount_type'] ?? 'due', // 'due' or 'credit'
      'amount': customerData['amount'] ?? 0.0,
      'created_at': DateTime.now().toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
      'status': 'active',
    };

    // Save to file
    customers.add(customerRecord);
    final saveResult = await _writeJsonFile('paperless_store_customers.json', customers);
    if (!saveResult['success']) {
      return saveResult;
    }

    print('✅ JSON Customer: Customer saved successfully');
    
    return {
      'success': true,
      'message': 'Customer added successfully!',
      'customer_id': customerId,
      'customer_data': customerRecord,
    };
  } catch (e) {
    print('❌ JSON Customer Error: $e');
    return {'success': false, 'message': 'Failed to add customer: $e'};
  }
}

Future<List<Map<String, dynamic>>> getAllCustomers() async {
  return await _readJsonFile('paperless_store_customers.json');
}

Future<List<Map<String, dynamic>>> getCustomersWithDue() async {
  final allCustomers = await getAllCustomers();
  return allCustomers.where((customer) => 
    customer['amount_type'] == 'due' && (customer['amount'] as num) > 0
  ).toList();
}

Future<List<Map<String, dynamic>>> getCustomersWithCredit() async {
  final allCustomers = await getAllCustomers();
  return allCustomers.where((customer) => 
    customer['amount_type'] == 'credit' && (customer['amount'] as num) > 0
  ).toList();
}

Future<Map<String, dynamic>> updateCustomerAmount(String customerId, double newAmount, String amountType) async {
  try {
    final List<Map<String, dynamic>> customers = await _readJsonFile('paperless_store_customers.json');
    
    final index = customers.indexWhere((customer) => customer['customer_id'] == customerId);
    
    if (index == -1) {
      return {'success': false, 'message': 'Customer not found'};
    }

    // Update customer
    customers[index] = {
      ...customers[index],
      'amount': newAmount,
      'amount_type': amountType,
      'last_updated': DateTime.now().toIso8601String(),
    };

    final saveResult = await _writeJsonFile('paperless_store_customers.json', customers);
    if (!saveResult['success']) {
      return saveResult;
    }

    return {
      'success': true,
      'message': 'Customer amount updated successfully',
      'customer_data': customers[index],
    };
  } catch (e) {
    return {'success': false, 'message': 'Failed to update customer: $e'};
  }
}

Future<Map<String, dynamic>> deleteCustomer(String customerId) async {
  try {
    final List<Map<String, dynamic>> customers = await _readJsonFile('paperless_store_customers.json');
    
    final index = customers.indexWhere((customer) => customer['customer_id'] == customerId);
    
    if (index == -1) {
      return {'success': false, 'message': 'Customer not found'};
    }

    // Remove customer
    final deletedCustomer = customers.removeAt(index);

    final saveResult = await _writeJsonFile('paperless_store_customers.json', customers);
    if (!saveResult['success']) {
      return saveResult;
    }

    return {
      'success': true,
      'message': 'Customer deleted successfully',
      'deleted_customer': deletedCustomer,
    };
  } catch (e) {
    return {'success': false, 'message': 'Failed to delete customer: $e'};
  }
}
}