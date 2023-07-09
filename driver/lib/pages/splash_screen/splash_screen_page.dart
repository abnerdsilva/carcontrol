import 'package:carcontrol/pages/home/home_page.dart';
import 'package:carcontrol/pages/login/login_page.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashSreenPage extends StatefulWidget {

  static const String route = '/';

  const SplashSreenPage({Key? key}) : super(key: key);

  @override
  State<SplashSreenPage> createState() => _SplashSreenPageState();
}

class _SplashSreenPageState extends State<SplashSreenPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      final prefs = await SharedPrefsRepository.instance;
      if (prefs.firebaseID != null) {
        if (prefs.firebaseID!.isNotEmpty) {
          Get.offAllNamed(HomePage.route);
          return;
        }
      }
      Get.offAllNamed(LoginPage.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/images/carro-com-letreiro.png'),
        ),
      ),
    );
  }
}
