import 'package:carcontrol/pages/login/login_controller.dart';
import 'package:carcontrol/pages/new_driver/new_driver_page.dart';
import 'package:carcontrol/shared/components/custom_button.dart';
import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({Key? key}) : super(key: key);

  static const String route = '/login';

  final TextEditingController passEC = TextEditingController();
  final TextEditingController emailEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Column(
              children: [
                Form(
                  key: formKey,
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
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'E-mail',
                          controller: emailEC,
                          validator: (String? value) {
                            if (value == null || value.isEmpty || !value.isEmail) {
                              return 'E-mail inválido.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'Senha',
                          controller: passEC,
                          obscureText: true,
                          validator: (String? value) {
                            if (value == null || value.length < 6) {
                              return 'Senha deve conter no mínimo 6 caracteres.';
                            }
                            return null;
                          },
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
                              onClick: () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                await controller.login(emailEC.text, passEC.text);
                              },
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
                          InkWell(
                            onTap: () => controller.loginGoogle(),
                            child: Image.asset('assets/images/btngoogle.png'),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          // Image.asset('assets/images/btnfacebook.png'),
                          // Signin
                        ],
                      ),
                      // const SizedBox.expand(),
                      // Expanded(
                      //   child: Container(),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Expanded(
                //   child: Container(),
                // ),
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
      ),
    );
  }
}
