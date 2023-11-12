import 'package:carcontrol/model/destino_model.dart';
import 'package:carcontrol/model/requisicao_model.dart';
import 'package:carcontrol/model/usuario_model.dart';
import 'package:carcontrol/util/status_requisicao.dart';
import 'package:carcontrol/util/usuario_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/custos_da_viagem_model.dart';
import '../../model/origem_model.dart';
import '../home/home_controller.dart';
import 'corrida.dart';

class ChooseDriver extends StatefulWidget {
  @override
  State<ChooseDriver> createState() => _ChooseDriverState();
}

class _ChooseDriverState extends State<ChooseDriver> {
  bool _exibirCaixaEnderecoDestino = true;
  String _textoBotao = " ";
  Color _corBotao = Color(0x34262323);
  late Function _funcaoBotao;
  bool _exibirTelaBuscandoMotorista = true;

  TextEditingController _controllerDestino = TextEditingController();

  TextEditingController _controllerOrigem =
      TextEditingController(text: "Meu Local");

  HomeController controller = Get.find<HomeController>();

  Set<Marker> _markers = {};

  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _adicionarListenerRequisicaoAtiva();
    _obterEnderecoAtual();
  }

  Future<void> _obterEnderecoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng latlon = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = latlon;
    });

    _setMarker(latlon);
  }

  Future<void> _setMarker(LatLng latlon) async {
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/passageiro.png',
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: latlon,
          icon: customIcon,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Corridas"),
      ),
      body: Stack(children: [
        GetBuilder<HomeController>(
          init: controller,
          builder: (value) => GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _currentLocation!,
              zoom: 13,
            ),
            onMapCreated: controller.onMapCreated,
            myLocationButtonEnabled: false,
            markers: _markers,
          ),
        ),
        Visibility(
          visible: _exibirCaixaEnderecoDestino,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          icon: Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 10,
                              height: 20,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.green,
                              )),
                          hintText: _controllerOrigem.text,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 14, top: 6)),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 55,
                left: 0,
                right: 0,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white),
                      child: TextField(
                        controller: _controllerDestino,
                        decoration: InputDecoration(
                            icon: Container(
                                margin: EdgeInsets.only(left: 20),
                                width: 10,
                                height: 20,
                                child: Icon(
                                  Icons.local_taxi,
                                  color: Colors.black,
                                )),
                            hintText: "Para onde vamos hoje ?",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 14, top: 6)),
                      ),
                    ),
                  ),
                  onTap: () {
                    controller.handlePressButton(context);
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
            right: 50,
            left: 0,
            bottom: 20,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(_corBotao),
                  ),
                  child: Text(
                    _textoBotao,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    _funcaoBotao();
                  }),
            ))
      ]),
    );
  }

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _statusMotoristaNaoChamado() {
    _exibirCaixaEnderecoDestino = true;

    _alterarBotaoPrincipal("Confirmar Endereço", Color(0xff192d34), () {
      _chamarMotorista();
    });
  }

  void _statusAguardando() {
    _exibirCaixaEnderecoDestino = false;

    _alterarBotaoPrincipal(
      "",
      Color.fromRGBO(0, 0, 0, 0.4),
      () {},
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Buscando Motorista", textAlign: TextAlign.center),
          contentPadding: EdgeInsets.all(10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage("assets/images/carro-animado.gif")),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _cancelarMotorista();
                  setState(() {
                    _exibirTelaBuscandoMotorista = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Visibility(
                  visible: _exibirTelaBuscandoMotorista,
                  child: Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        "Cancelar Corrida",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _cancelarMotorista() async {
    User? firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("requisicoes_ativas").doc(firebaseUser?.uid).delete();
  }

  _chamarMotorista() async {
    String enderecoDestino = _controllerDestino.text;

    try {
      if (enderecoDestino.isNotEmpty) {
        //endereço Destino Passageiro
        List<Location> listaEnderecos =
            await locationFromAddress(enderecoDestino);

        Location informacoesDestino = listaEnderecos[0];

        List<Placemark> novo = await placemarkFromCoordinates(
            informacoesDestino.latitude, informacoesDestino.longitude);

        Placemark destinoPassageiro = novo[0];

        if (destinoPassageiro != null) {
          Destino destino = Destino();
          destino.cidade = destinoPassageiro.administrativeArea!;
          destino.cep = destinoPassageiro.postalCode!;
          destino.bairro = destinoPassageiro.subLocality!;
          destino.rua = destinoPassageiro.thoroughfare!;
          destino.numero = destinoPassageiro.subThoroughfare!;
          destino.latitude = informacoesDestino.latitude;
          destino.longitude = informacoesDestino.longitude;
          destino.horario = informacoesDestino.timestamp;

          // Obtenha a localização atual - Origem do passageiro
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          // Obtenha os detalhes do endereço atual
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          Placemark origemPlacemark = placemarks.first;

          if (origemPlacemark != null) {
            Origem origem = Origem();
            origem.rua = origemPlacemark.thoroughfare!;
            origem.numero = origemPlacemark.subThoroughfare!;
            origem.bairro = origemPlacemark.subLocality!;
            origem.cidade = origemPlacemark.administrativeArea!;
            origem.cep = origemPlacemark.postalCode!;
            origem.latitude = position.latitude;
            origem.longitude = position.longitude;

            //Custos da Corrida
            Custos custos = Custos();

            double valorDaCorrida = await gerarValorDaCorrida(
                origem.latitude,
                origem.longitude,
                informacoesDestino.latitude,
                informacoesDestino.longitude);

            custos.valor_total_corrida = valorDaCorrida;
            custos.valor_do_motorista = valorDaCorrida * 0.8;
            custos.valor_do_passageiro = valorDaCorrida * 0.2;

            String enderecoConfirmacao =
                "\n Cidade: ${destino.cidade}\n\n Rua: ${destino.rua}, ${destino.numero}"
                "\n\n Bairro: ${destino.bairro}\n\n CEP: ${destino.cep}";

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Confirmação de Endereço'),
                  content: Text(enderecoConfirmacao),
                  contentPadding: EdgeInsets.all(16),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        "Confirmar",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        _salvarRequisicao(destino, origem, custos);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            print(
                "Endereço de Origem do do Passageiro é nulo! Verificar Conversão do Endereço. ");

            _showAlertDialog(
                "Ops!", "Algo deu errado, verifique seu endereço !");
          }
        } else {
          print(
              "Endereço de Destino do Passageiro é nulo! Verificar Conversão do Endereço. ");

          _showAlertDialog("Ops!", "Algo deu errado, verifique seu endereço !");
        }
      } else {
        print("Campo de Destino da Corrida é nulo! ");
        _showAlertDialog("Ops!", "Endereço de Destino Vazio.");
      }
    } catch (e) {
      _showAlertDialog("Ops!",
          "Verifique seu Endereço de Destino. \n\nUse como base Rua,número,Cidade.");
    }
  }

  _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _salvarRequisicao(
      Destino destino, Origem origem, Custos custos) async {
    Usuario passageiro = await UsuarioFirebase.getDadosUsuarioLogado();

    Requisicao requisicao = Requisicao();

    requisicao.destino = destino;
    requisicao.origem = origem; // Defina a origem com base no objeto Origem
    requisicao.passageiro = passageiro;
    requisicao.custos = custos;
    requisicao.status = StatusRequisicao.AGUARDANDO;

    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("requisicoes").doc(requisicao.id).set(requisicao.toMap());

    Map<String, dynamic> dadosRequisicaoAtiva = {};
    dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
    dadosRequisicaoAtiva["id_usuario"] = passageiro.id;
    dadosRequisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;

    print("\n\n Salvamento Concluido com Sucesso! \n\n");

    db
        .collection("requisicoes_ativas")
        .doc(passageiro.id)
        .set(dadosRequisicaoAtiva);
  }

  _adicionarListenerRequisicaoAtiva() async {
    User? firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection("requisicoes_ativas")
        .doc(firebaseUser?.uid)
        .snapshots()
        .listen((snapshot) {
      //print("dados recuperados: " + snapshot.data.toString());

      /*
    Caso tenha uma requisicao ativa
      -> altera interface de acordo com status
    Caso não tenha
      -> Exibe interface padrão para chamar uber
  */
      if (snapshot.data() != null) {
        Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;

        if (dados != null) {
          String status = dados["status"];

          switch (status) {
            case StatusRequisicao.AGUARDANDO:
              _statusAguardando();
              break;
            case StatusRequisicao.VIAGEM:
              Get.offAll(Corrida());
              break;
          }
        }
      } else {
        _statusMotoristaNaoChamado();
      }
    });
  }

  gerarValorDaCorrida(double latOrigem, double lngOrigem, double latDestino,
      double lngDestino) async {
    DateTime now = DateTime.now();
    int horaAtual = now.hour;

    String periodo;

    if (horaAtual >= 6 && horaAtual < 18) {
      //Bandeira 1 - Manhã e tarde
      //Bandeira 2 = Noite
      periodo = "Bandeira 1";
    } else {
      periodo = "Bandeira 2";
    }
    double qntKMs = 0;
    double valorBase = 4.50;

    switch (periodo) {
      case "Bandeira 1":
        valorBase;
        break;
      case "Bandeira 2":
        //30% do valor de 4.50, porque é bandeira dois.

        valorBase = valorBase + (valorBase * 0.30);
        break;
      default:
        valorBase = 4.50;
        break;
    }

    //double valorCorrida = valorBase * qntKMs;

    final distanciaEmMetros = await Geolocator.distanceBetween(
      latOrigem,
      lngOrigem,
      latDestino,
      lngDestino,
    );

    final distanciaEmKm = distanciaEmMetros / 1000;

    print('A distância entre os pontos A e B é de $distanciaEmKm km.');

    final resultadoFinal = distanciaEmKm * valorBase;

    return resultadoFinal;
  }
}
