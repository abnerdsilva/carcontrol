import 'package:carcontrol/pages/login/login_page.dart';
import 'package:carcontrol/shared/components/custom_button.dart';
import 'package:flutter/material.dart';

class NewDriverAnalyzePage extends StatelessWidget {
  const NewDriverAnalyzePage({Key? key}) : super(key: key);

  static const String route = '/new-driver-analyze';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/images/cad-analise.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Seu cadastro está em análise :)',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: const Text(
                'Em até 48 horas, iremos te mandar uma resposta via e-mail que utilizou no seu cadastro.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Boa sorte!',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Prosseguir',
              fontSize: 22,
              height: 55,
              alignment: Alignment.center,
              onClick: () => Navigator.popAndPushNamed(context, LoginPage.route),
            ),
          ],
        ),
      ),
    );
  }
}
