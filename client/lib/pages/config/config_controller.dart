import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
}
