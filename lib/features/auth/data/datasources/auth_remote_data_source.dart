import 'package:dio/dio.dart';
import 'package:paperless_store_upd/core/network/network_executor.dart'; 

class AuthRemoteDataSource {
  final NetworkExecutor _executor; 

  AuthRemoteDataSource(this._executor);

  Future<Response> registerUser(Map<String, dynamic> params) async {
    Map<String, dynamic> textData = {
      "name": params['registrantName'],
      "shop_name": params['shopName'],
      "proprietor_name": params['proprietorName'],
      "phone": params['phoneNumber'],
      "email": params['email'],
      "shop_type": params['shopType'],
      "address": params['address'],
      "trade_license": params['tradeLicense'],
      "password": params['password'],
      "source": "app", 
    };

    FormData formData = FormData.fromMap(textData);

    if (params['profileImagePath'] != null && params['profileImagePath'].toString().isNotEmpty) {
      formData.files.add(MapEntry(
        "file_owner_pic", 
        await MultipartFile.fromFile(params['profileImagePath']),
      ));
    }
    
    if (params['tradeLicensePath'] != null && params['tradeLicensePath'].toString().isNotEmpty) {
      formData.files.add(MapEntry(
        "file_trade_license", 
        await MultipartFile.fromFile(params['tradeLicensePath']),
      ));
    }

    return await _executor.executePost(
      endpoint: 'auth/register.php', 
      data: formData,
    );
  }

  Future<Response> loginUser(String email, String password) async {
    Map<String, dynamic> loginData = {
      "email": email,
      "password": password,
      "lang": "en", 
    };

    return await _executor.executePost(
      endpoint: 'auth/login.php', 
      data: FormData.fromMap(loginData),
    );
  }
}