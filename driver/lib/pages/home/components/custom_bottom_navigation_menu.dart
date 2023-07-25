import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottonNavigationMenu extends GetView<HomeController> {
  CustomBottonNavigationMenu({Key? key}) : super(key: key);

  final TextStyle unselectedLabelStyle = TextStyle(
    color: Colors.white.withOpacity(0.5),
    fontWeight: FontWeight.w500,
    fontSize: 1,
  );
  final TextStyle selectedLabelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 1,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Obx(
        () => BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
          unselectedItemColor: Colors.white38,
          backgroundColor: ThemeConfig.kPrimaryColor,
          selectedItemColor: Colors.white70,
          unselectedLabelStyle: unselectedLabelStyle,
          selectedLabelStyle: selectedLabelStyle,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 28.0,
              ),
              label: '',
              backgroundColor: ThemeConfig.kPrimaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_sharp,
                size: 28.0,
              ),
              label: '',
              backgroundColor: ThemeConfig.kPrimaryColor,
            ),
            // BottomNavigationBarItem(
            //   icon: Container(
            //     margin: const EdgeInsets.only(bottom: 7),
            //     child: const Icon(
            //       Icons.menu,
            //       size: 20.0,
            //     ),
            //   ),
            //   label: 'Pedidos',
            //   backgroundColor: ThemeConfig.kPrimaryColor,
            // ),
            // BottomNavigationBarItem(
            //   icon: Container(
            //     margin: const EdgeInsets.only(bottom: 7),
            //     width: 30,
            //     child: Container(),
            //   ),
            //   label: '',
            //   backgroundColor: ThemeConfig.kPrimaryColor,
            // ),
            // BottomNavigationBarItem(
            //   icon: Container(
            //     margin: const EdgeInsets.only(bottom: 7),
            //     child: const Icon(
            //       Icons.location_city,
            //       size: 20.0,
            //     ),
            //   ),
            //   label: 'Endereços',
            //   backgroundColor: ThemeConfig.kPrimaryColor,
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.location_history,
                size: 28.0,
              ),
              label: '',
              backgroundColor: ThemeConfig.kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
