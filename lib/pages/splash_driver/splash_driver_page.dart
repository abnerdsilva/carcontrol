import 'package:carcontrol/pages/login/login_page.dart';
import 'package:carcontrol/pages/new_driver/new_driver_page.dart';
import 'package:carcontrol/shared/components/custom_button.dart';
import 'package:flutter/material.dart';

class SplashDriverPage extends StatelessWidget {
  const SplashDriverPage({Key? key}) : super(key: key);

  static const String route = '/splash-driver';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/images/carro.png'),
            ),
            const Text(
              'Seja Bem Vindo(a)',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            CustomButton(
              height: 65,
              label: 'Cadastro de novos Motoristas(a)',
              fontSize: 16,
              alignment: Alignment.center,
              onClick: () => Navigator.pushNamed(context, NewDriverPage.route),
            ),
            const SizedBox(height: 16),
            CustomButton(
              height: 65,
              label: 'Login',
              fontSize: 16,
              alignment: Alignment.center,
              onClick: () => Navigator.pushNamed(context, LoginPage.route),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
