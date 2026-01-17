import 'json_registration.dart';

class ApiService {
  // Use JSON registration instead of PHP
  static final JsonRegistration _json = JsonRegistration();
  
  // ========== USER MANAGEMENT ==========
  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    print('🚀 Calling JSON Registration...');
    return await _json.registerUser(userData);
  }
  
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    return await _json.loginUser(email, password);
  }
  
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _json.getCurrentUser();
  }
  
  static Future<bool> isLoggedIn() async {
    return await _json.isLoggedIn();
  }
  
  static Future<void> logout() async {
    await _json.logout();
  }
  
  // ========== SUPPLIER MANAGEMENT ==========
  static Future<Map<String, dynamic>> addSupplier(Map<String, dynamic> supplierData) async {
    return await _json.addSupplier(supplierData);
  }

  static Future<List<Map<String, dynamic>>> getAllSuppliers() async {
    return await _json.getAllSuppliers();
  }

  // ========== BRAND MANAGEMENT ==========
  static Future<Map<String, dynamic>> addBrand(Map<String, dynamic> brandData) async {
    return await _json.addBrand(brandData);
  }

  static Future<List<Map<String, dynamic>>> getAllBrands() async {
    return await _json.getAllBrands();
  }

  // ========== CATEGORY MANAGEMENT ==========
  static Future<Map<String, dynamic>> addCategory(Map<String, dynamic> categoryData) async {
    return await _json.addCategory(categoryData);
  }

  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    return await _json.getAllCategories();
  }

  // ========== PRODUCT MANAGEMENT ==========
  static Future<Map<String, dynamic>> addProduct(Map<String, dynamic> productData) async {
    return await _json.addProduct(productData);
  }

  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    return await _json.getAllProducts();
  }

  static Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    return await _json.getProductsByCategory(category);
  }

  static Future<List<Map<String, dynamic>>> getProductsByBrand(String brand) async {
    return await _json.getProductsByBrand(brand);
  }

  static Future<List<Map<String, dynamic>>> getProductsBySupplier(String supplier) async {
    return await _json.getProductsBySupplier(supplier);
  }

  static Future<Map<String, dynamic>?> getProductById(String productId) async {
    return await _json.getProductById(productId);
  }

  static Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> updates) async {
    return await _json.updateProduct(productId, updates);
  }

  // ========== DELETE METHODS ==========
  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    return await _json.deleteProduct(productId);
  }

  static Future<Map<String, dynamic>> deleteSupplier(String supplierId) async {
    return await _json.deleteSupplier(supplierId);
  }

  static Future<Map<String, dynamic>> deleteBrand(String brandId) async {
    return await _json.deleteBrand(brandId);
  }

  static Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    return await _json.deleteCategory(categoryId);
  }

  // ========== TEST METHODS ==========
  static Future<void> testJsonStorage() async {
    await _json.testJsonStorage();
  }

  static Future<void> testSuppliersStorage() async {
    await _json.testSuppliersStorage();
  }

  static Future<void> testAllData() async {
    await _json.testAllData();
  }
  // ========== CUSTOMER MANAGEMENT ==========
static Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> customerData) async {
  return await _json.addCustomer(customerData);
}

static Future<List<Map<String, dynamic>>> getAllCustomers() async {
  return await _json.getAllCustomers();
}

static Future<List<Map<String, dynamic>>> getCustomersWithDue() async {
  return await _json.getCustomersWithDue();
}

static Future<List<Map<String, dynamic>>> getCustomersWithCredit() async {
  return await _json.getCustomersWithCredit();
}

static Future<Map<String, dynamic>> updateCustomerAmount(String customerId, double newAmount, String amountType) async {
  return await _json.updateCustomerAmount(customerId, newAmount, amountType);
}

static Future<Map<String, dynamic>> deleteCustomer(String customerId) async {
  return await _json.deleteCustomer(customerId);
}
}