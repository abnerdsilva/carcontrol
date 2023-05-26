import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../finding_driver/finding_driver.dart';
import '../home/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../shared/components/custom_text_form_field.dart';
import 'package:get/get.dart';

class ChooseDriver extends StatefulWidget {
  @override
  State<ChooseDriver> createState() => _ChooseDriverState();
}

class _ChooseDriverState extends State<ChooseDriver> {
  double? latitude;

  double? longitude;

  late String endereco;

  late HomeController controller;

  @override
  void initState() {
    controller = Get.find<HomeController>();
    pegarPosicao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Corridas"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //endereco != null ? Text('Endereço: $endereco') : Text('Endereco Vazio'),

            Container(
              margin: const EdgeInsets.all(10),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: 60,
              child: CustomTextFormField(
                radiusBorder: 10,
                heightWithLabel: 53,
                height: 30,
                label: 'Origem',
                initialValue: endereco,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFF1A2E35),
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  //Color: Colors.amber,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF1A2E35)),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: 60,
              child: const CustomTextFormField(
                radiusBorder: 10,
                heightWithLabel: 53,
                height: 30,
                label: 'Destino',

                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Color(0xFF1A2E35),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Color(0xFF1A2E35)),
                  ),
                ),
                //obscureText: true,
              ),
            ),
            GestureDetector(
                child: Container(
              margin: const EdgeInsets.all(6),
              child: IconButton(
                  onPressed: () => controller.handlePressButton(context),
                  icon: Icon(Icons.access_alarm)),
            )),
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
            //container baixo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: const Color(0xFFEAF0F5),
                child: GestureDetector(
                  onTap: () {
                    Get.to(FindingDriver());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    width: MediaQuery.of(context).size.width * 9,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A2E35),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Text(
                      'Começar Corrida ',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pegarPosicao() async {
    Position posicao = controller.posi;

    List<Placemark> locais =
        await placemarkFromCoordinates(posicao.latitude, posicao.longitude);
    if (locais != null) {
      print(endereco = locais[0].toString());
      print(endereco = locais[0].toString());
      setState(() {
        endereco = locais[0].toString();
      });
      print('ddd ${locais[0].toString()}');
    }
  }
}
