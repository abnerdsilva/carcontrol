import 'package:carcontrol/pages/config/config_controller.dart';
import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NewCarWidget extends GetView<ConfigController> {
  const NewCarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 6),
                  child: const Text(
                    'Novo veículo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                CustomTextFormField(
                  label: 'Modelo',
                  controller: controller.modelEC,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  label: 'Marca',
                  controller: controller.brandEC,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: CustomTextFormField(
                        label: 'Placa',
                        textAlign: TextAlign.center,
                        controller: controller.plateEC,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: CustomTextFormField(
                        label: 'Fabricação',
                        controller: controller.yearEC,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  label: 'Cor',
                  controller: controller.colorEC,
                ),
                // const SizedBox(height: 12),
                // Obx(
                //   () => SizedBox(
                //     child: CheckboxListTile(
                //       value: controller.isDefaultVehicle.value,
                //       title: const Text('Veículo padrão?'),
                //       onChanged: (value) {
                //         controller.isDefaultVehicle.value = value!;
                //       },
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => controller.createVehicle(),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .7,
                      alignment: Alignment.center,
                      child: const Text('Salvar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
