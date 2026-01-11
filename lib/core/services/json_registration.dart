import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 

class JsonRegistration {
  static JsonRegistration? _instance;
  factory JsonRegistration() => _instance ??= JsonRegistration._internal();
  JsonRegistration._internal();

  // ========== API CONFIGURATION ==========
  static const String _apiBaseUrl = 'http://192.168.68.113/paperless_store_new/api';

  // ========== GETX FOR USER MANAGEMENT ONLY ==========
  final Rx<Map<String, dynamic>?> currentUser = Rx<Map<String, dynamic>?>(null);
  final RxBool isOnlineMode = false.obs; // Track online/offline mode

  // Files for different data types
  final String _usersFile = 'paperless_store_users.json';
  final String _suppliersFile = 'paperless_store_suppliers.json';
  final String _brandsFile = 'paperless_store_brands.json';
  final String _categoriesFile = 'paperless_store_categories.json';
  final String _productsFile = 'paperless_store_products.json';
  final String _customersFile = 'paperless_store_customers.json';

  // ========== MODE MANAGEMENT ==========
  Future<void> initMode() async {
    final prefs = await SharedPreferences.getInstance();
    isOnlineMode.value = prefs.getBool('online_mode') ?? false;
    print(' Initialized mode: ${isOnlineMode.value ? 'ONLINE' : 'OFFLINE'}');
  }

  Future<void> toggleOnlineMode(bool value) async {
    isOnlineMode.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('online_mode', value);
    
    Get.snackbar(
      'Mode Changed',
      value ? 'Online Mode: Using MySQL Database' : 'Offline Mode: Using Local Storage',
      duration: Duration(seconds: 2),
    );
    print(' Mode changed to: ${value ? 'ONLINE' : 'OFFLINE'}');
  }

  // ========== API HELPER METHODS ==========
  Future<Map<String, dynamic>> _callApi(
    String endpoint, 
    Map<String, dynamic> data,
    String method
  ) async {
    try {
      final url = Uri.parse('$_apiBaseUrl/$endpoint');
      
      print('API Request: $method $url');

      http.Response response;
      
      if (method == 'POST') {
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(data),
        ).timeout(Duration(seconds: 10));
      } else {
        response = await http.get(url).timeout(Duration(seconds: 10));
      }

      print('📡 Response Status: ${response.statusCode}');

      final responseData = json.decode(response.body);
      
      // Check if PHP returned success
      final bool isSuccess = responseData['success'] == true;
      
      return {
        'success': isSuccess,
        'statusCode': response.statusCode,
        'data': responseData,
        'message': responseData['message'] ?? (isSuccess ? 'Success' : 'Failed'),
      };
      
    } catch (e) {
      print('❌ API Error: $e');
      return {
        'success': false,
        'message': 'Connection failed: $e',
        'error': e.toString(),
      };
    }
  }

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

  // ========== DUAL MODE USER REGISTRATION ==========
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    print(' Registration: Starting...');
    
    try {
      // Validate required fields
      final requiredFields = ['full_name', 'phone', 'email', 'shop_type', 'store_address', 'location', 'trade_license', 'password'];
      
      for (final field in requiredFields) {
        if (userData[field] == null || userData[field]!.toString().isEmpty) {
          return {
            'success': false,
            'message': 'Field "$field" is required'
          };
        }
      }

      // Create user record - USE HASHED PASSWORD FOR PHP
      final userId = 'USER_${DateTime.now().millisecondsSinceEpoch}';
      final hashedPassword = _simpleHash(userData['password'] ?? '');
      
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
        'password': hashedPassword, // Send HASHED password to PHP
        'registered_at': DateTime.now().toIso8601String(),
        'status': 'active',
      };

      print(' Current Mode: ${isOnlineMode.value ? "ONLINE" : "OFFLINE"}');
      
      // ========== TRY ONLINE IF MODE IS ON ==========
      if (isOnlineMode.value) {
        print(' ONLINE MODE: Attempting MySQL database save...');
        
        try {
          final response = await http.post(
            Uri.parse('$_apiBaseUrl/register.php'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(userRecord),
          ).timeout(Duration(seconds: 10));
          
          print('📥 Response Status: ${response.statusCode}');
          
          Map<String, dynamic> responseData;
          try {
            responseData = json.decode(response.body);
          } catch (e) {
            print('❌ JSON Parse Error: $e');
            responseData = {'success': false, 'message': 'Invalid server response'};
          }
          
          if (response.statusCode == 201 || response.statusCode == 200) {
            if (responseData['success'] == true) {
              print('✅ MySQL DATABASE SAVE SUCCESSFUL!');
              
              // Also save locally
              await _saveUserToLocalJson(userRecord);
              currentUser.value = userRecord;
              
              Get.snackbar(
                '✅ Success',
                'Registration successful! Please login.',
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              );
              
              return {
                'success': true,
                'message': 'Registration successful! Please login.',
                'user_id': userId,
                'server_id': responseData['store_id'] ?? responseData['user_id'],
                'mode': 'online',
              };
            } else {
              print('❌ MySQL Error: ${responseData['message']}');
              Get.snackbar(
                '❌ Error',
                responseData['message'] ?? 'Registration failed',
                backgroundColor: Colors.red,
              );
            }
          } else {
            print('❌ HTTP Error: ${response.statusCode}');
            Get.snackbar(
              '❌ Server Error',
              'HTTP ${response.statusCode}',
              backgroundColor: Colors.red,
            );
          }
        } catch (e) {
          print('❌ API Call Failed: $e');
          Get.snackbar(
            '⚠️ Connection Error',
            'Server timeout, saving locally',
            backgroundColor: Colors.orange,
          );
        }
        
        print('⚠️ MySQL failed, falling back to local JSON...');
      }
      
      // ========== SAVE TO LOCAL JSON ==========
      print('💾 Saving to local JSON...');
      final localResult = await _saveUserToLocalJson(userRecord);
      
      if (localResult['success']) {
        currentUser.value = userRecord;
        
        Get.snackbar(
          isOnlineMode.value ? '⚠️ Saved Locally' : '✅ Success',
          isOnlineMode.value ? 
            'Saved locally (server failed). Please login.' :
            'Registration saved locally! Please login.',
          backgroundColor: isOnlineMode.value ? Colors.orange : Get.theme.primaryColor,
          duration: Duration(seconds: 3),
        );
        
        return {
          'success': true,
          'message': isOnlineMode.value ? 
            'Saved locally (server failed). Please login.' :
            'Registration saved locally! Please login.',
          'user_id': userId,
          'mode': isOnlineMode.value ? 'offline_fallback' : 'offline',
        };
      } else {
        Get.snackbar(
          '❌ Error',
          localResult['message'] ?? 'Registration failed',
          backgroundColor: Colors.red,
        );
        return localResult;
      }
      
    } catch (e) {
      print('❌ Registration Error: $e');
      Get.snackbar(
        '❌ Error',
        'Registration failed: $e',
        backgroundColor: Colors.red,
      );
      return {'success': false, 'message': 'Registration failed: $e'};
    }
  }
  
  // Helper: Save user to local JSON
  Future<Map<String, dynamic>> _saveUserToLocalJson(Map<String, dynamic> userRecord) async {
    try {
      final List<Map<String, dynamic>> users = await _readJsonFile(_usersFile);
      
      // Check duplicates
      final emailExists = users.any((user) => user['email'] == userRecord['email']);
      final phoneExists = users.any((user) => user['phone'] == userRecord['phone']);
      
      if (emailExists) {
        return {'success': false, 'message': 'Email already registered'};
      }
      if (phoneExists) {
        return {'success': false, 'message': 'Phone already registered'};
      }
      
      users.add(userRecord);
      final saveResult = await _writeJsonFile(_usersFile, users);
      
      if (saveResult['success']) {
        print('✅ User saved to local JSON');
      }
      
      return saveResult;
    } catch (e) {
      print('❌ Error saving to local JSON: $e');
      return {'success': false, 'message': 'Failed to save locally: $e'};
    }
  }

  // ========== DUAL MODE LOGIN ==========
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    print('🔑 Login: Starting...');
    
    try {
      if (email.isEmpty || password.isEmpty) {
        return {'success': false, 'message': 'Email and password are required'};
      }

      final hashedPassword = _simpleHash(password);
      
      print('🔄 Mode: ${isOnlineMode.value ? "ONLINE" : "OFFLINE"}');
      
      if (isOnlineMode.value) {
        // ========== ONLINE MODE: Login via API ==========
        print('🌐 Attempting online login...');
        
        final apiResult = await _callApi('login.php', {
          'email': email,
          'password': hashedPassword,
        }, 'POST');
        
        if (apiResult['success'] && apiResult['data']['success'] == true) {
          print('✅ Online login successful');
          
          final userData = apiResult['data']['user'];
          
          // Update GetX reactive user
          currentUser.value = userData;
          
          // Also save to local for offline access
          await _syncUserToLocal(userData);
          
          Get.snackbar(
            'Success',
            'Login successful! (Online)',
            snackPosition: SnackPosition.BOTTOM,
          );
          
          return {
            'success': true,
            'message': 'Login successful! (Online)',
            'user_data': userData,
            'mode': 'online',
          };
        } else {
          // Online login failed, try local
          print('⚠️ Online login failed, trying local...');
          Get.snackbar(
            'Warning',
            'Online login failed. Trying local login.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
          );
          
          // Continue to try local login
        }
      }
      
      // ========== OFFLINE MODE or Fallback: Login from Local JSON ==========
      print('💾 Attempting local login...');
      
      final List<Map<String, dynamic>> users = await _readJsonFile(_usersFile);
      
      if (users.isEmpty) {
        Get.snackbar('Error', 'No users found. Please register first.');
        return {'success': false, 'message': 'No users found. Please register first.'};
      }

      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == hashedPassword,
        orElse: () => {},
      );

      if (user.isEmpty) {
        Get.snackbar('Error', 'Invalid email or password');
        return {'success': false, 'message': 'Invalid email or password'};
      }

      // Update GetX reactive user
      currentUser.value = user;

      Get.snackbar('Success', 'Login successful! (Offline)');

      print('✅ Local login successful');
      
      return {
        'success': true,
        'message': 'Login successful! (Offline)',
        'user_data': user,
        'mode': 'offline',
      };
      
    } catch (e) {
      print('❌ Login Error: $e');
      Get.snackbar('Error', 'Login error: $e');
      return {'success': false, 'message': 'Login error: $e'};
    }
  }

  // Helper: Sync user to local storage
  Future<void> _syncUserToLocal(Map<String, dynamic> user) async {
    try {
      final List<Map<String, dynamic>> users = await _readJsonFile(_usersFile);
      
      // Check if user exists
      final index = users.indexWhere((u) => 
        u['user_id'] == user['user_id'] || u['email'] == user['email']
      );
      
      if (index != -1) {
        // Update existing
        users[index] = user;
      } else {
        // Add new
        users.add(user);
      }
      
      await _writeJsonFile(_usersFile, users);
      print('✅ User synced to local storage');
    } catch (e) {
      print('❌ Error syncing user to local: $e');
    }
  }

  // ========== TEST CONNECTION METHOD ==========
  Future<void> testApiConnection() async {
    try {
      print('🔗 Testing API connection...');
      
      final url = Uri.parse('$_apiBaseUrl/test_connection.php');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Get.snackbar('✅ Success', 'API Connection working!');
        print('✅ API Connection successful!');
      } else {
        Get.snackbar('❌ Failed', 'API Connection failed');
        print('❌ API Connection failed');
      }
    } catch (e) {
      Get.snackbar('❌ Error', 'Connection test failed: $e');
      print('❌ Connection test failed: $e');
    }
  }

  // ========== GETX METHODS ==========
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return currentUser.value;
  }

  Future<bool> isLoggedIn() async {
    return currentUser.value != null;
  }

  Future<void> logout() async {
    currentUser.value = null;
    Get.snackbar('Logged Out', 'You have been logged out'); 
  }

  // ========== HELPER METHODS ==========
  String _simpleHash(String input) {
    return 'hash_${input.hashCode.abs()}';
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

  // ========== DELETE METHODS ==========
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
      final List<Map<String, dynamic>> customers = await _readJsonFile(_customersFile);

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
      final saveResult = await _writeJsonFile(_customersFile, customers);
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
    return await _readJsonFile(_customersFile);
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
      final List<Map<String, dynamic>> customers = await _readJsonFile(_customersFile);
      
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

      final saveResult = await _writeJsonFile(_customersFile, customers);
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
      final List<Map<String, dynamic>> customers = await _readJsonFile(_customersFile);
      
      final index = customers.indexWhere((customer) => customer['customer_id'] == customerId);
      
      if (index == -1) {
        return {'success': false, 'message': 'Customer not found'};
      }

      // Remove customer
      final deletedCustomer = customers.removeAt(index);

      final saveResult = await _writeJsonFile(_customersFile, customers);
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