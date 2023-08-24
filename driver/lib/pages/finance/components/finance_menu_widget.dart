import 'package:carcontrol/model/maintenance_menu_model.dart';
import 'package:flutter/material.dart';

class FinanceMenuWidget {
  static const List<FinanceMenuModel> items = [
    FinanceMenuModel(
      text: 'Abastecimento',
      code: 1,
    ),
    FinanceMenuModel(
      text: 'Mecânica',
      code: 2,
    ),
    FinanceMenuModel(
      text: 'Elétrica',
      code: 3,
    ),
    FinanceMenuModel(
      text: 'Imposto',
      code: 4,
    ),
    FinanceMenuModel(
      text: 'Outro',
      code: 4,
    ),
  ];

  static Widget buildItem(FinanceMenuModel item) {
    return Text(
      item.text,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  static FinanceMenuModel getMenuItem(int code) {
    return items.firstWhere((element) => code == element.code);
  }
}
