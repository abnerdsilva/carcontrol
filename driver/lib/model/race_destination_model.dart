import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RaceDestinationModel {
  final String? neighborhood;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? number;
  final String? address;

  RaceDestinationModel({
    this.neighborhood,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.number,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'bairro': neighborhood,
      'cep': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'numero': number,
      'rua': address,
    };
  }

  factory RaceDestinationModel.fromMap(Map<String, dynamic> map) {
    return RaceDestinationModel(
      neighborhood: map['bairro'] ?? '',
      postalCode: map['cep'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      number: map['numero'] ?? '',
      address: map['rua'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RaceDestinationModel.fromJson(String source) => RaceDestinationModel.fromMap(json.decode(source));

  factory RaceDestinationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      {SnapshotOptions? options}) {
    final data = snapshot.data();
    return RaceDestinationModel(
      neighborhood: data?['destino']['bairro'],
      postalCode: data?['destino']['cep'],
      latitude: data?['destino']['latitude'],
      longitude: data?['destino']['longitude'],
      number: data?['destino']['numero'],
      address: data?['destino']['rua'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (neighborhood != null) "bairro": neighborhood,
      if (postalCode != null) "cep": postalCode,
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      if (number != null) "numero": number,
      if (address != null) "rua": address,
    };
  }
}
