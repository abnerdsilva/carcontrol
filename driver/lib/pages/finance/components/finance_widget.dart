import 'dart:developer';

import 'package:carcontrol/model/expense_model.dart';
import 'package:carcontrol/model/maintenance_menu_model.dart';
import 'package:carcontrol/model/menu_tipo_combustivel_model.dart';
import 'package:carcontrol/pages/finance/components/finance_menu_widget.dart';
import 'package:carcontrol/pages/finance/finance_controller.dart';
import 'package:carcontrol/pages/finance/components/menu_combustiveis.dart';
import 'package:carcontrol/shared/components/custom_text_form_field.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FinanceWidget extends StatefulWidget {
  const FinanceWidget({Key? key}) : super(key: key);

  static const String route = '/maintenance';

  @override
  State<FinanceWidget> createState() => _FinanceWidgetState();
}

class _FinanceWidgetState extends State<FinanceWidget> {
  final controller = Get.put(FinanceController(Get.find()));

  TextEditingController dataEC = TextEditingController(text: DateTime.now().toLocal().toString().substring(0, 10));
  TextEditingController totalEC = TextEditingController(text: 0.toStringAsFixed(2));
  TextEditingController observationEC = TextEditingController();
  TextEditingController kilometragemEC = TextEditingController();
  TextEditingController priceEC = TextEditingController();
  TextEditingController quantityEC = TextEditingController();
  TextEditingController nameEC = TextEditingController();

  FinanceMenuModel? itemSelected;
  MenuTipoCombustivelModel? itemTypeSelected;

  final _formKey = GlobalKey<FormState>();

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (nameEC.text.isEmpty) {
      Get.snackbar('Ops', 'Informe a descrição do lançamento', backgroundColor: Colors.amber);
      return;
    }
    if (itemSelected == null) {
      Get.snackbar('Ops', 'Selecione um tipo de lançamento', backgroundColor: Colors.amber);
      return;
    }

    final prefs = await SharedPrefsRepository.instance;
    final id = prefs.firebaseID ?? '1';

    String fuelType = '';
    double fuelPrice = 0.0;
    if (itemTypeSelected != null) {
      fuelType = itemTypeSelected!.text;

      if (priceEC.text.isEmpty) {
        Get.snackbar('Ops', 'Informe o valor do combustível', backgroundColor: Colors.amber);
        return;
      }

      fuelPrice = double.parse(priceEC.text);
    }

    final item = ExpenseModel(
      driverId: id,
      dataHora: dataEC.value.text,
      observacao: observationEC.value.text,
      nome: nameEC.text,
      tipoCombustivel: fuelType,
      tipoDespesa: itemSelected!.text,
      valor: double.parse(totalEC.value.text),
      valorCombustivel: fuelPrice,
      quantidade: double.parse(quantityEC.value.text.isEmpty ? '0.0' : quantityEC.value.text),
      kilometragem: int.parse(kilometragemEC.value.text.isEmpty ? '0' : kilometragemEC.value.text),
    );

    if (item.dataHora.isEmpty || totalEC.value.text.isEmpty) {
      Get.snackbar('Ops', 'verifique os campos');
      return;
    }

    await controller.saveExpense(item);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      'Lançamento Despesa',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Descrição'),
                      SizedBox(
                        child: CustomTextFormField(
                          height: 45,
                          controller: nameEC,
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
                  const SizedBox(height: 6),
                  const Text('Tipo Lançamento'),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: itemSelected == null
                          ? Text(
                              'Selecione um tipo',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            )
                          : null,
                      items: [
                        ...FinanceMenuWidget.items.map(
                          (item) => DropdownMenuItem<FinanceMenuModel>(
                            value: item,
                            child: FinanceMenuWidget.buildItem(item),
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
                        final t = value as FinanceMenuModel;
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
                  itemSelected != null && itemSelected!.code == 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Preço combustível'),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
                                  child: Focus(
                                    child: CustomTextFormField(
                                      controller: priceEC,
                                      height: 35,
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
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Litros'),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .45,
                                  child: Focus(
                                    child: CustomTextFormField(
                                      controller: quantityEC,
                                      height: 35,
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
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  itemSelected != null && itemSelected!.code == 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tipo combustível'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .90,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: itemTypeSelected == null
                                      ? Text(
                                          'Selecione um combustível',
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
                                  value: itemTypeSelected,
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
                                    final t = value as MenuTipoCombustivelModel;
                                    log(t.text);
                                    setState(() {
                                      itemTypeSelected = t;
                                    });
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    // width: MediaQuery.of(context).size.width * .9,
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
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Kilometragem'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .45,
                            child: CustomTextFormField(
                              height: 45,
                              controller: kilometragemEC,
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
                          const Text('Total'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .45,
                            child: Focus(
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
                          ),
                        ],
                      ),
                    ],
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
                  // const SizedBox(height: 36),
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
    );
  }
}
