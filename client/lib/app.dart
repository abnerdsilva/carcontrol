import 'package:carcontrol/pages/home/home_page.dart';
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
      title: 'CarControl-Cliente',
      theme: ThemeConfig.appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashSreenPage(),
        LoginPage.route: (context) => LoginPage(),
        HomePage.route: (context) => const HomePage(),
      },
    );
  }
}
