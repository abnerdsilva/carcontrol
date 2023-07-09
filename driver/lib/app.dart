import 'package:carcontrol/pages/home/home_binding.dart';
import 'package:carcontrol/pages/home/home_page.dart';
import 'package:carcontrol/pages/login/login_binding.dart';
import 'package:carcontrol/pages/maintenance/maintenance_page.dart';
import 'package:carcontrol/pages/new_driver/new_driver_page.dart';
import 'package:carcontrol/pages/new_driver_analyse/new_driver_analyze_page.dart';
import 'package:carcontrol/pages/supply/supply_page.dart';
import 'package:flutter/material.dart';
import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/login/login_page.dart';
import 'package:carcontrol/pages/splash_screen/splash_screen_page.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CarControl',
      theme: ThemeConfig.appTheme,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: SplashSreenPage.route,
          page: () => const SplashSreenPage(),
        ),
        GetPage(
          name: LoginPage.route,
          page: () => LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: NewDriverPage.route,
          page: () => const NewDriverPage(),
        ),
        GetPage(
          name: NewDriverAnalyzePage.route,
          page: () => const NewDriverAnalyzePage(),
        ),
        GetPage(
          name: HomePage.route,
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: SupplyPage.route,
          page: () => const SupplyPage(),
        ),
        GetPage(
          name: MaintenancePage.route,
          page: () => const MaintenancePage(),
        ),
      ],
    );
  }
}
