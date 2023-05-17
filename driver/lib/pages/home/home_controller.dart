import 'dart:async';

import 'package:carcontrol/config/constants.dart';
import 'package:carcontrol/core/db/db_firestore.dart';
import 'package:carcontrol/model/race_model.dart';
import 'package:carcontrol/pages/home/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final HomeRepository homeRepository;

  HomeController(this.homeRepository);

  var tabIndex = 0.obs;

  late final CollectionReference races;

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  late StreamSubscription<Position> positionStream;
  LatLng _currentPosition = const LatLng(-23.092602, -47.213902);
  late GoogleMapController _mapsController;

  get mapsController => _mapsController;

  List<LatLng> polylineCoordinates = [];
  final Set<Polyline> polyline = {};

  get position => _currentPosition;

  void setPosition(LatLng pos) => _currentPosition = pos;

  final markers = <Marker>{}.obs;

  final RxBool _statusStartRaces = false.obs;

  get stausStartRaces => _statusStartRaces;

  void setStatusStartRaces(bool value) => _statusStartRaces.value = value;

  final Rx<RaceModel> _race = RaceModel(id: 0).obs;

  get race => _race;

  void setRace(RaceModel value) => _race.value = value;

  final Rx<RaceModel> _raceAcceted = RaceModel(id: 0).obs;

  Rx<RaceModel> get raceAcceted => _raceAcceted;

  @override
  void onInit() {
    super.onInit();

    _handleLocationPermission();
  }

  Future<void> clearPoints() async {
    _raceAcceted.value = RaceModel(id: 0);
    _race.value = RaceModel(id: 0);
    polylineCoordinates.clear();
    polyline.clear();
    markers.clear();
    addMarker('current', _currentPosition, 'atual');
    update();
  }

  Future<void> concludeRace() async {
    final prefs = await SharedPreferences.getInstance();
    final doc = prefs.getString('DOC_RACE');

    await homeRepository.saveRaceConcluded(doc!, _raceAcceted.value);
    await homeRepository.deleteCollectionPendingRaces(doc);

    clearPoints();
  }

  Future<void> setRaceAcceted(RaceModel value) async {
    await getPolyPoints(value.origemPosition!, value.destinationPosition!);
    if (polyline.isNotEmpty) {
      addMarker('dest', value.origemPosition!, 'title');
      addMarker('dest', value.destinationPosition!, 'title');

      _raceAcceted.value = value;
      _race.value = RaceModel(id: 0, clientName: 'destino');
      update();
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Permition denied',
        'Location services are disabled. Please enable the services',
        colorText: Colors.white,
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.add_alert),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (LocationPermission.deniedForever == permission || LocationPermission.denied == permission) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permition denied',
          'Location permissions are denied',
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permition denied',
          'Location permissions are permanently denied, we cannot request permissions.',
          colorText: Colors.white,
          backgroundColor: Colors.red[300],
          icon: const Icon(Icons.add_alert),
        );
        return false;
      }
    }
    return true;
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  void getFirstPendingRaces() {
    DBFirestore.get().collection('pending-races').snapshots().listen((event) async {
      if (event.docs.isNotEmpty && _raceAcceted.value.id == 0) {
        final doc = event.docs.first;

        final corrida = RaceModel(
          id: doc['id'],
          clientName: doc['name'],
          destinationPosition: LatLng(doc['dest-position']['latitude'], doc['dest-position']['longitude'] as double),
          origemPosition:
              LatLng(doc['orig-position']['latitude'] as double, doc['orig-position']['longitude'] as double),
          addressDestination: doc['address-destination'],
          addressOrigem: doc['address-origem'],
          distanceOrigem: doc['distance-origem'] as double,
          distanceDestination: doc['distance-destination'] as double,
          value: doc['totalValue'] as double,
          valueDriver: doc['driverValue'] as double,
        );

        setRace(corrida);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('DOC_RACE', doc.id);
      }
    });
  }

  Future<void> getPosicao() async {
    try {
      if (!await _handleLocationPermission()) {
        return;
      }
      final posicao = await _getCurrentLocation();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;

      _currentPosition = LatLng(latitude.value, longitude.value);
      await _mapsController.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );

      addMarker('currentPosition', _currentPosition, 'Local atual');
      update();
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.grey[100],
      );
    }
  }

  Future<void> onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosicao();
  }

  void addMarker(String id, LatLng pos, String title) async {
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: pos,
        infoWindow: InfoWindow(title: title),
        onTap: () {},
      ),
    );
    update();
  }

  Future<void> getPolyPoints(LatLng posInit, LatLng posEnd) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_currentPosition.latitude, _currentPosition.longitude),
      PointLatLng(posEnd.latitude, posEnd.longitude),
      travelMode: TravelMode.driving,
      wayPoints: [
        PolylineWayPoint(location: '${posInit.latitude}, ${posInit.longitude}'),
      ],
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Rota não encontrada',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.add_alert),
          message: 'Não foi possivel identificar uma rota para o endereço informado',
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    polyline.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylineCoordinates,
        width: 3,
        color: Colors.blueGrey,
      ),
    );

    update();
  }

  void changeTabIndex(int index) {
    // if (index != 1) {
    tabIndex.value = index;
    // }
  }

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }
}
