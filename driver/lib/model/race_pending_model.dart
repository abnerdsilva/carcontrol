import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RacePendingModel {
  final String? idRequisition;
  final String? idUser;
  final String? driverId;
  final String? status;

  RacePendingModel({
    this.idRequisition,
    this.idUser,
    this.driverId,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_requisicao': idRequisition,
      'id_usuario': idUser,
      'id_motorista': driverId,
      'status': status,
    };
  }

  factory RacePendingModel.fromMap(Map<String, dynamic> map) {
    return RacePendingModel(
      idRequisition: map['id_requisicao'] ?? '',
      idUser: map['id_usuario'] ?? '',
      driverId: map['id_motorista'] ?? '',
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
      driverId: data?['id_motorista'],
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (idRequisition != null) "id_requisicao": idRequisition,
      if (idUser != null) "id_usuario": idUser,
      if (driverId != null) "id_motorista": driverId,
      if (status != null) "status": status,
    };
  }
}
