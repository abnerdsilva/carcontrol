import 'package:carcontrol/pages/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../shared/components/custom_text_form_field.dart';
import '../login/field_validator.dart';
import '../../model/usuario_model.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCpf =
      MaskedTextController(mask: '000.000.000-00');
  TextEditingController _controllerTelefone =
      MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  final formKey = GlobalKey<FormState>();

  _validarCampos() async {
    if (_controllerNome.text.isNotEmpty &&
        ValidationUtils.isValidName(_controllerNome.text) &&
        _controllerNome.text.length < 100) {
      if (_controllerTelefone.text.isNotEmpty &&
          ValidationUtils.isValidNumber(_controllerTelefone.text)) {
        if (_controllerCpf.text.isNotEmpty &&
            ValidationUtils.isValidCPF(_controllerCpf.text)) {
          if (_controllerEmail.text.isNotEmpty &&
              ValidationUtils.isValidEmail(_controllerEmail.text) &&
              _controllerEmail.text.length < 100) {
            if (_controllerSenha.text.isNotEmpty &&
                _controllerSenha.text.length > 6 &&
                _controllerSenha.text.length < 20) {
              _criacaoUsuario();
            } else {
              setState(() {
                _showAlertDialog('Ops!',
                    'Preencha uma Senha de no mínimo 6 e máximo 20 caracteres. \n\nNão use: !,""');
              });
            }
          } else {
            setState(() {
              _showAlertDialog('Ops!',
                  'Preencha um E-mail de no máximo 100 caracteres. \n\nNão use: !,""');
            });
          }
        } else {
          setState(() {
            _showAlertDialog(
                'Ops!', 'Preencha um Número de CPF Válido. \n\nNão use: !,""');
          });
        }
      } else {
        setState(() {
          _showAlertDialog(
              'Ops!', 'Preencha um Telefone Válido. \n\nNão use: !,""');
        });
      }
    } else {
      setState(() {
        _showAlertDialog('Ops!',
            'Preencha um Nome de no máximo 100 caracteres. \n\nNão use: !,""');
      });
    }
  }

  Future<User?> getUsuarioAtual() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  void _criacaoUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    auth.fetchSignInMethodsForEmail(email).then((signInMethods) async {
      if (signInMethods.isEmpty) {
        try {
          UserCredential userCredential =
              await auth.createUserWithEmailAndPassword(
            email: email,
            password: senha,
          );

          if (userCredential.user != null) {
            _cadastrarUsuario(userCredential.user!);
          }
        } catch (e) {
          setState(() {
            _showAlertDialog("Ops!",
                "Não foi possível criar o usuário. Verifique os dados e tente novamente.");
          });
        }
      } else {
        _showAlertDialog(
            "Ops!", "Esse E-mail já foi utilizado. Tente usar outro!");
      }
    });
  }

  void _cadastrarUsuario(User firebaseUser) async {
    Usuario usuario = Usuario();

    FirebaseFirestore db = FirebaseFirestore.instance;

    usuario.id = firebaseUser.uid;
    usuario.nome = _controllerNome.text;
    usuario.email = _controllerEmail.text;
    usuario.senha = _controllerSenha.text;
    usuario.telefone = _controllerTelefone.text;
    usuario.cpf = _controllerCpf.text;
    usuario.tipoUsuario = "Passageiro";

    db
        .collection("usuarios")
        .doc(firebaseUser.uid)
        .set(usuario.toMap())
        .then((_) async {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cadastrado com Sucesso!'),
            content: Text("Agora faça o Login na Aplicação."),
            contentPadding: EdgeInsets.all(16),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Continuar",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          );
        },
      );
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
              child: Text('OK'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'Nome',
                          controller: _controllerNome,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'Telefone',
                          controller: _controllerTelefone,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'Número do CPF',
                          controller: _controllerCpf,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'E-mail',
                          controller: _controllerEmail,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
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
                          children: [],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
