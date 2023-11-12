import 'package:carcontrol/pages/config/components/car_widget.dart';
import 'package:carcontrol/pages/config/config_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigPage extends GetView<ConfigController> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        actions: [
          ElevatedButton(
            onPressed: () => controller.setLogout(),
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Container(
                      color: Colors.blue[100],
                      child: const Icon(
                        Icons.person,
                        size: 120,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Text(controller.userEmail.value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * .8,
            child: const Divider(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            child: const ListTile(
              visualDensity: VisualDensity(vertical: 3),
              dense: false,
              title: Text('Meus veículos'),
              trailing: Icon(Icons.navigate_next),
            ),
            onTap: () => showMyCars(context),
          ),
          const Expanded(
            child: Column(),
          ),
          Text('v${controller.appVersion}'),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
