import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/dashboard/race_model.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/shared/components/race_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../races/choose_driver.dart';

class DashboardPage extends GetView<HomeController> {
  const DashboardPage({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Para onde vamos hoje ? "),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ChooseDriver());
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ThemeConfig.kPrimaryColor,
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  controller
                      .setStatusStartRaces(!controller.stausStartRaces.value);
                },
                child: Obx(() {
                  Color colorStatusRaces = Colors.grey;
                  if (controller.stausStartRaces.value) {}

                  if (controller.raceAcceted.value.id != '0' &&
                      controller.stausStartRaces.value) {
                    return RaceCardWidget(
                      function: () {
                        controller
                            .setRaceAcceted(RaceModel(id: 0, clientName: ''));
                      },
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorStatusRaces,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    //child: Text(messageStatusRaces),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
