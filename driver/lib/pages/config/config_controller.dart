import 'dart:developer';

import 'package:carcontrol/model/car_model.dart';
import 'package:carcontrol/pages/config/components/menu_item.dart';
import 'package:carcontrol/pages/splash_screen/splash_screen_page.dart';
import 'package:carcontrol/shared/repositories/firebase_repository.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ConfigController extends GetxController {
  late FirebaseRepository firebaseRepository;

  ConfigController(this.firebaseRepository);

  final TextEditingController brandEC = TextEditingController();
  final TextEditingController modelEC = TextEditingController();
  final TextEditingController plateEC = TextEditingController();
  final TextEditingController yearEC = TextEditingController();
  final TextEditingController colorEC = TextEditingController();
  final TextEditingController defaultEC = TextEditingController();

  late String userId;

  RxBool isDefaultVehicle = false.obs;

  RxList<CarModel> vehicles = <CarModel>[].obs;

  RxBool modoPesquisa = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    getVehicles();
    final prefs = await SharedPreferences.getInstance();
    final modo = prefs.getString('MODO_PESQUISA') ?? 'overlay';
    if (modo == 'overlay') {
      modoPesquisa.value = false;
    } else {
      modoPesquisa.value = true;
    }

    final prefsTemp = await SharedPrefsRepository.instance;
    userId = prefsTemp.firebaseID ?? '';
  }

  Future<void> start() async {
    await getVehicles();
  }

  Future<void> setModoPesquisa(bool value) async {
    modoPesquisa.value = value;

    String modo = 'overlay';
    if (value) {
      modo = 'fullscreen';
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('MODO_PESQUISA', modo);
  }

  Future<void> getVehicles() async {
    final prefs = await SharedPrefsRepository.instance;
    if (prefs.firebaseID == null) {
      return;
    }

    await listenVehicles(prefs.firebaseID!);
    // vehicles.clear();
    //
    // vehiclesTemp.sort((a, b) {
    //   return a.brand.compareTo(b.brand);
    // });
    //
    // vehicles.addAll(vehiclesTemp);
    update();
  }

  Future<void> createVehicle() async {
    if (brandEC.text.isEmpty ||
        modelEC.text.isEmpty ||
        plateEC.text.isEmpty ||
        colorEC.text.isEmpty ||
        yearEC.text.isEmpty) {
      Get.defaultDialog(
        title: 'Ops',
        middleText: 'Informe os dados do veículo e tente novamente.',
      );
      return;
    }

    if (vehicles.isEmpty) {
      isDefaultVehicle.value = true;
    }

    final prefs = await SharedPrefsRepository.instance;

    final uid = const Uuid().v1();

    CarModel vehicle = CarModel(
      id: uid,
      driverId: prefs.firebaseID!,
      brand: brandEC.text,
      model: modelEC.text,
      plate: plateEC.text,
      color: colorEC.text,
      year: yearEC.text,
      defaultCar: isDefaultVehicle.value,
      doc: '',
    );

    final doc = await firebaseRepository.addVehicle(vehicle);
    if (doc.isEmpty) {
      Get.snackbar(
        'Ops',
        'Não foi possível cadastrar veículo, tente novamente',
        backgroundColor: Colors.yellow,
      );
      return;
    }
    prefs.registerVehicleId(uid);

    vehicle = CarModel(
      id: uid,
      driverId: prefs.firebaseID!,
      brand: brandEC.text,
      model: modelEC.text,
      plate: plateEC.text,
      color: colorEC.text,
      year: yearEC.text,
      defaultCar: false,
      doc: doc,
    );
    await firebaseRepository.updateVehicle(doc, vehicle);

    // vehicles.add(vehicle);

    clearForm();
    Get.back();
  }

  void clearForm() {
    brandEC.text = '';
    modelEC.text = '';
    plateEC.text = '';
    colorEC.text = '';
    yearEC.text = '';
  }

  Future<void> listenVehicles(String driverId) async {
    firebaseRepository.db.collection('veiculos').where('id_motorista', isEqualTo: driverId).snapshots().listen((event) {
      vehicles.clear();
      final List<CarModel> items = [];
      for (var element in event.docs) {
        items.add(CarModel.fromFirestore(element, element.id));
      }
      vehicles.addAll(items);
    });
  }

  Future<void> deleteVehicle(CarModel car) async {
    if (vehicles.length == 1) {
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Não foi possivel remover veículo',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.add_alert),
          message: 'É necessário no mínimo um veículo cadastrado.',
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    await firebaseRepository.deleteVehicle(car.id);
    vehicles.remove(car);

    final prefs = await SharedPrefsRepository.instance;
    for (final car in vehicles) {
      if (car.defaultCar) {
        prefs.registerVehicleId(car.id);
      }
    }

    update();
  }

  Future<void> updateVehicleDefault(String driverId, String vehicleId) async {
    final prefs = await SharedPrefsRepository.instance;
    final List<CarModel> vehiclesTemp = [];

    for (var car in vehicles) {
      bool isDefaultVehicle = false;

      if (car.id == vehicleId) {
        isDefaultVehicle = true;
      }

      final vehicle = CarModel(
        id: car.id,
        driverId: car.driverId,
        brand: car.brand,
        model: car.model,
        plate: car.plate,
        color: car.color,
        year: car.year,
        defaultCar: isDefaultVehicle,
        doc: car.doc,
      );

      await firebaseRepository.updateVehicle(car.doc, vehicle);
      prefs.registerVehicleId(vehicle.id);

      vehiclesTemp.add(vehicle);
    }

    vehicles.clear();
    vehicles.addAll(vehiclesTemp);
    update();
  }

  Future<void> setLogout() async {
    final prefs = await SharedPrefsRepository.instance;
    prefs.logout();

    Get.offAll(() => const SplashSreenPage());
  }
}
