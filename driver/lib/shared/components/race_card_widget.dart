import 'package:carcontrol/config/theme_config.dart';
import 'package:flutter/material.dart';

class RaceCardWidget extends StatelessWidget {
  final Color? color;
  final Function()? function;

  const RaceCardWidget({
    Key? key,
    this.color,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: color ?? ThemeConfig.kPrimaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.person, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Nome Cliente',
                          style: TextStyle(color: ThemeConfig.kTextThirdColor),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '5 minutos (2,2km) de distância',
                    style: TextStyle(
                      color: ThemeConfig.kTextSecundaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: function,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
