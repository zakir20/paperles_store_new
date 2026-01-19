import 'package:dio/dio.dart';
import 'package:paperless_store_upd/core/network/network_executor.dart'; 
import '../models/user_model.dart'; 

class AuthRemoteDataSource {
  final NetworkExecutor _executor; 

  AuthRemoteDataSource(this._executor);

  // Register User
  // Now accepts [UserModel] instead of a raw Map
  Future<Response> registerUser(UserModel user) async {
    // Get the clean text data using the toJson method from the model
    // This handles the keys like 'name', 'shop_name', etc.
    final Map<String, dynamic> textData = user.toJson();

    //  Create the FormData for Multipart support
    final FormData formData = FormData.fromMap(textData);

    //  Add images using the paths stored in the model
    if (user.profileImagePath != null && user.profileImagePath!.isNotEmpty) {
      formData.files.add(MapEntry(
        "file_owner_pic", 
        await MultipartFile.fromFile(user.profileImagePath!),
      ));
    }
    
    if (user.tradeLicensePath != null && user.tradeLicensePath!.isNotEmpty) {
      formData.files.add(MapEntry(
        "file_trade_license", 
        await MultipartFile.fromFile(user.tradeLicensePath!),
      ));
    }

    // 5. Execute via the NetworkExecutor
    return await _executor.executePost(
      endpoint: 'auth/register.php', 
      data: formData,
    );
  }

  // Login User
  Future<Response> loginUser(String email, String password) async {
    final Map<String, dynamic> loginData = {
      "email": email,
      "password": password,
      "lang": "en", 
    };

    //  FormData for login as well to keep $_POST consistent in PHP
    return await _executor.executePost(
      endpoint: 'auth/login.php', 
      data: FormData.fromMap(loginData),
    );
  }
}