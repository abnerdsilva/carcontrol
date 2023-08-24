import 'package:carcontrol/pages/config/config_page.dart';
import 'package:carcontrol/pages/finance/finance_page.dart';
import 'package:carcontrol/pages/home/components/maps_widget.dart';
import 'package:carcontrol/pages/home/components/custom_bottom_navigation_menu.dart';
import 'package:carcontrol/pages/home/components/race_widget.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/pages/race/race_page.dart';
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
                Obx(() {
                  if (controller.race.value.id == '0' || !controller.stausStartRaces.value) return Container();
                  return RaceWidget(race: controller.race.value);
                }),
              ],
            ),
            const RacePage(),
            const FinancePage(),
            const ConfigPage(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottonNavigationMenu(),
    );
  }
}
