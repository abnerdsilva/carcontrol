import 'package:carcontrol/model/maintenance_menu_model.dart';
import 'package:flutter/material.dart';

class MaintenanceMenuWidget {
  static const List<MaintenanceMenuModel> items = [
    MaintenanceMenuModel(
      text: 'Outro',
      code: 1,
    ),
    MaintenanceMenuModel(
      text: 'Mecânica',
      code: 2,
    ),
    MaintenanceMenuModel(
      text: 'Elétrica',
      code: 3,
    ),
    MaintenanceMenuModel(
      text: 'Imposto',
      code: 4,
    ),
  ];

  static Widget buildItem(MaintenanceMenuModel item) {
    return Text(
      item.text,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  static MaintenanceMenuModel getMenuItem(int code) {
    return items.firstWhere((element) => code == element.code);
  }
}
