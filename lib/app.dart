import 'package:flutter/material.dart';
import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/login/login_page.dart';
import 'package:carcontrol/pages/splash_screen/splash_screen_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarControl',
      theme: ThemeConfig.appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashSreenPage(),
        LoginPage.route: (context) => const LoginPage(),
      },
    );
  }
}
