import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/model/race_model.dart';
import 'package:flutter/material.dart';

class RaceCardWidget extends StatelessWidget {
  final Color? color;
  final RaceModel race;
  final Function()? function;

  const RaceCardWidget({
    Key? key,
    required this.race,
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
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          race.clientName!,
                          style: const TextStyle(color: ThemeConfig.kTextThirdColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${race.distanceDestination} km de distância',
                    style: const TextStyle(
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
