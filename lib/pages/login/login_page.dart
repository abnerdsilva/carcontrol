import 'package:carcontrol/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config/theme_config.dart';

class LoginPage extends StatelessWidget {
  static const String route = '/login';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(50),
            ),
            Center(
              child: Image.asset('assets/images/carro.png'),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Faça seu Login ou Registre-se',
                    style: TextStyle(
                        color: ThemeConfig.kPrimaryColor,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * .7,
                      height: 50,
                      child: Text(" "),
                      decoration: BoxDecoration(
                        color: ThemeConfig.kPrimaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/google-colorido.png')),
                      ),
                    ),
                    onTap: () {
                      Get.off(HomePage());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
