import 'dart:developer';

import 'package:carcontrol/pages/login/user_driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../../shared/components/custom_text_form_field.dart';
import 'field_validator.dart';
import 'login_page.dart';

class CadastroMotorista extends StatefulWidget {
  const CadastroMotorista({super.key});

  @override
  State<CadastroMotorista> createState() => _CadastroState();
}

class _CadastroState extends State<CadastroMotorista> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerCpf = MaskedTextController(mask: '000.000.000-00');
  final TextEditingController _controllerDataNascimento = MaskedTextController(mask: '00/00/0000');
  final TextEditingController _controllerEndereco = TextEditingController();
  final TextEditingController _controllerTelefone = MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController _controllerCnh = MaskedTextController(mask: "0000000000");
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

  _validarCampos() async {
    if (_controllerNome.text.isNotEmpty &&
        ValidationUtils.isValidName(_controllerNome.text) &&
        _controllerNome.text.length < 100) {
      if (_controllerCpf.text.isNotEmpty && ValidationUtils.isValidCPF(_controllerCpf.text)) {
        if (_controllerDataNascimento.text.isNotEmpty &&
            ValidationUtils.isValidDateOfBirth(_controllerDataNascimento.text)) {
          if (_controllerEndereco.text.isNotEmpty && _controllerEndereco.text.length < 150) {
            if (_controllerCnh.text.isNotEmpty && _controllerCnh.text.length < 12) {
              if (_controllerTelefone.text.isNotEmpty && ValidationUtils.isValidNumber(_controllerTelefone.text)) {
                if (_controllerEmail.text.isNotEmpty &&
                    ValidationUtils.isValidEmail(_controllerEmail.text) &&
                    _controllerEmail.text.length < 100) {
                  if (_controllerSenha.text.isNotEmpty &&
                      _controllerSenha.text.length > 6 &&
                      _controllerSenha.text.length < 20) {
                    Driver driver = Driver();

                    String enderecoDestino = _controllerEndereco.text;

                    if (enderecoDestino.isNotEmpty) {
                      List<Location> enderecoDigitado = await locationFromAddress(enderecoDestino);

                      Location pegarLatitudeLongitude = enderecoDigitado[0];

                      List<Placemark> enderecoLocalizado = await placemarkFromCoordinates(
                        pegarLatitudeLongitude.latitude,
                        pegarLatitudeLongitude.longitude,
                      );

                      Placemark endereco = enderecoLocalizado[0];

                      log("\n\n\n\n Endereco do Motorista \n\n\n\n $endereco\n\n\n\n");

                      driver.cidade = endereco.administrativeArea!;
                      driver.bairro = endereco.subLocality!;
                      driver.rua = endereco.thoroughfare!;
                      driver.numero = endereco.subThoroughfare!;
                      driver.cep = endereco.postalCode!;

                      String enderecoConfirmacao;

                      enderecoConfirmacao = "\n Cidade: ${driver.cidade}\n Rua: ${driver.rua}, ${driver.numero}"
                          "\n Bairro: ${driver.bairro}\n Cep: ${driver.cep}";

                      Get.dialog(
                        AlertDialog(
                          title: const Text('Confirmação de Endereço'),
                          content: Text(enderecoConfirmacao),
                          contentPadding: const EdgeInsets.all(16),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                "Confirmar",
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                _cadastrarInformacoes(driver);
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      _showAlertDialog("Ops!", "Endereço de Destino Vazio.");
                    }
                  } else {
                    setState(() {
                      _showAlertDialog(
                          'Ops!', 'Preencha uma Senha de no mínimo 6 e máximo 20 caracteres. \n\nNão use: !,""');
                    });
                  }
                } else {
                  setState(() {
                    _showAlertDialog('Ops!', 'Preencha um E-mail de no máximo 100 caracteres. \n\nNão use: !,""');
                  });
                }
              } else {
                setState(() {
                  _showAlertDialog('Ops!', 'Preencha um Telefone Válido. \n\nNão use: !,""');
                });
              }
            } else {
              setState(() {
                _showAlertDialog('Ops!', 'Preencha um Número de CNH de no máximo de 11 caracteres. \n\nNão use: !,""');
              });
            }
          } else {
            setState(() {
              _showAlertDialog('Ops!', 'Preencha um Cidade Válida. \n\nNão use: !,""');
            });
          }
        } else {
          setState(() {
            _showAlertDialog('Ops!', 'Preencha uma Data de Nascimento Válida. \n\nNão use: !,""');
          });
        }
      } else {
        setState(() {
          _showAlertDialog('Ops!', 'Preencha um Número de CPF Válido. \n\nNão use: !,""');
        });
      }
    } else {
      setState(() {
        _showAlertDialog('Ops!', 'Preencha um Nome de no máximo 100 caracteres. \n\nNão use: !,""');
      });
    }
  }

  void _cadastrarInformacoes(Driver driver) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    auth.fetchSignInMethodsForEmail(email).then((signInMethods) async {
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: senha,
        );

        if (userCredential.user != null) {
          FirebaseFirestore db = FirebaseFirestore.instance;

          User? firebase = await getUsuarioAtual();

          driver.id = firebase!.uid;
          driver.nome = _controllerNome.text;
          driver.cpf = _controllerCpf.text;
          driver.dataNascimento = _controllerDataNascimento.text;
          driver.telefone = _controllerTelefone.text;
          driver.cnh = _controllerCnh.text;
          driver.email = _controllerEmail.text;
          driver.senha = _controllerSenha.text;

          db.collection("motoristas").doc(firebase.uid).set(driver.toMap()).then((_) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Cadastrado com Sucesso!'),
                  content: const Text("Agora faça o Login na Aplicação."),
                  contentPadding: const EdgeInsets.all(16),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
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
      } catch (e) {
        setState(() {
          _showAlertDialog(
            "Ops!",
            "Não foi possível criar o usuário. Verifique os dados e tente novamente.",
          );
        });
      }
    }).catchError((error) {
      _showAlertDialog("Ops!", "Ocorreu um erro ao processar a operação.");
    });
  }

  Future<User?> getUsuarioAtual() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
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
                          label: 'Nome Completo',
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
                          label: 'Data de Nascimento',
                          controller: _controllerDataNascimento,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'Endereço Completo',
                          controller: _controllerEndereco,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: CustomTextFormField(
                          radiusBorder: 10,
                          heightWithLabel: 70,
                          height: 50,
                          label: 'Número da CNH',
                          controller: _controllerCnh,
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
                          obscureText: true,
                          label: 'Senha',
                          controller: _controllerSenha,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
