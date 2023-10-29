import 'package:carcontrol/model/expense_model.dart';
import 'package:carcontrol/shared/repositories/firebase_repository.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceController extends GetxController {
  late FirebaseRepository firebaseRepository;

  FinanceController(this.firebaseRepository);

  RxList<FinanceModel> finances = <FinanceModel>[].obs;
  List<FinanceModel> financesTemp = <FinanceModel>[];

  TextEditingController startDateEC = TextEditingController();
  TextEditingController endDateEC = TextEditingController();

  RxBool isFilterSelected = false.obs;

  RxInt typeSelected = 1.obs;

  List<String> options = [
    'Manutenção',
    'Energia',
  ];

  RxString currentOption = ''.obs;

  Future<void> start() async {
    final prefs = await SharedPrefsRepository.instance;
    if (prefs.firebaseID != null && prefs.firebaseID!.isNotEmpty) {
      firebaseRepository.db.collection('financeiro').snapshots().listen((event) {
        finances.clear();
        financesTemp.clear();
        if (event.size > 0) {
          final List<FinanceModel> items = [];
          for (var element in event.docs) {
            items.add(FinanceModel.fromFirestore(element));
          }

          items.sort((a, b) {
            final dateStart = DateTime.parse(a.dataHora);
            final dateEnd = DateTime.parse(b.dataHora);
            return dateEnd.compareTo(dateStart);
          });

          finances.addAll(items);
          financesTemp.addAll(items);
        }
      });
    }
    update();
  }

  Future<void> saveFinance(FinanceModel expense) async {
    firebaseRepository.saveExpense(expense).then((value) {
      Get.back();

      Get.snackbar(
        'Sucesso',
        'Lançamento realizado com sucesso',
        backgroundColor: Colors.green[100],
      );
    }).onError((error, stackTrace) {
      Get.snackbar(
        'Erro',
        'Não foi possivel lançar evento',
        backgroundColor: Colors.red[100],
      );
    });
  }

  void clearFilterFinances() {
    isFilterSelected.value = false;
    finances.clear();
    finances.addAll(financesTemp);
  }

  void filterFinances() {
    if (startDateEC.text.isEmpty && endDateEC.text.isEmpty && typeSelected.value == 1) {
      isFilterSelected.value = false;
      Get.back();
      return;
    }

    isFilterSelected.value = false;

    bool filterDate = false;
    bool filterlancamento = false;

    if (startDateEC.text.isNotEmpty && endDateEC.text.isNotEmpty) {
      filterDate = true;
    }
    if (typeSelected > 1) {
      filterlancamento = true;
    }

    final tipoLancamento = typeSelected.value == 1
        ? ''
        : typeSelected.value == 2
            ? 'saida'
            : 'entrada';

    var financesFiltered = financesTemp;

    if (filterDate) {
      financesFiltered = financesFiltered
          .where((it) => (filterDate
              ? DateTime.parse(startDateEC.text).isBefore(DateTime.parse(it.dataHora)) &&
                  DateTime.parse(endDateEC.text).isAfter(DateTime.parse(it.dataHora))
              : DateTime.parse(startDateEC.text).isBefore(DateTime.now().add(const Duration(days: -60)))))
          .toList();
    }

    if (filterlancamento) {
      financesFiltered = financesFiltered.where((it) => it.tipoFinanceiro == tipoLancamento).toList();
    }

    isFilterSelected.value = true;
    finances.value = financesFiltered;
    Get.back();
  }
}
