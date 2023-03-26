import 'package:carcontrol/config/theme_config.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
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
              height: 120,
              child: Container(
                // color: Colors.grey,
                margin: const EdgeInsets.all(30),
                width: MediaQuery.of(context).size.width * .7,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Text('Começar corridas'),
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
