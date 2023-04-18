import 'dart:async';

import 'package:carcontrol/pages/dashboard/race_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs;

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  late StreamSubscription<Position> positionStream;
  LatLng _position = const LatLng(-23.092602, -47.213982);
  late GoogleMapController _mapsController;

  get mapsController => _mapsController;

  get position => _position;

  final markers = <Marker>{};

  final RxBool _statusStartRaces = false.obs;

  get stausStartRaces => _statusStartRaces;

  void setStatusStartRaces(bool value) => _statusStartRaces.value = value;

  final Rx<RaceModel> _race = RaceModel(id: 0, clientName: '').obs;

  get race => _race;

  void setRace(RaceModel value) => _race.value = value;

  final Rx<RaceModel> _raceAcceted = RaceModel(id: 0, clientName: '').obs;

  get raceAcceted => _raceAcceted;

  void setRaceAcceted(RaceModel value) {
    _raceAcceted.value = value;
    _race.value = RaceModel(id: 0, clientName: '');
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permission;
    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  watchPosition() async {
    positionStream = Geolocator.getPositionStream().listen((pos) {
      latitude.value = pos.latitude;
      longitude.value = pos.longitude;
    });
  }

  Future<void> getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;

      _position = LatLng(latitude.value, longitude.value);
      await _mapsController.animateCamera(
        CameraUpdate.newLatLng(_position),
      );
      update();
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.grey[100],
      );
    }
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosicao();
    await addMarker();
  }

  addMarker() async {
    markers.add(
      Marker(
        markerId: const MarkerId('Csa'),
        // position: const LatLng(-23.092602, -47.213982),
        position: _position,
        infoWindow: const InfoWindow(title: 'title nome'),
        // icon: await BitmapDescriptor.fromAssetImage(
        //   const ImageConfiguration(),
        //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPuUqQBRXvc3VAWSqTybUFQzY0UggnoTc7O-Bnk-W-tA&s',
        // ),
        onTap: () {},
        // onTap: () => showDetails(),
      ),
    );
    update();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }
}
