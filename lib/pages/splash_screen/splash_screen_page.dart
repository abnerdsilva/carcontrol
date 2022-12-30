import 'package:carcontrol/pages/splash_driver/splash_driver_page.dart';
import 'package:flutter/material.dart';

class SplashSreenPage extends StatefulWidget {
  const SplashSreenPage({Key? key}) : super(key: key);

  @override
  State<SplashSreenPage> createState() => _SplashSreenPageState();
}

class _SplashSreenPageState extends State<SplashSreenPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(context, SplashDriverPage.route, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/images/carro.png'),
            ),
            const Text(
              'CarControl',
              style: TextStyle(fontSize: 26),
            ),
          ],
        ),
      ),
    );
  }
}
