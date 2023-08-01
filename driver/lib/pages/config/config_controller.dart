import 'package:carcontrol/model/car_model.dart';
import 'package:carcontrol/pages/splash_screen/splash_screen_page.dart';
import 'package:carcontrol/shared/repositories/firebase_repository.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:flutter/cupertino.dart';
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

  RxBool isDefaultVehicle = true.obs;

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
    if (prefs.vehicleId == null) {
      return;
    }

    await listenVehicles(prefs.vehicleId!);
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

    final vehicle = CarModel(
      id: uid,
      driverId: prefs.firebaseID!,
      brand: brandEC.text,
      model: modelEC.text,
      plate: plateEC.text,
      color: colorEC.text,
      year: yearEC.text,
      main: isDefaultVehicle.value,
    );

    await firebaseRepository.addVehicle(vehicle);

    prefs.registerVehicleId(uid);

    vehicles.add(vehicle);

    Get.back();
  }

  Future<void> listenVehicles(String driverId) async {
    firebaseRepository.db.collection('veiculos').where('id', isEqualTo: driverId).snapshots().listen((event) {
      vehicles.clear();
      final List<CarModel> items = [];
      for (var element in event.docs) {
        items.add(CarModel.fromFirestore(element));
      }
      vehicles.addAll(items);
    });
  }

  Future<void> setLogout() async {
    final prefs = await SharedPrefsRepository.instance;
    prefs.logout();

    Get.offAll(() => const SplashSreenPage());
  }
}
