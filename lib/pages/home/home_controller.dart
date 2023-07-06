import 'dart:async';

import 'package:carcontrol/pages/dashboard/race_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class HomeController extends GetxController {
  var tabIndex = 0.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  late StreamSubscription<Position> positionStream;
  LatLng _position = const LatLng(-23.092602, -47.213982);
  late GoogleMapController _mapsController;

  get mapsController => _mapsController;

  get position => _position;
  late Position posi;

  final markers = <Marker>{

    const Marker(markerId: MarkerId(AutofillHints.name)),

  };

  void _exibirMarcador(BuildContext context, Position local) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: pixelRatio),
      "image/passageiro.png",
    ).then((BitmapDescriptor icone) {
      Marker marcadorPassageiro = Marker(
        markerId: MarkerId("marcador-passageiro"),
        position: LatLng(local.latitude, local.longitude),
        infoWindow: InfoWindow(
          title: "Meu Local",
        ),
        icon: icone,
      );

      markers.add(marcadorPassageiro);
      update();
    });
  }

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
      posi = posicao;

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
    //await addMarker(position, placeId, description);
  }

  addMarker(LatLng position, String placeId, String description) async {
    markers.add(
      Marker(
        markerId: MarkerId(placeId),
        // position: const LatLng(-23.092602, -47.213982),
        position: position,
        infoWindow: InfoWindow(title: description),
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

  Rx<Mode> mode = Mode.overlay.obs;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> handlePressButton(BuildContext context) async {
    try {
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: 'AIzaSyA6jjk9dudag94IoR8XaQUsbFQsGFhMTV0',
        onError: onError,
        mode: mode.value,
        language: "pt",
        types: List.of(['geocode']),
        strictbounds: false,
        decoration: InputDecoration(
          hintText: 'Buscar',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        components: [
          Component(Component.country, "br"),
        ],
      );

      if (p != null) {
        displayPrediction(p, homeScaffoldKey.currentState!);
      }
    } catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    print('error---------------------');
    SnackBar(content: Text(response.errorMessage!));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    print('pressed----------2');
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: 'AIzaSyA6jjk9dudag94IoR8XaQUsbFQsGFhMTV0',
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    print("${p.description} - $lat/$lng");


    await _mapsController.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
    update();
    await addMarker(_position, p.placeId!, p.description!);
  }
}
