import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  final String id;
  final String driverId;
  final String brand;
  final String model;
  final String plate;
  final String color;
  final String year;
  final bool? main;

  CarModel({
    required this.id,
    required this.driverId,
    required this.brand,
    required this.model,
    required this.plate,
    required this.color,
    required this.year,
    this.main,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_motorista': driverId,
      'marca': brand,
      'modelo': model,
      'placa': plate,
      'cor': color,
      'ano': year,
      'padrao': main ?? false,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'],
      driverId: map['id_motorista'],
      brand: map['marca'],
      model: map['modelo'],
      plate: map['placa'],
      color: map['cor'],
      year: map['ano'],
      main: map['padrao'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModel.fromJson(String source) => CarModel.fromMap(json.decode(source));

  factory CarModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, {SnapshotOptions? options}) {
    final data = snapshot.data();
    return CarModel(
      id: data!['id'],
      driverId: data['id_motorista'],
      brand: data['marca'],
      model: data['modelo'],
      plate: data['placa'],
      color: data['cor'],
      year: data['ano'],
      main: data['padrao'] ?? false,
    );
  }
}
