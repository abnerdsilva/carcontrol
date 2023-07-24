import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/shared/components/race_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsWidget extends GetView<HomeController> {
  const MapsWidget({Key? key}) : super(key: key);

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
                  controller.clearPoints();

                  if (controller.stausStartRaces.value) {
                    Future.delayed(const Duration(seconds: 10), () {
                      controller.getFirstPendingRaces();
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

                  if (controller.raceAcceted.value.id != '0' && controller.stausStartRaces.value) {
                    return Container();
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
            // TextButton(
            //   onPressed: () => controller.createRace(),
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     child: const Text('Adicionar'),
            //   ),
            // ),
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
                      polylines: controller.polyline,
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 20),
                  //   child: const Align(
                  //     alignment: Alignment.topCenter,
                  //     child: Text(
                  //       'R\$ 10,00',
                  //       style: TextStyle(fontSize: 42),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Obx(
              () {
                if (controller.raceAcceted.value.id != '0' && controller.stausStartRaces.value) {
                  return RaceCardWidget(
                    race: controller.raceAcceted.value,
                    color: ThemeConfig.kGravishBlueColor,
                    function: () async {
                      await controller.concludeRace(controller.raceAcceted.value);
                    },
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
