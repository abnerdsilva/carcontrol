import 'dart:async';

import 'package:carcontrol/config/constants.dart';
import 'package:carcontrol/core/db/db_firestore.dart';
import 'package:carcontrol/model/expense_model.dart';
import 'package:carcontrol/model/race_customer_model.dart';
import 'package:carcontrol/model/race_destination_model.dart';
import 'package:carcontrol/model/race_model.dart';
import 'package:carcontrol/model/race_origin_model.dart';
import 'package:carcontrol/model/race_pending_model.dart';
import 'package:carcontrol/shared/repositories/firebase_repository.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  final FirebaseRepository firebaseRepository;

  HomeController(this.firebaseRepository);

  late FirebaseFirestore dbFirestore;

  var tabIndex = 0.obs;

  late final CollectionReference races;

  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  // late StreamSubscription<Position> positionStream;
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

  final Rx<RaceModel> _race = RaceModel(
    id: '0',
    status: '',
    origem: RaceOriginModel(),
    destino: RaceDestinationModel(),
    customer: RaceCustomerModel(),
    departureDate: '',
  ).obs;

  get race => _race;

  void setRace(RaceModel value) => _race.value = value;

  final Rx<RaceModel> _raceAcceted = RaceModel(
    id: '0',
    status: '',
    origem: RaceOriginModel(),
    destino: RaceDestinationModel(),
    customer: RaceCustomerModel(),
    departureDate: '',
  ).obs;

  Rx<RaceModel> get raceAcceted => _raceAcceted;

  void setNextRace(String value) => _nextRace.value = value;
  final RxString _nextRace = ''.obs;

  get nextRace => _nextRace.value;

  @override
  void onInit() {
    super.onInit();

    _handleLocationPermission();

    dbFirestore = DBFirestore.get();
  }

  Future<void> clearPoints() async {
    _raceAcceted.value = RaceModel(
      id: '0',
      status: '',
      origem: RaceOriginModel(),
      destino: RaceDestinationModel(),
      customer: RaceCustomerModel(),
      departureDate: '',
    );
    _race.value = RaceModel(
      id: '0',
      status: '',
      origem: RaceOriginModel(),
      destino: RaceDestinationModel(),
      customer: RaceCustomerModel(),
      departureDate: '',
    );
    polylineCoordinates.clear();
    polyline.clear();
    markers.clear();
    addMarker('current', _currentPosition, 'atual');
    update();
  }

  Future<void> concludeRace(RaceModel rm) async {
    final prefs = await SharedPrefsRepository.instance;
    final doc = prefs.docRacePending;
    final docActive = prefs.docActiveRequestRace;

    final raceModel = RaceModel(
      destino: rm.destino,
      origem: rm.origem,
      customer: rm.customer,
      status: 'concluido',
      departureDate: rm.departureDate,
      landingDate: DateTime.now().toLocal().toString(),
      distanceDestination: rm.distanceDestination,
      distanceOrigem: rm.distanceOrigem,
      driveId: rm.driveId,
      driverUserId: rm.driverUserId,
      id: rm.id,
      value: rm.value,
      valueDriver: rm.valueDriver,
    );

    await firebaseRepository.saveRaceConcluded(docActive!, raceModel);
    clearPoints();

    await firebaseRepository.deleteCollectionPendingRaces(doc!);

    prefs.registerDocActiveRequestRace('');
    prefs.registerDocRacePending('');

    final event = await firebaseRepository.getRaces();
    if (event.docs.isNotEmpty && _raceAcceted.value.id == '0') {
      final pendingRace = RacePendingModel.fromFirestore(event.docs.first);
      await getDetailsRace(pendingRace, event.docs.first.id);
    }
  }

  Future<void> setRaceAcceted(RaceModel value) async {
    final origin = LatLng(value.origem.latitude!, value.origem.longitude!);
    final destination = LatLng(value.destino.latitude!, value.destino.longitude!);

    await getPolyPoints(origin, destination);
    if (polyline.isNotEmpty) {
      addMarker('current', _currentPosition, 'Posição atual');
      addMarker('origin', origin, 'Origem corrida');
      addMarker('dest', destination, 'Destino corrida');

      _raceAcceted.value = value;
      _race.value = RaceModel(
        id: '0',
        status: '',
        origem: RaceOriginModel(),
        destino: RaceDestinationModel(),
        customer: RaceCustomerModel(),
        departureDate: '',
      );
      update();

      final prefs = await SharedPrefsRepository.instance;

      final raceModel = RaceModel(
        destino: value.destino,
        origem: value.origem,
        customer: value.customer,
        status: 'andamento',
        departureDate: value.departureDate,
        distanceDestination: value.distanceDestination,
        distanceOrigem: value.distanceOrigem,
        driveId: '1',
        driverUserId: prefs.firebaseID,
        id: value.id,
        value: value.value,
        valueDriver: value.valueDriver,
      );

      await firebaseRepository.deleteCollectionPendingRaces(prefs.docRacePending!);
      await firebaseRepository.acceptRace(prefs.docActiveRequestRace!, raceModel);
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
    dbFirestore.collection('requisicoes_ativas').snapshots().listen((event) async {
      if (event.docs.isNotEmpty && _raceAcceted.value.id == '0') {
        final pendingRace = RacePendingModel.fromFirestore(event.docs.first);
        await getDetailsRace(pendingRace, event.docs.first.id);
      }
    });
  }

  Future<void> getDetailsRace(RacePendingModel pendingRace, String docRequest) async {
    final detailsPendingRace = await firebaseRepository.getRace(pendingRace.idRequisition!);
    final corridaTemp = RaceModel.fromFirestore(detailsPendingRace);

    final distOrigin = LatLng(corridaTemp.origem.latitude!, corridaTemp.origem.longitude!);
    final distDestiny = LatLng(corridaTemp.destino.latitude!, corridaTemp.destino.longitude!);

    final resDistanceOrigin = await firebaseRepository.getDistanceMatrix(_currentPosition, distOrigin);
    final resDistanceDestiny = await firebaseRepository.getDistanceMatrix(_currentPosition, distDestiny);

    final corrida = RaceModel(
      destino: corridaTemp.destino,
      origem: corridaTemp.origem,
      customer: corridaTemp.customer,
      status: corridaTemp.status,
      departureDate: corridaTemp.departureDate,
      id: corridaTemp.id,
      distanceDestination: resDistanceDestiny.distance,
      valueDriver: corridaTemp.valueDriver,
      value: corridaTemp.value,
      landingDate: corridaTemp.landingDate,
      distanceOrigem: resDistanceOrigin.distance,
      driveId: corridaTemp.driverUserId,
      driverUserId: corridaTemp.driverUserId,
    );

    setRace(corrida);

    final prefs = await SharedPrefsRepository.instance;
    prefs.registerDocRacePending(docRequest);
    prefs.registerDocActiveRequestRace(detailsPendingRace.id);
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

  Future<void> saveExpense(ExpenseModel expense) async {
    dbFirestore.collection('despesas').add({
      'data_hora': expense.dataHora,
      'valor': expense.valor,
      'observacao': expense.observacao,
      'tipo': expense.tipoDespesa,
      'valor_combustivel': expense.valorCombustivel,
      'quantidade_litros_abastecimento': expense.quantidade,
      'tipo_combustivel': expense.tipoCombustivel,
    }).then((value) {
      Get.snackbar(
        'Sucesso',
        'Lançamento realizado com sucesso',
        backgroundColor: Colors.green[100],
      );

      Get.back();
    }).onError((error, stackTrace) {
      Get.snackbar(
        'Erro',
        'Não foi possivel lançar evento',
        backgroundColor: Colors.red[100],
      );
    });
  }

  // Future<void> createRace() async {
  //   const idusuario = '38Rke9auqOWJG3NNmXrJc8hRXyI3';
  //   final idReq = Random().nextInt(100);
  //
  //   final raceModel = RaceModel(
  //     destino: RaceDestinationModel(
  //       neighborhood: 'Jardom Progresso',
  //       postalCode: '13190-000',
  //       latitude: -22.9639666,
  //       longitude: -47.3158404,
  //       number: '50',
  //       address: 'Rua Jamil Antônio Ticiane',
  //     ),
  //     origem: RaceOriginModel(
  //       address: 'Rua xpto',
  //       number: '15',
  //       latitude: -23.0882,
  //       longitude: -47.2234,
  //       postalCode: '1345-760',
  //       neighborhood: 'Bairro Qlqr',
  //     ),
  //     customer: RaceCustomerModel(
  //       id: idusuario,
  //       email: 'silvabner@gmail.com',
  //       name: 'Abner Teste Silva - $idReq',
  //       type: 'Passageiro',
  //     ),
  //     status: 'aguardando',
  //     departureDate: DateTime.now().toLocal().toString(),
  //     // landingDate: DateTime.now().toLocal().toString(),
  //     // distanceDestination: 15.7,
  //     distanceOrigem: '1.8',
  //     driveId: '1',
  //     driverUserId: '1',
  //     id: idReq.toString(),
  //     value: 15.8,
  //     valueDriver: 15.8 * .7,
  //   );
  //
  //   final doc = await firebaseRepository.addRace(raceModel);
  //   await firebaseRepository.addActiveRequests(doc, idusuario);
  // }

  @override
  void onClose() {
    // positionStream.cancel();
    super.onClose();
  }
}
