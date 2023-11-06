import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../races/choose_driver.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _obterEnderecoAtual();
  }

  Future<void> _obterEnderecoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Obtenha as coordenadas atuais
    LatLng latlon = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = latlon;
    });

    _setMarker(latlon);
  }

  Future<void> _setMarker(LatLng latlon) async {
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/passageiro.png',
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: latlon,
          icon: customIcon,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Para onde vamos hoje ?"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(ChooseDriver());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _currentLocation == null
                  ? Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation!,
                        zoom: 13,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      myLocationEnabled: true,
                      markers: _markers,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
