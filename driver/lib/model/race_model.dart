import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RaceModel {
  final int id;
  final String? clientName;
  final String? addressDestination;
  final String? addressOrigem;
  final LatLng? destinationPosition;
  final LatLng? origemPosition;
  final double? value;
  final double? valueDriver;
  final double? distanceOrigem;
  final double? distanceDestination;
  final double? time;

  RaceModel({
    required this.id,
    this.clientName,
    this.destinationPosition,
    this.origemPosition,
    this.value,
    this.valueDriver,
    this.addressDestination,
    this.addressOrigem,
    this.distanceOrigem,
    this.distanceDestination,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': clientName,
    };
  }

  factory RaceModel.fromMap(Map<String, dynamic> map) {
    return RaceModel(
      id: map['id'] ?? 0,
      clientName: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RaceModel.fromJson(String source) => RaceModel.fromMap(json.decode(source));
}
