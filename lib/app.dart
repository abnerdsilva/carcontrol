import 'package:carcontrol/pages/home/home_page.dart';
import 'package:carcontrol/pages/new_driver/new_driver_page.dart';
import 'package:carcontrol/pages/new_driver_analyse/new_driver_analyze_page.dart';
import 'package:carcontrol/pages/splash_driver/splash_driver_page.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashSreenPage(),
        SplashDriverPage.route: (context) => const SplashDriverPage(),
        LoginPage.route: (context) => const LoginPage(),
        NewDriverPage.route: (context) => const NewDriverPage(),
        NewDriverAnalyzePage.route: (context) => const NewDriverAnalyzePage(),
        HomePage.route: (context) => const HomePage(),
        SupplyPage.route: (context) => const SupplyPage(),
      },
    );
  }
}
