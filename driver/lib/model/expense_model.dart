import 'dart:convert';

class ExpenseModel {
  final String dataHora;
  final String observacao;
  final String tipoDespesa;
  final String tipoCombustivel;
  final double valor;
  final double valorCombustivel;
  final double quantidade;

  ExpenseModel({
    required this.dataHora,
    required this.observacao,
    required this.tipoDespesa,
    required this.tipoCombustivel,
    required this.valor,
    required this.valorCombustivel,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'dataHora': dataHora,
      'observacao': observacao,
      'tipoDespesa': tipoDespesa,
      'tipoCombustivel': tipoCombustivel,
      'valor': valor,
      'valorCombustivel': valorCombustivel,
      'quantidade': quantidade,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      dataHora: map['dataHora'],
      observacao: map['observacao'],
      tipoDespesa: map['tipoDespesa'],
      tipoCombustivel: map['tipoCombustivel'],
      valor: map['valor'],
      valorCombustivel: map['valorCombustivel'],
      quantidade: map['quantidade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) => ExpenseModel.fromMap(json.decode(source));
}
