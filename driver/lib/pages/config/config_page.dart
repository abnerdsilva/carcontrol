import 'package:carcontrol/pages/config/components/car_widget.dart';
import 'package:carcontrol/pages/config/config_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  void showMyCars(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.9,
          child: CarWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfigController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Config'),
        actions: [
          ElevatedButton(
            onPressed: () => controller.setLogout(),
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          InkWell(
            child: const ListTile(
              title: Text('Meus veículos'),
              trailing: Icon(Icons.navigate_next),
            ),
            onTap: () => showMyCars(context),
          ),
          const Divider(
            height: 2,
          ),
        ],
      ),
    );
  }
}
