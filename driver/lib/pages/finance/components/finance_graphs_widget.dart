import 'package:carcontrol/pages/finance/finance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FinanceLancamento {
  FinanceLancamento(this.name, this.value);

  final String name;
  final num value;
}

class FinanceData {
  FinanceData(this.year, this.xValue, this.yValue);

  final num year;
  final num xValue;
  final num yValue;
}

class FinanceGraphsWidget extends StatefulWidget {
  const FinanceGraphsWidget({super.key});

  @override
  State<FinanceGraphsWidget> createState() => _FinanceGraphsWidgetState();
}

class _FinanceGraphsWidgetState extends State<FinanceGraphsWidget> {
  final controller = Get.find<FinanceController>();

  final formKey = GlobalKey<FormState>();

  final lancamentos = ['entrada', 'saida'];
  List<FinanceLancamento> chartLancamentos = [];

  List<FinanceData> chartFinanceEntry = [];
  List<FinanceData> chartFinanceOut = [];
  List<Map<int, int>> period = [];

  void addLancamentosChart() {
    chartLancamentos.clear();
    final itemsLancamentoEntrada = controller.finances.where((p) => p.tipoFinanceiro == 'entrada').toList();
    var sumValue = 0.0;
    for (var el in itemsLancamentoEntrada) {
      sumValue += el.valor;
    }
    chartLancamentos.add(FinanceLancamento('Receia', sumValue));

    final itemsLancamentoSaida = controller.finances.where((p) => p.tipoFinanceiro == 'saida').toList();

    sumValue = 0.0;
    for (var el in itemsLancamentoSaida) {
      sumValue += el.valor;
    }
    chartLancamentos.add(FinanceLancamento('Despesa', sumValue));
  }

  void calculaChartMonth() {
    for (var e in controller.finances) {
      final item = {
        DateTime.parse(e.dataHora).year: DateTime.parse(e.dataHora).month,
      };
      period.add(item);
    }

    for (var lancamento in lancamentos) {
      for (var el in period) {
        final month = el.values.first;
        final year = el.keys.first;

        final items = controller.finances
            .where((p) =>
                p.tipoFinanceiro == lancamento &&
                DateTime.parse(p.dataHora).month == month &&
                DateTime.parse(p.dataHora).year == year)
            .toList();

        var sumValue = 0.0;
        for (var el in items) {
          sumValue += el.valor;
        }

        var exists = false;
        final fin = FinanceData(year, month, sumValue);
        if (lancamento == 'entrada') {
          for (var el in chartFinanceEntry) {
            if (el.year == fin.year && fin.xValue == el.xValue && fin.yValue == el.yValue) {
              exists = true;
            }
          }
          if (!exists) {
            chartFinanceEntry.add(fin);
          }
        } else {
          for (var el in chartFinanceOut) {
            if (el.year == fin.year && fin.xValue == el.xValue && fin.yValue == el.yValue) {
              exists = true;
            }
          }
          if (!exists) {
            chartFinanceOut.add(fin);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    addLancamentosChart();
    calculaChartMonth();

    List<LineSeries<FinanceData, num>> defaultLineSeries() {
      return <LineSeries<FinanceData, num>>[
        LineSeries<FinanceData, num>(
          animationDuration: 1000,
          dataSource: chartFinanceEntry,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            alignment: ChartAlignment.near,
          ),
          xValueMapper: (FinanceData sales, _) => double.parse(sales.xValue.toStringAsFixed(2)),
          yValueMapper: (FinanceData sales, _) => double.parse(sales.yValue.toStringAsFixed(2)),
          width: 1,
          name: 'Receita',
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        LineSeries<FinanceData, num>(
          animationDuration: 1000,
          dataSource: chartFinanceOut,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            alignment: ChartAlignment.near,
          ),
          width: 1,
          name: 'Despesa',
          xValueMapper: (FinanceData sales, _) => double.parse(sales.xValue.toStringAsFixed(2)),
          yValueMapper: (FinanceData sales, _) => double.parse(sales.yValue.toStringAsFixed(2)),
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ];
    }

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                const Center(
                  child: Text(
                    'Gráficos Financeiro',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 22),
                SfCircularChart(
                  title: ChartTitle(text: 'Lançamentos'),
                  legend: const Legend(isVisible: true),
                  series: <PieSeries<FinanceLancamento, String>>[
                    PieSeries<FinanceLancamento, String>(
                      explode: false,
                      dataSource: chartLancamentos,
                      xValueMapper: (FinanceLancamento data, _) => data.name,
                      yValueMapper: (FinanceLancamento data, _) => double.parse(data.value.toStringAsFixed(2)),
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
                const Divider(),
                SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  title: ChartTitle(text: 'Lançamentos do mês'),
                  isTransposed: false,
                  legend: const Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  primaryXAxis: NumericAxis(
                    title: AxisTitle(text: 'Mês'),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 1,
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Valor R\$'),
                    labelFormat: '{value}',
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(color: Colors.transparent),
                  ),
                  series: defaultLineSeries(),
                  tooltipBehavior: TooltipBehavior(enable: true),
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
