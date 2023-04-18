import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigController extends GetxController {
  RxBool modoPesquisa = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    final prefs = await SharedPreferences.getInstance();
    final modo = prefs.getString('MODO_PESQUISA') ?? 'overlay';
    if (modo == 'overlay') {
      modoPesquisa.value = false;
    } else {
      modoPesquisa.value = true;
    }
  }

  Future<void> setModoPesquisa(bool value) async {
    modoPesquisa.value = value;

    String modo = 'overlay';
    if (value) {
      modo = 'fullscreen';
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('MODO_PESQUISA', modo);
  }
}
