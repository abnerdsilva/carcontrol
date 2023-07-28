import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/shared/repositories/firebase_repository.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseRepository());
    Get.put(HomeController(Get.find()));
  }
}