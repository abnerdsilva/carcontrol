import 'package:carcontrol/config/theme_config.dart';
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
        actions: [
          IconButton(
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
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.finances.length,
            padding: const EdgeInsets.only(top: 8),
            itemBuilder: (context, index) {
              final item = controller.finances[index];

              final despesa = item.tipoDespesa == 'Abastecimento'
                  ? '${item.tipoDespesa} - ${item.tipoCombustivel}'
                  : item.tipoDespesa;

              final imgTipoFinan = item.tipoDespesa == 'Abastecimento'
                  ? 'combustivel'
                  : item.tipoDespesa == 'Mecânica'
                      ? 'chave'
                      : item.tipoDespesa == 'Imposto'
                          ? 'taxa'
                          : 'eletrica';

              final fundoTipoFinan = item.tipoDespesa == 'Abastecimento'
                  ? ThemeConfig.kThirdSecondaryColor
                  : item.tipoDespesa == 'Mecânica'
                      ? Colors.orange[300]
                      : item.tipoDespesa == 'Imposto'
                          ? Colors.green[300]
                          : Colors.yellow[100];

              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            color: ThemeConfig.kGravishBlueColor,
                            width: 8,
                            height: 90,
                            alignment: Alignment.center,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: fundoTipoFinan,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/$imgTipoFinan.png',
                              width: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.tipoDespesa,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    'R\$ ${item.valor.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Text(item.nome),
                              Text(item.observacao),
                              const Divider(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Expanded(
                        //   flex: 1,
                        //   child: InkWell(
                        //     child: const Center(
                        //       child: Icon(
                        //         Icons.delete,
                        //       ),
                        //     ),
                        //     onTap: () {},
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showModalBottomSheet(
      //     context: context,
      //     isScrollControlled: true,
      //     builder: (context) {
      //       return const FractionallySizedBox(
      //         heightFactor: 0.9,
      //         child: FinanceWidget(),
      //       );
      //     },
      //   ),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
