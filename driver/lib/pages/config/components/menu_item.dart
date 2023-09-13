import 'package:flutter/material.dart';

class MenuItemModel {
  final String text;
  final IconData icon;
  final String code;

  const MenuItemModel({
    required this.text,
    required this.icon,
    required this.code,
  });
}

class MenuItems {
  static const List<MenuItemModel> items = [
    MenuItemModel(
      text: 'Definir padrão',
      icon: Icons.settings,
      code: '1',
    ),
    MenuItemModel(
      text: 'Excluir veículo',
      icon: Icons.delete,
      code: '2',
    ),
  ];

  static Widget buildItem(MenuItemModel item) {
    return Text(
      item.text,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  static MenuItemModel getMenuItem(String code) {
    return items.firstWhere((element) => code == element.code);
  }
}
