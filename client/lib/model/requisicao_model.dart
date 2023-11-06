import 'package:cloud_firestore/cloud_firestore.dart';

import 'usuario_model.dart';
import 'custos_da_viagem_model.dart';
import 'destino_model.dart';
import 'origem_model.dart';

class Requisicao {
  late String _id;
  late String _status;
  late Usuario _passageiro;
  late Usuario _motorista;
  late Destino _destino;
  late Origem _origem;
  late Custos custos;

  Requisicao() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference ref = db.collection("requisicoes").doc();
    this.id = ref.id;
  }

  Usuario get passageiro => _passageiro;

  Destino get destino => _destino;

  Origem get origem => _origem;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  set passageiro(Usuario value) {
    _passageiro = value;
  }

  set motorista(Usuario value) {
    _motorista = value;
  }

  set destino(Destino value) {
    _destino = value;
  }

  set origem(Origem value) {
    _origem = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dadosPassageiro = {
      "nome": this.passageiro.nome,
      "email": this.passageiro.email,
      "tipoUsuario": this.passageiro.tipoUsuario,
      "idUsuario": this.passageiro.id,
    };

    Map<String, dynamic> origem_Passageiro = {
      "rua": this.origem.rua,
      "numero": this.origem.numero,
      "bairro": this.origem.bairro,
      "cep": this.origem.cep,
      "cidade": this.origem.cidade,
      "latitude": this.origem.latitude,
      "longitude": this.origem.longitude,
    };

    Map<String, dynamic> destino_Passageiro = {
      "rua": this.destino.rua,
      "numero": this.destino.numero,
      "bairro": this.destino.bairro,
      "cep": this.destino.cep,
      "latitude": this.destino.latitude,
      "longitude": this.destino.longitude,
    };

    Map<String, dynamic> custos_Corrida = {
      "valor-do-motorista": this.custos.valor_do_motorista,
      "valor-do-passageiro": this.custos.valor_do_passageiro,
      "valor-total-da-corrida": this.custos.valor_total_corrida,
    };

    Map<String, dynamic> dadosRequisicao = {
      "id": this.id,
      "status": this.status,
      "origemPassageiro": origem_Passageiro,
      "destinoPassageiro": destino_Passageiro,
      "passageiro": dadosPassageiro,
      "custosCorrida": custos_Corrida,
    };

    return dadosRequisicao;
  }
}
