import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RacePriceModel {
  final String priceDriver;
  final String priceCustomer;
  final String total;

  RacePriceModel({
    required this.priceDriver,
    required this.priceCustomer,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor_do_motorista': priceDriver,
      'valor_do_passageiro': priceCustomer,
      'valor_total_corrida': total,
    };
  }

  factory RacePriceModel.fromMap(Map<String, dynamic> map) {
    return RacePriceModel(
      priceDriver: map['valor_do_motorista'],
      priceCustomer: map['valor_do_passageiro'],
      total: map['valor_total_corrida'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RacePriceModel.fromJson(String source) => RacePriceModel.fromMap(json.decode(source));

  factory RacePriceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, {SnapshotOptions? options}) {
    final data = snapshot.data();
    if (data == null) {
      return RacePriceModel(
        priceDriver: '',
        priceCustomer: '',
        total: '',
      );
    }
    return RacePriceModel(
      priceDriver: data['valoresDaCorrida']['valor_do_motorista'],
      priceCustomer: data['valoresDaCorrida']['valor_do_passageiro'],
      total: data['valoresDaCorrida']['valor_total_corrida'],
    );
  }
}
