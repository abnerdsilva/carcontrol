import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/config/config_page.dart';
import 'package:carcontrol/pages/dashboard/dashboard_page.dart';
import 'package:carcontrol/pages/dashboard/race_model.dart';
import 'package:carcontrol/pages/home/components/custom_bottom_navigation_menu.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/pages/maintenance/maintenance_page.dart';
import 'package:carcontrol/pages/supply/supply_page.dart';
import 'package:carcontrol/shared/components/race_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            Stack(
              children: [
                const DashboardPage(index: 0),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      onPressed: () async {
                        await bottomSheet();
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.race.value.id == 0 || !controller.stausStartRaces.value) return Container();
                  final race = controller.race.value;
                  return Positioned(
                    bottom: 0,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 400,
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
                            child: Text(race.clientName),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Valor da corrida:',
                                  style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                                ),
                                Text(
                                  'R\$ 10,00',
                                  style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
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
                          const Text(
                            '5 minutos (2,2km) de distância',
                            style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Text(
                              'Rua Jardim Antônio Ferreira, 38 - Jardim Panorama, Monte Mor - SP',
                              style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Destino:',
                            style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                          ),
                          const Text(
                            '5 minutos (2,2km) de distância',
                            style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Text(
                              'Rua Jardim Antônio Ferreira, 38 - Jardim Panorama, Monte Mor - SP',
                              style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Ganho:',
                                  style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
                                ),
                                Text(
                                  'R\$ 8,00',
                                  style: TextStyle(color: ThemeConfig.kTextSecundaryColor),
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
                                  final race = RaceModel(id: 0, clientName: '');
                                  controller.setRaceAcceted(race);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
                Obx(() {
                  if (controller.raceAcceted.value.id == 0 || !controller.stausStartRaces.value) return Container();
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: RaceCardWidget(
                      color: ThemeConfig.kGravishBlueColor,
                      function: () {
                        controller.setRaceAcceted(RaceModel(id: 0, clientName: ''));
                      },
                    ),
                  );
                }),
              ],
            ),
            const ConfigPage(),
            // DashboardPage(index: 2),
            // DashboardPage(index: 3),
            // DashboardPage(index: 4),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottonNavigationMenu(),
    );
  }

  Future<void> bottomSheet() async {
    await Get.bottomSheet(
      SizedBox(
        height: 260,
        child: Stack(
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    Get.back();
                    await Get.to(const SupplyPage());
                  },
                  child: const Text('Abastecimento'),
                ),
                TextButton(
                  onPressed: () async {
                    Get.back();
                    await Get.to(const MaintenancePage());
                  },
                  child: const Text('Manutenção'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lucro'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Percurso'),
                ),
                const Divider(),
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.bottomSheet(
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 300,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Relatórios',
                              style: TextStyle(
                                fontSize: 22,
                                color: ThemeConfig.kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Custos'),
                                Text(
                                  'R\$ 100,00',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Receita'),
                                Text(
                                  'R\$ 100,00',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const SizedBox(
                              width: 200,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Abastecimento'),
                                Text('10'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Manutenção'),
                                Text('10'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Percurso'),
                                Text('10'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: ThemeConfig.kSecondaryColor,
                    );
                  },
                  child: const Text('Relatórios'),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      backgroundColor: ThemeConfig.kSecondaryColor,
    );
  }
}
