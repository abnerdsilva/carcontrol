import 'package:carcontrol/pages/home/home_page.dart';
import 'package:carcontrol/shared/components/custom_button.dart';
import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String route = '/login';

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
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: const CustomTextFormField(
                radiusBorder: 10,
                heightWithLabel: 53,
                height: 30,
                label: 'Usuário',
                obscureText: true,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: const CustomTextFormField(
                radiusBorder: 10,
                heightWithLabel: 53,
                height: 30,
                label: 'Senha',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Esqueci minha senha',
                    style: TextStyle(color: Colors.red),
                  ),
                  CustomButton(
                    label: 'Entrar',
                    alignment: Alignment.center,
                    width: 80,
                    fontSize: 16,
                    onClick: () => Navigator.pushNamedAndRemoveUntil(context, HomePage.route, (route) => false),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
