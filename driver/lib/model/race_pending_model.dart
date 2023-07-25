import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RacePendingModel {
  final String? idRequisition;
  final String? idUser;
  final String? status;

  RacePendingModel({
    this.idRequisition,
    this.idUser,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_requisicao': idRequisition,
      'id_usuario': idUser,
      'status': status,
    };
  }

  factory RacePendingModel.fromMap(Map<String, dynamic> map) {
    return RacePendingModel(
      idRequisition: map['id_requisicao'] ?? '',
      idUser: map['id_usuario'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RacePendingModel.fromJson(String source) => RacePendingModel.fromMap(json.decode(source));

  factory RacePendingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, {SnapshotOptions? options}) {
    final data = snapshot.data();
    return RacePendingModel(
      idRequisition: data?['id_requisicao'],
      idUser: data?['id_usuario'],
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (idRequisition != null) "id_requisicao": idRequisition,
      if (idUser != null) "id_usuario": idUser,
      if (status != null) "status": status,
    };
  }
}
