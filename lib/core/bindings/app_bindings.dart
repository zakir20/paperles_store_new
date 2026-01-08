// lib/core/bindings/app_bindings.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/language_controller.dart';
import '../services/api_service.dart';
import '../services/json_registration.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/register_controller.dart';

class AppBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    await GetStorage.init();
    Get.put(JsonRegistration(), permanent: true);
    Get.put(ApiService(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
  }
}