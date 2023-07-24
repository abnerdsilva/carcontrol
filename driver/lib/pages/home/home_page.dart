import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/config/config_page.dart';
import 'package:carcontrol/pages/home/components/maps_widget.dart';
import 'package:carcontrol/pages/home/components/custom_bottom_navigation_menu.dart';
import 'package:carcontrol/pages/home/components/race_widget.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/pages/maintenance/maintenance_page.dart';
import 'package:carcontrol/pages/supply/supply_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            Stack(
              children: [
                const MapsWidget(),
                Obx(
                  () => controller.raceAcceted.value.id != '0'
                      ? Container()
                      : Positioned(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FloatingActionButton(
                              onPressed: () async => await bottomSheet(),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ),
                ),
                Obx(() {
                  if (controller.race.value.id == '0' || !controller.stausStartRaces.value) return Container();
                  return RaceWidget(race: controller.race.value);
                }),
              ],
            ),
            // Container(),
            const ConfigPage(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottonNavigationMenu(),
    );
  }

  Future<void> bottomSheet() async {
    await Get.bottomSheet(
      SizedBox(
        height: 160,
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
                // TextButton(
                //   onPressed: () {},
                //   child: const Text('Lucro'),
                // ),
                // TextButton(
                //   onPressed: () {},
                //   child: const Text('Percurso'),
                // ),
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
