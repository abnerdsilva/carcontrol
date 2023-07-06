class Usuario {
  late String _idUsaurio;
  late String _nome;
  late String _email;
  late String _senha;
  late String _tipoUsuario;

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "tipoUsuario": this.tipoUsuario,
    };

    return map;
  }
}
