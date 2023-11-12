import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceModel {
  final String driverId;
  final String dataHora;
  final String nome;
  final String observacao;
  final String tipoFinanceiro;
  final String tipoDespesa;
  final String tipoCombustivel;
  final double valor;
  final double valorCombustivel;
  final double quantidade;
  final int kilometragem;
  final String? raceId;

  FinanceModel({
    required this.driverId,
    required this.dataHora,
    required this.observacao,
    required this.nome,
    required this.tipoFinanceiro,
    required this.tipoDespesa,
    required this.tipoCombustivel,
    required this.valor,
    required this.valorCombustivel,
    required this.quantidade,
    required this.kilometragem,
    this.raceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_motorista': driverId,
      'dataHora': dataHora,
      'nome': nome,
      'observacao': observacao,
      'tipoDespesa': tipoDespesa,
      'tipoCombustivel': tipoCombustivel,
      'valor': valor,
      'valorCombustivel': valorCombustivel,
      'quantidade': quantidade,
      'kilometragem': kilometragem,
      'tipoFinanceiro': tipoFinanceiro,
      'id_corrida': raceId,
    };
  }

  factory FinanceModel.fromMap(Map<String, dynamic> map) {
    return FinanceModel(
      driverId: map['id_motorista'],
      dataHora: map['dataHora'],
      observacao: map['observacao'],
      nome: map['nome'],
      tipoDespesa: map['tipoDespesa'],
      tipoCombustivel: map['tipoCombustivel'],
      valor: map['valor'],
      valorCombustivel: map['valorCombustivel'],
      quantidade: map['quantidade'],
      kilometragem: map['kilometragem'],
      tipoFinanceiro: map['tipoFinanceiro'],
      raceId: map['id_corrida'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FinanceModel.fromJson(String source) => FinanceModel.fromMap(json.decode(source));

  factory FinanceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, {SnapshotOptions? options}) {
    final data = snapshot.data();
    return FinanceModel(
      driverId: data!['id_motorista'],
      dataHora: data['dataHora'],
      observacao: data['observacao'],
      nome: data['nome'],
      tipoDespesa: data['tipoDespesa'],
      tipoCombustivel: data['tipoCombustivel'],
      valor: data['valor'],
      valorCombustivel: data['valorCombustivel'],
      quantidade: data['quantidade'],
      kilometragem: data['kilometragem'],
      tipoFinanceiro: data['tipoFinanceiro'],
      raceId: data['id_corrida'],
    );
  }
}
