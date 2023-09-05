import 'package:carcontrol/pages/config/components/menu_item.dart';
import 'package:carcontrol/pages/config/components/new_car_widget.dart';
import 'package:carcontrol/pages/config/config_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarWidget extends StatefulWidget {
  const CarWidget({Key? key}) : super(key: key);

  @override
  State<CarWidget> createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> {
  MenuItemModel? itemSelected;

  void newCarWidget(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.9,
          child: NewCarWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConfigController>();

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 4,
              right: 4,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 6),
                  child: const Text(
                    'Meus veículos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = controller.vehicles[index];

                      return Card(
                        child: Container(
                          color: vehicle.defaultCar ? Colors.green[100] : Colors.white,
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                            left: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${vehicle.brand} - ${vehicle.model}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      vehicle.plate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${vehicle.color} / ${vehicle.year}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(Icons.settings),
                                    ),
                                    items: [
                                      ...MenuItems.items.map(
                                        (item) => DropdownMenuItem<MenuItemModel>(
                                          value: item,
                                          child: MenuItems.buildItem(item),
                                        ),
                                      ),
                                    ],
                                    value: itemSelected,
                                    onChanged: (value) {
                                      final t = value as MenuItemModel;
                                      if (t.code == '2') {
                                        controller.deleteVehicle(vehicle);
                                      } else if (t.code == '1') {
                                        controller.updateVehicleDefault(vehicle.driverId, vehicle.id);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
          Positioned(
            right: 12,
            top: 18,
            child: InkWell(
              onTap: () => newCarWidget(context),
              child: const Text('Novo'),
            ),
          ),
        ],
      ),
    );
  }
}
