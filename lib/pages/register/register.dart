import 'package:carcontrol/pages/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../login/usuario.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  _validarCampos() {
    //Recuperar dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //validar campos
    if (nome.isNotEmpty && _isNameValid(nome)) {
      if (email.isNotEmpty && _isEmailValid(email)) {
        if (senha.isNotEmpty && senha.length > 6) {
          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;
          usuario.tipoUsuario = "Passageiro";

          _cadastrarUsuario(usuario);

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Cadastrado com Sucesso! '),
                  content: Text("Agora faça o Login na Aplicação."),
                  contentPadding: EdgeInsets.all(16),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Continuar",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        Get.to(LoginPage());
                      },
                    ),
                  ],
                );
              });
        } else {
          setState(() {
            _showAlertDialog(
                'Ops!', 'Preencha a senha! digite mais de 6 caracteres.');
          });
        }
      } else {
        setState(() {
          _showAlertDialog(
              'Ops!', 'Preencha o E-mail válido. \n\nNão use: !,"",' ' ');
        });
      }
    } else {
      setState(() {
        _showAlertDialog('Ops!', 'Preencha o Nome. \n\nNão use: !,"",' ' ');
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      db
          .collection("usuarios")
          .doc(firebaseUser.user!.uid)
          .set(usuario.toMap());
    });
  }

  static bool _isNameValid(nome) {
    // Utilizar uma expressão regular para validar o formato do nome
    String nomeRegex = r'^[A-Za-zÀ-ÖØ-öø-ÿ]+([\s-][A-Za-zÀ-ÖØ-öø-ÿ]+)*$';
    RegExp regex = RegExp(nomeRegex);
    return regex.hasMatch(nome);
  }

  static bool _isEmailValid(String email) {
    // Utilizar uma expressão regular para validar o formato do e-mail
    String emailRegex = r'^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
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
                TextField(
                  controller: _controllerNome,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome Completo",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
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
