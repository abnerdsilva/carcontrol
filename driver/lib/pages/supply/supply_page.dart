import 'dart:developer';

import 'package:carcontrol/model/expense_model.dart';
import 'package:carcontrol/model/menu_tipo_combustivel_model.dart';
import 'package:carcontrol/pages/home/home_controller.dart';
import 'package:carcontrol/pages/supply/components/menu_combustiveis.dart';
import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupplyPage extends StatefulWidget {
  const SupplyPage({Key? key}) : super(key: key);

  static const String route = '/supply';

  @override
  State<SupplyPage> createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage> {
  final controller = Get.put(HomeController(Get.find()));

  TextEditingController dataEC = TextEditingController();
  TextEditingController hourEC = TextEditingController();
  TextEditingController priceEC = TextEditingController();
  TextEditingController totalEC = TextEditingController();
  TextEditingController quantityEC = TextEditingController();
  TextEditingController typeEC = TextEditingController();
  TextEditingController observationEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  MenuTipoCombustivelModel? itemSelected;

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (itemSelected == null) {
      Get.snackbar('Ops', 'Selecione um tipo de cumbustível');
      return;
    }
    if (totalEC.value.text == '' || priceEC.value.text == '' || quantityEC.value.text == '') {
      Get.snackbar('Ops', 'Preencha todos os campos obrigatórios');
      return;
    }

    final item = ExpenseModel(
      dataHora: dataEC.value.text,
      observacao: observationEC.value.text,
      tipoDespesa: 'ABASTECIMENTO',
      tipoCombustivel: itemSelected!.text,
      valor: double.parse(totalEC.value.text),
      valorCombustivel: double.parse(priceEC.value.text),
      quantidade: double.parse(quantityEC.value.text),
    );

    if (item.tipoCombustivel.isEmpty ||
        item.valorCombustivel.isEqual(0.0) ||
        item.valor.isEqual(0.0) ||
        item.dataHora.isEmpty ||
        item.quantidade.isEqual(0)) {
      Get.snackbar('title', 'message');
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
                          'Abastecimento',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Preço combustível'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: CustomTextFormField(
                                  controller: priceEC,
                                  height: 35,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Litros'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .45,
                                child: CustomTextFormField(
                                  controller: quantityEC,
                                  height: 35,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Campo obrigatório';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Tipo combustível'),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: itemSelected == null
                              ? Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                )
                              : null,
                          items: [
                            ...MenuCombustiveis.items.map(
                              (item) => DropdownMenuItem<MenuTipoCombustivelModel>(
                                value: item,
                                child: MenuCombustiveis.buildItem(item),
                              ),
                            ),
                          ],
                          value: itemSelected,
                          onChanged: (value) {
                            final t = value as MenuTipoCombustivelModel;
                            log(t.text);
                            setState(() {
                              itemSelected = t;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .45,
                            child: CustomTextFormField(
                              controller: totalEC,
                              height: 35,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null) {
                                  return 'Campo obrigatório';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: TextField(
                          controller: dataEC,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Data evento",
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
                      const SizedBox(height: 22),
                      TextFormField(
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 200,
                        controller: observationEC,
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
