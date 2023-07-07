import 'package:carcontrol/model/menu_tipo_combustivel_model.dart';
import 'package:flutter/material.dart';

class MenuCombustiveis {
  static const List<MenuTipoCombustivelModel> items = [
    MenuTipoCombustivelModel(
      text: 'Gasolina',
      code: 1,
    ),
    MenuTipoCombustivelModel(
      text: 'Alcool',
      code: 2,
    ),
  ];

  static Widget buildItem(MenuTipoCombustivelModel item) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static MenuTipoCombustivelModel getMenuItem(int code) {
    return items.firstWhere((element) => code == element.code);
  }
}
