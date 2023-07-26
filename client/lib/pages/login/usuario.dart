class Usuario {
  late String _id;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  late String _nome;
  late String _email;
  late String _senha;
  late String _telefone;
  late String _cpf;
  late String _tipoUsuario;

  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dadosPessoais = {
      "id": this.id,
      "nome": this.nome,
      "email": this.email,
      "telefone": this.telefone,
      "cpf": this.cpf,
      "tipoUsuario": this.tipoUsuario,
    };
    return dadosPessoais;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  Usuario();

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }
}
