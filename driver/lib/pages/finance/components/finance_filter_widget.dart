import 'package:carcontrol/pages/finance/finance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FinanceFilterWidget extends GetView<FinanceController> {
  const FinanceFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    controller.startDateEC.text = '';
    controller.endDateEC.text = '';

    controller.typeSelected.value = 1;

    return Stack(
      children: [
        Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                const Center(
                  child: Text(
                    'Filtrar por',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Data: ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: controller.startDateEC,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: "Inicio",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 1,
                            ),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                            controller.startDateEC.text = formattedDate;
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 30,
                    ),
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: controller.endDateEC,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: "Fim",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 3,
                            ),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                            controller.endDateEC.text = formattedDate;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Categoria:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 30,
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        child: Obx(
                          () => Container(
                            height: 35,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: controller.typeSelected.value == 1 ? Colors.blueAccent : Colors.transparent,
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                            child: const Text('Todos'),
                          ),
                        ),
                        onTap: () {
                          print('--------- Todos 1 ----------');
                          controller.typeSelected.value = 1;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => InkWell(
                          child: Container(
                            height: 35,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: controller.typeSelected.value == 2 ? Colors.blueAccent : Colors.transparent,
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                            child: const Text('Saida'),
                          ),
                          onTap: () {
                            print('--------- Saida 1 ----------');
                            controller.typeSelected.value = 2;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => InkWell(
                          child: Container(
                            height: 35,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: controller.typeSelected.value == 3 ? Colors.blueAccent : Colors.transparent,
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                            child: const Text('Entrada'),
                          ),
                          onTap: () {
                            print('--------- Entrada 1 ----------');
                            controller.typeSelected.value = 3;
                          },
                        ),
                      ),
                    ),
                    // Switch(
                    //   value: true,
                    //   onChanged: (bool value) {},
                    // ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Tipo lançamento:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 30,
                    ),
                    // Expanded(
                    //   flex: 3,
                    //   child: Column(
                    //     children: controller.options
                    //         .map(
                    //           (e) => Container(
                    //             child: InkWell(
                    //               child: Row(
                    //                 children: [
                    //                   Radio(
                    //                     value: controller.currentOption.value,
                    //                     groupValue: e,
                    //                     onChanged: (value) {},
                    //                   ),
                    //                   Text(e)
                    //                 ],
                    //               ),
                    //               onTap: () {},
                    //             ),
                    //           ),
                    //         )
                    //         .toList(),
                    //   ),
                    // ),

                  ],
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: Container(),
                ),
                ElevatedButton(
                  onPressed: () => controller.filterFinances(),
                  child: Container(
                    // width: MediaQuery.sizeOf(context).width * .8,
                    alignment: Alignment.center,
                    child: const Text('Filtrar'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
