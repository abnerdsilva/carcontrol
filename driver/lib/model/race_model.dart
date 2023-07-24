import 'dart:convert';

import 'package:carcontrol/model/race_customer_model.dart';
import 'package:carcontrol/model/race_destination_model.dart';
import 'package:carcontrol/model/race_origin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RaceModel {
  final String? id;
  final double? value;
  final double? valueDriver;
  final String? distanceOrigem;
  final String? distanceDestination;
  final RaceDestinationModel destino;
  final RaceOriginModel origem;
  final RaceCustomerModel customer;
  final String status;
  final String? driverUserId;
  final String? driveId;
  final String departureDate;
  final String? landingDate;

  RaceModel({
    this.id,
    this.value,
    this.valueDriver,
    this.distanceOrigem,
    this.distanceDestination,
    required this.destino,
    required this.origem,
    required this.customer,
    required this.status,
    this.driverUserId,
    this.driveId,
    required this.departureDate,
    this.landingDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destino': destino.toMap(),
      'origem': origem.toMap(),
      'passageiro': customer.toMap(),
      'status': status,
      'vr_corrida': value,
      'comissao': valueDriver,
      'distancia_origem': distanceOrigem,
      'distancia_destino': distanceDestination,
      'id_motorista': driverUserId,
      'id_carro': driveId,
      'data_embarque': departureDate,
      'data_desembarque': landingDate,
    };
  }

  factory RaceModel.fromMap(Map<String, dynamic> map) {
    return RaceModel(
      id: map['id'] ?? 0,
      destino: RaceDestinationModel.fromMap(map),
      origem: RaceOriginModel.fromMap(map),
      customer: RaceCustomerModel.fromMap(map),
      status: map['status'] ?? '',
      value: map['total'] ?? 0.0,
      valueDriver: map['taxa'] ?? 0.0,
      distanceOrigem: map['distancia_origem'],
      distanceDestination: map['distancia_destino'],
      departureDate: map['data_embarque'] ?? '',
      landingDate: map['data_desembarque'],
      driverUserId: map['id_motorista'],
      driveId: map['id_carro'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RaceModel.fromJson(String source) => RaceModel.fromMap(json.decode(source));

  factory RaceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, {SnapshotOptions? options}) {
    final data = snapshot.data();
    return RaceModel(
      id: data!['id'],
      destino: RaceDestinationModel.fromFirestore(snapshot),
      origem: RaceOriginModel.fromFirestore(snapshot),
      customer: RaceCustomerModel.fromFirestore(snapshot),
      status: data['status'],
      value: data['vr_corrida'],
      valueDriver: data['comissao'],
      departureDate: data['data_embarque'] ?? '',
      landingDate: data['data_desembarque'],
      driverUserId: data['id_motorista'],
      driveId: data['id_carro'],
      distanceDestination: data['distancia_destino'],
      distanceOrigem: data['distancia_origem'].toString(),
    );
  }
}
