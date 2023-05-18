import 'package:carcontrol/pages/home/home_page.dart';
import 'package:carcontrol/pages/new_driver/new_driver_page.dart';
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
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 50),
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
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset('assets/images/btngoogle.png'),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Center(
                    child: Image.asset('assets/images/btnfacebook.png'),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Novo por aqui?'),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, NewDriverPage.route),
                    child: const Text('Registre-se'),
                  ),
                ],
              ),
              // const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
