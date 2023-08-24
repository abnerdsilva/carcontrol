import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RacePriceModel {
  final String? priceDriver;
  final String? priceCustomer;
  final String? total;

  RacePriceModel({
    this.priceDriver,
    this.priceCustomer,
    this.total,
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
    return RacePriceModel(
      priceDriver: data!['valor_do_motorista'],
      priceCustomer: data['valor_do_passageiro'],
      total: data['valor_total_corrida'],
    );
  }
}
