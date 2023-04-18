import 'package:carcontrol/pages/config/config_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfigController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Config'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Modo pesquisa:'),
            trailing: Obx(
              () => Switch(
                value: controller.modoPesquisa.value,
                onChanged: controller.setModoPesquisa,
              ),
            ),
          )
        ],
      ),
    );
  }
}
