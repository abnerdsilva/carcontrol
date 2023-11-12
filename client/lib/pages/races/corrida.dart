import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../util/status_requisicao.dart';
import '../../util/usuario_firebase.dart';
import '../dashboard/dashboard_page.dart';
import 'location_service.dart';

class Corrida extends StatefulWidget {
  @override
  State<Corrida> createState() => CorridaState();
}

class CorridaState extends State<Corrida> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool mostrarInformacoesViagem = true;

  late String _originController = " ";
  late String _destinationController = " ";

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;

  late BitmapDescriptor _passageiroIcon;
  late BitmapDescriptor _destinoIcon;

  late String partida = " ";
  late String destino = " ";

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
    gerarPontosNoMapa();
    _verificarSeCorridaEstaAtiva();
    pegarDadosPartida();
  }

  _loadMarkerIcons() async {
    final ByteData passageiroData =
        await rootBundle.load("assets/images/motorista.png");
    final ByteData destinoData =
        await rootBundle.load("assets/images/passageiro.png");

    _passageiroIcon =
        BitmapDescriptor.fromBytes(passageiroData.buffer.asUint8List());
    _destinoIcon = BitmapDescriptor.fromBytes(destinoData.buffer.asUint8List());
  }

  _setMarker(LatLng point, {bool isPassageiro = true}) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(isPassageiro ? 'passageiro' : 'destino'),
          position: point,
          icon: isPassageiro ? _passageiroIcon : _destinoIcon,
        ),
      );
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polygonIdCounter';
    _polygonIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 1,
        color: Color(0xFF1A2E35),
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );

    _showTripFinishedDialog();
  }

  Future<void> gerarPontosNoMapa() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseFirestore data = FirebaseFirestore.instance;
    User? firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    final snapshot =
        await db.collection("requisicoes_ativas").doc(firebaseUser?.uid).get();
    if (snapshot.data() != null) {
      Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
      if (dados != null) {
        String idRequisicao = dados["id_requisicao"];
        String idUsuario = dados["id_usuario"];
        String status = dados["status"];
        print(
            "\n\n Dados Coletados \n\n idRequisicao: $idRequisicao idUsuario: $idUsuario Status: $status");

        final snapshotRequisicao =
            await data.collection("requisicoes").doc(idRequisicao).get();
        if (snapshotRequisicao.data() != null) {
          Map<String, dynamic>? dadosEndereco =
              snapshotRequisicao.data() as Map<String, dynamic>?;
          print("Achei os dados da requisicoes: " + dadosEndereco.toString());
          if (dadosEndereco != null) {
            String bairroLocal = dadosEndereco['origemPassageiro']["bairro"];
            String cepLocal = dadosEndereco['origemPassageiro']["cep"];
            String numeroLocal = dadosEndereco['origemPassageiro']["numero"];
            String ruaLocal = dadosEndereco['origemPassageiro']["rua"];

            String bairroDestino = dadosEndereco['destinoPassageiro']["bairro"];
            String cepDestino = dadosEndereco['destinoPassageiro']["cep"];
            String numeroDestino = dadosEndereco['destinoPassageiro']["numero"];
            String ruaDestino = dadosEndereco['destinoPassageiro']["rua"];

            final originController = (ruaLocal +
                " " +
                numeroLocal +
                " " +
                bairroLocal +
                " " +
                cepLocal);
            final destinationController = ruaDestino +
                " " +
                numeroDestino +
                " " +
                bairroDestino +
                " " +
                cepDestino;

            // Chame setState fora das funções assíncronas
            setState(() {
              _originController = originController;
              _destinationController = destinationController;
            });

            var directions = await LocationService().getDirections(
              originController,
              destinationController,
            );

            _goToPlace(
              directions['start_location']["lat"],
              directions["start_location"]["lng"],
              directions["bounds_ne"]["lat"],
              directions["bounds_ne"]["lng"],
              directions["bounds_sw"]["lat"],
              directions["bounds_sw"]["lng"],
            );

            // marcador do ponto de origem (passageiro)
            _setMarker(
              LatLng(directions['start_location']["lat"],
                  directions["start_location"]["lng"]),
            );

            // marcador do ponto de destino
            _setMarker(
              LatLng(directions["end_location"]["lat"],
                  directions["end_location"]["lng"]),
              isPassageiro: false, // Usar o ícone de destino
            );

            _setPolyline(directions['polyline_decoded']);
          }
        }
      }
    }
  }

  _showTripFinishedDialog() {
    if (_originController == _destinationController) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Viagem finalizada!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  pegarDadosPartida() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    User? firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("requisicoes_ativas").doc(firebaseUser?.uid).get();

    Map<String, dynamic>? dados = snapshot.data();

    if (dados != null) {
      String idRequisicao = dados["id_requisicao"] ?? "";

      DocumentSnapshot<Map<String, dynamic>> requisicaoSnapshot =
          await db.collection("requisicoes").doc(idRequisicao).get();

      Map<String, dynamic>? dados2 = requisicaoSnapshot.data();

      String rua = dados2?["origemPassageiro"]["rua"];
      String numero = dados2?["origemPassageiro"]["numero"];
      String bairro = dados2?["origemPassageiro"]["bairro"];
      String cidade = dados2?["origemPassageiro"]["cidade"];
      String cep = dados2?["origemPassageiro"]["cep"];

      partida = "${rua}, ${numero} - ${bairro},${cidade} - ${cep}";

      rua = dados2?["destinoPassageiro"]["rua"];
      numero = dados2?["destinoPassageiro"]["numero"];
      bairro = dados2?["destinoPassageiro"]["bairro"];
      // cidade = dados2?["destinoPassageiro"]["cidade"];
      cep = dados2?["destinoPassageiro"]["cep"];

      destino = "${rua}, ${numero} - ${bairro}, - ${cep}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  zoomGesturesEnabled: true,
                  markers: _markers,
                  polygons: _polygons,
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0, 0),
                    zoom: -1,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (point) {
                    setState(() {
                      polygonLatLngs.add(point);
                      _setPolygon();
                    });
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: mostrarInformacoesViagem,
                    // Use uma variável para controlar a visibilidade
                    child: Container(
                      height: 240,
                      color: Color(0xFF1A2E35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Text(
                              'Espere no Local de Partida : ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Text(
                              '${partida}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  informacoesMotorista(context);
                                },
                                child: Container(
                                  width: 300,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Informações da Viagem',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff1564B3),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Text(
                              'Destino Esperado: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            child: Text(
                              '${destino}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Container(color: Color()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 70),
          /*FloatingActionButton(
            heroTag: 'carHero',
            onPressed: () {
              informacoesMotorista(context);
            },
            tooltip: 'Carro',
            child: Icon(Icons.directions_car),
          ),*/
          //SizedBox(height: 16),
          FloatingActionButton(
              heroTag: 'moneyHero',
              onPressed: () {
                valoresCorrida(context);
              },
              tooltip: 'Dinheiro',
              child: Icon(Icons.attach_money_outlined)),
        ],
      ),
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    double boundsNeLat,
    double boundsNeLng,
    double boundsSwLat,
    double boundsSwLng,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSwLat, boundsSwLng),
          northeast: LatLng(boundsNeLat, boundsNeLng),
        ),
        25,
      ),
    );
    _setMarker(
      LatLng(lat, lng),
    );
  }

  _verificarSeCorridaEstaAtiva() async {
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
          var _idRequisicao = dados["id_requisicao"];

          switch (status) {
            case StatusRequisicao.AGUARDANDO:
              break;

            case StatusRequisicao.VIAGEM:
              gerarPontosNoMapa();
              break;
            case StatusRequisicao.FINALIZADA:
              db
                  .collection("requisicoes_ativas")
                  .doc(firebaseUser?.uid)
                  .delete();
              _mostrarDialogCorridaFinalizada(context);
              break;
          }
        }
      } else {}
    });
  }

  _mostrarDialogCorridaFinalizada(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Corrida Finalizada !',
            textAlign: TextAlign.center, // Alinhe o texto ao centro
            style: TextStyle(
              fontSize: 16, // Tamanho da fonte opcional
              fontWeight: FontWeight.bold, // Peso da fonte opcional
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset("assets/images/check.png"),
              ),
              SizedBox(height: 16),
              TextButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Color(0xff1564B3)),
                  ),
                  onPressed: () {
                    Get.offAll(DashboardPage());
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> informacoesMotorista(BuildContext context) async {
    setState(() {
      mostrarInformacoesViagem = false;
    });

    FirebaseFirestore db = FirebaseFirestore.instance;

    User? firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    DocumentSnapshot snapshot =
        await db.collection("requisicoes_ativas").doc(firebaseUser?.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> dados = snapshot.data() as Map<String, dynamic>;

      String idRequisicao = dados["id_requisicao"];
      print("\n\n Dados Coletados \n\n idRequisicao: $idRequisicao");

      DocumentSnapshot requisicaoSnapshot =
          await db.collection("requisicoes").doc(idRequisicao).get();

      if (requisicaoSnapshot.exists) {
        Map<String, dynamic> dados2 =
            requisicaoSnapshot.data() as Map<String, dynamic>;

        String informacoesMotorista = "\n Nome: Teste \n Número da CNH: Teste"
            "\n Telefone: Teste \n Cep: Teste \n\nInformações do Carro\n"
            "Modelo: Teste \nPlaca: Teste \nCor: Cor";

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title:
                  Text("Informações da Corrida", textAlign: TextAlign.center),
              content: Text(informacoesMotorista),
              contentPadding: EdgeInsets.all(30),
              actions: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Container(
                        color: Color(0xFF1A2E35),
                        child: Center(
                          child: Text(
                            "OK",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          mostrarInformacoesViagem = true;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> valoresCorrida(BuildContext context) async {
    setState(() {
      mostrarInformacoesViagem = false;
    });

    FirebaseFirestore db = FirebaseFirestore.instance;

    User? firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    DocumentSnapshot snapshot =
        await db.collection("requisicoes_ativas").doc(firebaseUser?.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> dados = snapshot.data() as Map<String, dynamic>;

      String idRequisicao = dados["id_requisicao"];
      print("\n\n Dados Coletados \n\n idRequisicao: $idRequisicao");

      DocumentSnapshot requisicaoSnapshot =
          await db.collection("requisicoes").doc(idRequisicao).get();

      if (requisicaoSnapshot.exists) {
        Map<String, dynamic> dados2 =
            requisicaoSnapshot.data() as Map<String, dynamic>;

        double valorCorrida = dados2["custosCorrida"]["valor-total-da-corrida"];
        double valorPassageiro = dados2["custosCorrida"]["valor-do-passageiro"];
        double valorMotorista = dados2["custosCorrida"]["valor-do-motorista"];

        String valores =
            "\nTotal da Corrida: ${valorCorrida} \nValor do Motorista: ${valorMotorista}"
            "\nValor do Passageiro: ${valorPassageiro}\n";

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Valores da Corrida", textAlign: TextAlign.center),
              content: Text(valores),
              contentPadding: EdgeInsets.all(30),
              actions: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Container(
                        color: Color(0xFF1A2E35),
                        child: Center(
                          child: Text(
                            "OK",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          mostrarInformacoesViagem = true;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    }
  }
}
