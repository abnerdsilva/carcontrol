class Driver {
  late String _id;
  late String _nome;
  late String _cpf;
  late String _dataNascimento;
  late String _cidade;
  late String _bairro;
  late String _rua;
  late String _numero;
  late String _telefone;
  late String _cnh;
  late String _email;
  late String _senha;
  late String _cep;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dadosMotorista = {
      "id": id,
      "nome": nome,
      "cpf": cpf,
      "dataNascimento": dataNascimento,
      "telefone": telefone,
      "email": email,
      "cnh": cnh,
    };

    Map<String, dynamic> dadosEndereco = {
      "cidade": cidade,
      "bairro": bairro,
      "rua": rua,
      "numero": numero,
      "cep": cep,
    };

    return {
      "motorista": dadosMotorista,
      "endereco": dadosEndereco,
    };
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get dataNascimento => _dataNascimento;

  set dataNascimento(String value) {
    _dataNascimento = value;
  }

  String get bairro => _bairro;

  set bairro(String value) {
    _bairro = value;
  }

  String get rua => _rua;

  set rua(String value) {
    _rua = value;
  }

  String get numero => _numero;

  set numero(String value) {
    _numero = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get cnh => _cnh;

  set cnh(String value) {
    _cnh = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }
}
