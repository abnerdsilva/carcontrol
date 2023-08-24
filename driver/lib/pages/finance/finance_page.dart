import 'package:carcontrol/pages/finance/components/finance_widget.dart';
import 'package:carcontrol/pages/finance/finance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancePage extends GetView<FinanceController> {
  static const String route = '/finance';

  const FinancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Financeiro'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.finances.length,
                itemBuilder: (context, index) {
                  final item = controller.finances[index];

                  final despesa = item.tipoDespesa == 'Abastecimento'
                      ? '${item.tipoDespesa} - ${item.tipoCombustivel}'
                      : item.tipoDespesa;

                  return Card(
                    child: Container(
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
                                  item.nome,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      despesa,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      item.valor.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item.dataHora,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              child: const Center(
                                child: Icon(
                                  Icons.delete,
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showBottomSheet(
      //     context: context,
      //     builder: (context) {
      //       return const Expanded(child: MaintenanceWidget());
      //     },
      //   ),
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const FractionallySizedBox(
              heightFactor: 0.9,
              child: FinanceWidget(),
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
