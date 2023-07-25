import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RaceOriginModel {
  final String? neighborhood;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final String? number;
  final String? address;

  RaceOriginModel({
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

  factory RaceOriginModel.fromMap(Map<String, dynamic> map) {
    return RaceOriginModel(
      neighborhood: map['bairro'] ?? '',
      postalCode: map['cep'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      number: map['numero'] ?? '',
      address: map['rua'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RaceOriginModel.fromJson(String source) => RaceOriginModel.fromMap(json.decode(source));

  factory RaceOriginModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      {SnapshotOptions? options}) {
    final data = snapshot.data();
    return RaceOriginModel(
      neighborhood: data?['origem']['bairro'] ?? '',
      postalCode: data?['origem']['cep'] ?? '',
      latitude: data?['origem']['latitude'] ?? '',
      longitude: data?['origem']['longitude'] ?? '',
      number: data?['origem']['numero'] ?? '',
      address: data?['origem']['rua'] ?? '',
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
