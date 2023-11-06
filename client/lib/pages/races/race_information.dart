import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../home/home_controller.dart';

class RaceInformation extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informações Corrida"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GetBuilder<HomeController>(
                    init: controller,
                    builder: (value) => GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: true,
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

            Container(
              margin: const EdgeInsets.all(100),
              width: MediaQuery.of(context).size.width * 50,
              height: 90,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
