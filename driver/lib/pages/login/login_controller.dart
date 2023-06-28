import 'dart:developer';

import 'package:carcontrol/pages/home/home_page.dart';
import 'package:carcontrol/pages/login/firebase_service.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late final FirebaseService _fbService;
  late final SharedPrefsRepository _spRepository;

  LoginController(this._fbService);

  @override
  void onInit() async {
    super.onInit();
    _spRepository = await SharedPrefsRepository.instance;

    if (_spRepository.firebaseID != null) {
      if (_spRepository.firebaseID!.isNotEmpty) {
        Get.offAllNamed(HomePage.route);
      }
    }
  }

  Future<void> login(String email, String password) async {
    final userCredential = await _fbService.signInWithEmailPassword(email, password);
    if (userCredential.user == null) {
      return;
    }

    await _spRepository.registerFirebaseId(userCredential.user!.uid);

    Get.offAllNamed(HomePage.route);
  }

  Future<void> loginGoogle() async {
    final userCredential = await _fbService.signInwithGoogle();
    if (userCredential != null) {
      print(userCredential.user?.uid.toString());
      log(userCredential.user.toString());

      await _spRepository.registerFirebaseId(userCredential.user!.uid);

      Get.offAllNamed(HomePage.route);
    }
  }
}
