import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/model/race_model.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RaceWidget extends GetView<HomeController> {
  const RaceWidget({Key? key, required this.race}) : super(key: key);

  final RaceModel race;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 20,
      right: 20,
      child: Container(
        // height: 400,
        padding: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
          color: ThemeConfig.kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 20,
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * .7,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(race.clientName!),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Valor da corrida:',
                    style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                  ),
                  Text(
                    'R\$ ${race.value}',
                    style: const TextStyle(color: ThemeConfig.kTextSecundaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: const Divider(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Origem:',
              style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                race.addressOrigem!,
                style: const TextStyle(color: ThemeConfig.kTextSecundaryColor),
              ),
            ),
            Text(
              '${race.distanceOrigem} de distância',
              style: const TextStyle(color: ThemeConfig.kTextSecundaryColor),
            ),
            const SizedBox(height: 16),
            const Text(
              'Destino:',
              style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                race.addressDestination!,
                style: const TextStyle(color: ThemeConfig.kTextSecundaryColor),
              ),
            ),
            Text(
              '${race.distanceDestination} de distância',
              style: const TextStyle(color: ThemeConfig.kTextSecundaryColor),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: const Divider(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ganho motorista:',
                    style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                  ),
                  Text(
                    'R\$ ${race.valueDriver!.toStringAsFixed(2)}',
                    style: const TextStyle(color: ThemeConfig.kTextSecundaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: const Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
                  ),
                  child: const Text('Aceitar Corrida'),
                  onPressed: () => controller.setRaceAcceted(race),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.redAccent),
                  ),
                  child: const Text('Recusar Corrida'),
                  onPressed: () {
                    controller.clearPoints();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}