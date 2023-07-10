import 'package:carcontrol/pages/config/config_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfigController());

    _deslogarUsuario() async {
      FirebaseAuth auth = FirebaseAuth.instance;

      await auth.signOut();
      Navigator.pushReplacementNamed(context, "/");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text(
                      "Deslogar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      _deslogarUsuario();
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
