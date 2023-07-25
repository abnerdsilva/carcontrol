import 'dart:developer';

import 'package:carcontrol/model/expense_model.dart';
import 'package:carcontrol/model/maintenance_menu_model.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/pages/maintenance/components/maintenance_menu_widget.dart';
import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  static const String route = '/maintenance';

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  final controller = Get.put(HomeController(Get.find()));

  TextEditingController dataEC = TextEditingController(text: DateTime.now().toLocal().toString().substring(0, 10));
  TextEditingController totalEC = TextEditingController(text: 0.toStringAsFixed(2));
  TextEditingController observationEC = TextEditingController();
  TextEditingController kilometragemEC = TextEditingController();

  MaintenanceMenuModel? itemSelected;

  final _formKey = GlobalKey<FormState>();

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (itemSelected == null) {
      Get.snackbar('Ops', 'Selecione um tipo da despesa');
      return;
    }

    log(kilometragemEC.value.text);
    final item = ExpenseModel(
      dataHora: dataEC.value.text,
      observacao: observationEC.value.text,
      tipoCombustivel: '',
      tipoDespesa: itemSelected!.text,
      valor: double.parse(totalEC.value.text),
      valorCombustivel: 0.0,
      quantidade: 0.0,
      kilometragem: double.parse(kilometragemEC.value.text.isEmpty ? '0' : kilometragemEC.value.text),
    );

    if (item.dataHora.isEmpty || totalEC.value.text.isEmpty) {
      Get.snackbar('Ops', 'verifique os campos');
      return;
    }

    await controller.saveExpense(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      const Center(
                        child: Text(
                          'Manutenção',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Center(
                        child: TextField(
                          controller: dataEC,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Data evento",
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
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                              dataEC.text = formattedDate;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Tipo Manutenção'),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: itemSelected == null
                              ? Text(
                                  'Selecione uma despesa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                )
                              : null,
                          items: [
                            ...MaintenanceMenuWidget.items.map(
                              (item) => DropdownMenuItem<MaintenanceMenuModel>(
                                value: item,
                                child: MaintenanceMenuWidget.buildItem(item),
                              ),
                            ),
                          ],
                          value: itemSelected,
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                              color: Colors.white,
                            ),
                            elevation: 2,
                          ),
                          onChanged: (value) {
                            final t = value as MaintenanceMenuModel;
                            log(t.text);
                            setState(() {
                              itemSelected = t;
                            });
                          },
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: MediaQuery.of(context).size.width * .9,
                            // padding: const EdgeInsets.only(left: 14, right: 14),
                            // useSafeArea: true,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            // offset: const Offset(20, 100),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Kilometragem'),
                      CustomTextFormField(
                        height: 45,
                        controller: kilometragemEC,
                        validator: (value) {
                          if (value == null) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Total Gasto'),
                      Focus(
                        child: CustomTextFormField(
                          height: 45,
                          controller: totalEC,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        onFocusChange: (value) {
                          if (!value) {
                            setState(() {
                              totalEC.text = double.parse(totalEC.value.text).toStringAsFixed(2);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          labelText: 'Observação',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: ElevatedButton(
                            onPressed: () => saveExpense(),
                            child: const Text('Lançar'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
