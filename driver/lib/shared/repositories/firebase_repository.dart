import 'dart:developer';

import 'package:carcontrol/core/db/db_firestore.dart';
import 'package:carcontrol/model/car_model.dart';
import 'package:carcontrol/model/race_matrix_entity.dart';
import 'package:carcontrol/model/race_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/constants.dart';

class FirebaseRepository {
  late FirebaseFirestore db;
  late Dio dbClient;

  FirebaseRepository() {
    db = DBFirestore.get();
    dbClient = Dio();
  }

  Future<void> saveRaceConcluded(String docId, RaceModel race) async {
    await db.collection('requisicoes').doc(docId).set(race.toMap());
  }

  Future<void> deleteCollectionPendingRaces(String id) async {
    await db.collection('requisicoes_ativas').doc(id).delete();
  }

  Future<void> acceptRace(String docId, RaceModel race) async {
    await db.collection('requisicoes').doc(docId).set(race.toMap());
  }

  Future<String> addRace(RaceModel race) async {
    final res = await db.collection('requisicoes').add(race.toMap());
    return res.id;
  }

  Future<void> addActiveRequests(String doc, String id) async {
    await db.collection('requisicoes_ativas').add({
      'id_requisicao': doc,
      'id_usuario': id,
      'status': 'aguardando',
    });
  }

  Future<RaceMatrixEntity> getDistanceMatrix(LatLng origin, LatLng dest) async {
    late RaceMatrixEntity item;
    try {
      final params = 'destinations=${dest.latitude},${dest.longitude}&origins=${origin.latitude},${origin.longitude}';
      final url = 'https://maps.googleapis.com/maps/api/distancematrix/json?$params&key=$googleDistanceAPIKey';
      var response = await dbClient.get(url);

      if (response.data == null) {
        item = RaceMatrixEntity(
          distance: '',
          duration: '',
          status: 'erro',
        );
        return item;
      }

      item = RaceMatrixEntity(
        distance: response.data['rows'][0]['elements'][0]['distance']['text'],
        duration: response.data['rows'][0]['elements'][0]['duration']['text'],
        status: response.data['rows'][0]['elements'][0]['status'],
      );
    } catch (e) {
      log(e.toString());
      item = RaceMatrixEntity(
        distance: '',
        duration: '',
        status: 'erro',
      );
    }

    return item;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRace(String document) async {
    return await db.collection('requisicoes').doc(document).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRaces() async {
    return await db.collection('requisicoes_ativas').get();
  }

  Future<List<RaceModel>> getRacesHistory() async {
    final races = await db
        .collection('requisicoes')
        .where('status', isEqualTo: 'concluido')
        .where('id_motorista', isEqualTo: '1')
        .get();

    final List<RaceModel> items = [];
    for (var element in races.docs) {
      items.add(RaceModel.fromFirestore(element));
    }
    return items;
  }

  Future<String> addVehicle(CarModel car) async {
    final res = await db.collection('veiculos').add(car.toMap());
    return res.id;
  }

  Future<List<CarModel>> getVehiclesById(String driverId) async {
    final vehicles = await db
        .collection('veiculos')
        .where('id', isEqualTo: driverId)
        .get();

    final List<CarModel> items = [];
    for (var element in vehicles.docs) {
      items.add(CarModel.fromFirestore(element));
    }
    return items;
  }

  Future<void> deleteVehicle(String id) async {
    final item = await db.collection('veiculos')
        .where('id', isEqualTo: id)
        .get();
    await db.collection('veiculos').doc(item.docs.first.id).delete();
  }
}
