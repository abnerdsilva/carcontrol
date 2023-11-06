import 'package:carcontrol/pages/races/race_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get.dart';

import '../home/home_controller.dart';

class FindingDriver extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(60),
            ),
            GestureDetector(
                onTap: () {
                  Get.to(RaceInformation());
                },
                child: Image.asset(
                  'assets/images/waiting.png',
                )),
            const Text('Encontrando Motorista...',
                style: TextStyle(color: Color(0xFF1A2E35), fontSize: 25.0)),
          ],
        ),
      ),
    );
  }
}
