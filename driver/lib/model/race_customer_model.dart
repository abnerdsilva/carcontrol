import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RaceCustomerModel {
  final String? email;
  final String? id;
  final String? type;
  final String? name;

  RaceCustomerModel({
    this.email,
    this.id,
    this.name,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'idUsuario': id,
      'nome': name,
      'tipoUsuario': type,
    };
  }

  factory RaceCustomerModel.fromMap(Map<String, dynamic> map) {
    return RaceCustomerModel(
      email: map['email'] ?? '',
      name: map['nome'] ?? '',
      id: map['idUsuario'] ?? '',
      type: map['tipoUsuario'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RaceCustomerModel.fromJson(String source) => RaceCustomerModel.fromMap(json.decode(source));

  factory RaceCustomerModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, {SnapshotOptions? options}) {
    final data = snapshot.data();
    return RaceCustomerModel(
      email: data?['passageiro']['email'] ?? '',
      name: data?['passageiro']['nome'],
      id: data?['passageiro']['idUsuario'],
      type: data?['passageiro']['tipoUsuario'],
    );
  }
}
