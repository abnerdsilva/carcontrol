import 'package:carcontrol/pages/config/config_page.dart';
import 'package:carcontrol/pages/dashboard/dashboard_page.dart';
import 'package:carcontrol/pages/home/components/custom_bottom_navigation_menu.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
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
                )
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
                  onPressed: () {},
                  child: const Text('Abastecimento'),
                ),
                TextButton(
                  onPressed: () {},
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
                  onPressed: () {},
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
      backgroundColor: Colors.grey,
    );
  }
}
