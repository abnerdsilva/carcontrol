import 'dart:async';

import 'package:carcontrol/pages/home/home_page.dart';
import 'package:carcontrol/pages/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../model/usuario_model.dart';
import '../../shared/components/custom_button.dart';
import '../../shared/components/custom_text_form_field.dart';
import 'field_validator.dart';

class LoginPage extends StatelessWidget {
  static const String route = '/login';

  late BuildContext context;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  final formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  _validarCampos() {
    //Recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //validar campos
    if (email.isNotEmpty && ValidationUtils.isValidEmail(email)) {
      if (senha.isNotEmpty && senha.length > 6) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);
      } else {
        _showAlertDialog('Erro', 'Preencha a senha! Digite mais de 6 caracteres.');
      }
    } else {
      _showAlertDialog('Erro', 'Preencha o E-mail válido');
    }
  }

  _logarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(email: usuario.email, password: usuario.senha).then((firebaseUser) {
      Get.offAll(const HomePage());
    }).catchError((error) {
      _showAlertDialog('Tente Novamente', 'Verifique o E-mail e Senha!');
    });
  }

  _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 16),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Image.asset('assets/images/carro.png'),
                    ),
                    const SizedBox(height: 0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: CustomTextFormField(
                        radiusBorder: 10,
                        heightWithLabel: 70,
                        height: 50,
                        label: 'E-mail',
                        controller: _controllerEmail,
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
                        controller: _controllerSenha,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: CustomButton(
                                label: 'Entrar',
                                alignment: Alignment.center,
                                fontSize: 16,
                                onClick: () {
                                  _validarCampos();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(color: Color(0xFF1A2E35)),
                      ),
                      onTap: () => _funcaoEsqueciSenha(context),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Novo por aqui?',
                    style: TextStyle(color: Color(0xFF1A2E35)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Get.to(Cadastro()),
                    child: const Text('Registre-se'),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  _funcaoEsqueciSenha(BuildContext context) async {
    if (_controllerEmail.text.isNotEmpty && ValidationUtils.isValidEmail(_controllerEmail.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirme seu e-mail.'),
            content: CustomTextFormField(
              controller: _controllerEmail,
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  _funcaoRecuperarSenha();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      _showAlertDialog("Ops!", "Digite um e-mail válido, para poder recuperar a senha.");
    }
  }

  _funcaoRecuperarSenha() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.fetchSignInMethodsForEmail(_controllerEmail.text).then((signInMethods) async {
      try {
        if (signInMethods.isNotEmpty) {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: _controllerEmail.text);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Esqueci minha senha'),
                content: const Text('Enviamos um e-mail para redefinir sua senha.\n\nVerifique sua caixa de e-mail.'),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Ops!'),
                content: const Text(
                  'E-mail não cadastrado. Por favor, verifique seu e-mail e tente novamente.',
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        _showAlertDialog("Ops!", "Não foi possivel recuperar a senha.\nTente novamente mais tarde!");
      }
    });
  }
}
