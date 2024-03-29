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
                DashboardPage(),
              ],
            ),
            const ConfigPage(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottonNavigationMenu(),
    );
  }
}
