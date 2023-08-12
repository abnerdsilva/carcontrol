import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String driverId;
  final String dataHora;
  final String nome;
  final String observacao;
  final String tipoDespesa;
  final String tipoCombustivel;
  final double valor;
  final double valorCombustivel;
  final double quantidade;
  final int kilometragem;

  ExpenseModel({
    required this.driverId,
    required this.dataHora,
    required this.observacao,
    required this.nome,
    required this.tipoDespesa,
    required this.tipoCombustivel,
    required this.valor,
    required this.valorCombustivel,
    required this.quantidade,
    required this.kilometragem,
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
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
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
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) => ExpenseModel.fromMap(json.decode(source));

  factory ExpenseModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, {SnapshotOptions? options}) {
    final data = snapshot.data();
    return ExpenseModel(
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
    );
  }
}
