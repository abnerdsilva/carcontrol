import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottonNavigationMenu extends GetView<HomeController> {
  CustomBottonNavigationMenu({Key? key}) : super(key: key);

  final TextStyle unselectedLabelStyle = TextStyle(
    color: Colors.white.withOpacity(0.5),
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );
  final TextStyle selectedLabelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Obx(
        () => BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
          unselectedItemColor: Colors.white38,
          backgroundColor: ThemeConfig.kPrimaryColor,
          selectedItemColor: Colors.white70,
          unselectedLabelStyle: unselectedLabelStyle,
          selectedLabelStyle: selectedLabelStyle,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 7),
                child: const Icon(
                  Icons.home,
                  size: 20.0,
                ),
              ),
              label: 'Home',
              backgroundColor: ThemeConfig.kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 7),
                child: const Icon(
                  Icons.location_history,
                  size: 20.0,
                ),
              ),
              label: 'Config',
              backgroundColor: ThemeConfig.kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
