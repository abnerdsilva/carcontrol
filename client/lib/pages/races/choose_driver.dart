import 'package:carcontrol/model/usuario_model.dart';
import 'package:carcontrol/model/destino_model.dart';
import 'package:carcontrol/model/requisicao_model.dart';
import 'package:carcontrol/util/status_requisicao.dart';
import 'package:carcontrol/util/usuario_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../home/home_controller.dart';
import 'corrida.dart';
import '../../model/custos_da_viagem_model.dart';
import '../../model/origem_model.dart';

class ChooseDriver extends StatefulWidget {
  @override
  State<ChooseDriver> createState() => _ChooseDriverState();
}

class _ChooseDriverState extends State<ChooseDriver> {
  Set<Marker> _marcadores = {};
  bool _exibirCaixaEnderecoDestino = true;
  String _textoBotao = "Chamar Motorista";
  Color _corBotao = Color(0x34262323);
  late Function _funcaoBotao;
  bool _exibirTelaBuscandoMotorista = true;

  TextEditingController _controllerDestino = TextEditingController();

  TextEditingController _controllerLocal =
      TextEditingController(text: "Meu Local");

  double? latitude;

  double? longitude;

  late String endereco;

  late String teste;

  late HomeController controller;

  Set<Marker> _markers = {};

  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    _pegarPosicao();
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
            //myLocationEnabled: true,
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
                      //controller: _controllerLocal,
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
                          hintText: "Meu Local",
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
                  //color: Color(0xff1ebbd8),
                  //padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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

    _alterarBotaoPrincipal("Confirmar Corrida", Color(0xff192d34), () {
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
              //Text("Aguarde...", textAlign: TextAlign center),
              //SizedBox(height: 10),
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

  /*obterEnderecoAtual() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark currentAddress = placemarks.first;

      Origem origem = Origem();
      origem.rua = currentAddress.thoroughfare!;
      origem.numero = currentAddress.subThoroughfare!;
      origem.bairro = currentAddress.subLocality!;
      origem.cidade = currentAddress.administrativeArea!;
      origem.cep = currentAddress.postalCode!;
      origem.latitude = position.latitude;
      origem.longitude = position.longitude;

      print("Endereço Atual:");
      print("Rua: ${origem.rua}");
      print("Número: ${origem.numero}");
      print("Bairro: ${origem.bairro}");
      print("Cidade: ${origem.cidade}");
      print("CEP: ${origem.cep}");
      print("Latitude: ${origem.latitude}");
      print("Longitude: ${origem.longitude}");

      // Agora você pode usar os dados em 'origem' conforme necessário.
    } catch (e) {
      print("Erro ao obter a localização atual: $e");
    }
  }*/

  _chamarMotorista() async {
    String enderecoDestino = _controllerDestino.text;

    if (enderecoDestino.isNotEmpty) {
      try {
        List<Location> listaEnderecos =
            await locationFromAddress(enderecoDestino);
        Location enderecoNovo = listaEnderecos[0];

        List<Placemark> novo = await placemarkFromCoordinates(
            enderecoNovo.latitude, enderecoNovo.longitude);

        Placemark destinoPlacemark = novo[0];

        print("\n\n\n\n Endereco Destino \n\n\n\n" +
            destinoPlacemark.toString() +
            "\n\n\n\n");

        // Crie um objeto Destino para armazenar os detalhes do destino
        Destino destino = Destino();
        destino.cidade = destinoPlacemark.administrativeArea!;
        destino.cep = destinoPlacemark.postalCode!;
        destino.bairro = destinoPlacemark.subLocality!;
        destino.rua = destinoPlacemark.thoroughfare!;
        destino.numero = destinoPlacemark.subThoroughfare!;
        destino.latitude = enderecoNovo.latitude;
        destino.longitude = enderecoNovo.longitude;
        destino.horario = enderecoNovo.timestamp;

        // Obtenha a localização atual
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Obtenha os detalhes do endereço atual
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        Placemark origemPlacemark = placemarks.first;

        Origem origem = Origem();
        origem.rua = origemPlacemark.thoroughfare!;
        origem.numero = origemPlacemark.subThoroughfare!;
        origem.bairro = origemPlacemark.subLocality!;
        origem.cidade = origemPlacemark.administrativeArea!;
        origem.cep = origemPlacemark.postalCode!;
        origem.latitude = position.latitude;
        origem.longitude = position.longitude;

        /*print("Endereço Atual:");
        print("Rua: ${origem.rua}");
        print("Número: ${origem.numero}");
        print("Bairro: ${origem.bairro}");
        print("Cidade: ${origem.cidade}");
        print("CEP: ${origem.cep}");
        print("Latitude: ${origem.latitude}");
        print("Longitude: ${origem.longitude}");*/

        Custos custos = Custos();
        custos.valor_total_corrida = 10.0;
        custos.valor_do_passageiro = 2.0;
        custos.valor_do_motorista = 7.0;

        String enderecoConfirmacao =
            "\n Cidade: ${destino.cidade}\n Rua: ${destino.rua}, ${destino.numero}"
            "\n Bairro: ${destino.bairro}\n CEP: ${destino.cep}";

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
                    // Chamada do motorista
                    _salvarRequisicao(destino, origem, custos);

                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Erro ao obter endereços: $e");
      }
    } else {
      _showAlertDialog("Ops!", "Endereço de Destino Vazio.");
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

  _pegarPosicao() async {
    Position posicao = controller.posi;

    List<Placemark> locais =
        await placemarkFromCoordinates(posicao.latitude, posicao.longitude);

    if (locais != null) {
      setState(() {
        Placemark local = locais[0];

        Destino destino = Destino();

        destino.cidade = local.subAdministrativeArea!;
        destino.cep = local.postalCode!;
        destino.bairro = local.subLocality!;
        destino.rua = local.thoroughfare!;
        destino.numero = local.subThoroughfare!;

        destino.latitude = posicao.latitude;
        destino.longitude = posicao.longitude;

        print("\n\n\n\n Endereco Local \n\n\n\n" +
            " Cidade = " +
            local.administrativeArea! +
            " \n" +
            " Cep = " +
            local.postalCode! +
            " \n" +
            " Bairro = " +
            local.subLocality! +
            " \n" +
            " Rua = " +
            local.thoroughfare! +
            " \n" +
            " Numero = " +
            local.subThoroughfare! +
            " \n" +
            "\n\n\n\n");
      });
    }
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
    print("Cheguei na função");
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
            case StatusRequisicao.FINALIZADA:
              // Restante do código
              break;
          }
        }
      } else {
        _statusMotoristaNaoChamado();
      }
    });
  }
}
