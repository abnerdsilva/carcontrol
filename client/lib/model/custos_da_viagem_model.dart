class Custos {
  late double valor_do_motorista;
  late double valor_do_passageiro;
  late double valor_total_corrida;

  double gerarValorDaCorrida() {
    DateTime now = DateTime.now();
    int horaAtual = now.hour;

    String periodoDoDia;

    if (horaAtual >= 6 && horaAtual < 12) {
      periodoDoDia = "manha";
    } else if (horaAtual >= 12 && horaAtual < 18) {
      periodoDoDia = "tarde";
    } else {
      periodoDoDia = "noite";
    }

    double valorBase;

    switch (periodoDoDia) {
      case "manha":
        valorBase = 3.0;
        break;
      case "tarde":
        valorBase = 4.0;
        break;
      case "noite":
        valorBase = 5.0;
        break;
      default:
        valorBase = 2.0;
        break;
    }

    double valorCorrida = valorBase + valor_do_motorista + valor_do_passageiro;

    return valorCorrida;
  }
}
