import 'package:carcontrol/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinishRace extends StatefulWidget {
  @override
  State<FinishRace> createState() => _FinishRaceState();
}

class _FinishRaceState extends State<FinishRace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Image.asset(
                'assets/images/check.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 10),
              Text(
                "Corrida Finalizada com Sucesso!",
                style: TextStyle(
                  fontSize: 20, // Tamanho da fonte desejado
                  fontWeight: FontWeight.bold, // Texto em negrito
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
          onTap: () {
            Get.offAll(HomePage());
          },
        ),
      ),
    );
  }
}
