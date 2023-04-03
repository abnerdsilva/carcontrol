import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/dashboard/race_model.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/shared/components/race_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardPage extends GetView<HomeController> {
  const DashboardPage({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ThemeConfig.kPrimaryColor,
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  controller.setStatusStartRaces(!controller.stausStartRaces.value);
                  if (controller.stausStartRaces.value) {
                    Future.delayed(const Duration(seconds: 10), () {
                      controller.setRace(
                        RaceModel(
                          id: 1,
                          clientName: 'Abner Silva',
                        ),
                      );
                    });
                  }
                },
                child: Obx(() {
                  Color colorStatusRaces = Colors.grey;
                  String messageStatusRaces = 'Começar corridas';
                  if (controller.stausStartRaces.value) {
                    colorStatusRaces = Colors.redAccent;
                    messageStatusRaces = 'Parar corridas';
                  }

                  if (controller.raceAcceted.value.id != 0 && controller.stausStartRaces.value) {
                    return RaceCardWidget(
                      function: () {
                        controller.setRaceAcceted(RaceModel(id: 0, clientName: ''));
                      },
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * .7,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorStatusRaces,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(messageStatusRaces),
                  );
                }),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GetBuilder<HomeController>(
                    init: controller,
                    builder: (value) => GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: true,
                      // initialCameraPosition: _kGooglePlex,
                      initialCameraPosition: CameraPosition(
                        target: controller.position,
                        zoom: 13,
                      ),
                      onMapCreated: controller.onMapCreated,
                      myLocationEnabled: true,
                      markers: controller.markers,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'R\$ 10,00',
                        style: TextStyle(fontSize: 42),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
