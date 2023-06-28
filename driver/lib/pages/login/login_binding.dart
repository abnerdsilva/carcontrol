import 'package:carcontrol/pages/login/firebase_service.dart';
import 'package:carcontrol/pages/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseService());
    Get.put(LoginController(Get.find()));
  }
}