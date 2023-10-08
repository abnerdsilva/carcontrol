import 'package:carcontrol/model/expense_model.dart';
import 'package:carcontrol/shared/repositories/firebase_repository.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceController extends GetxController {
  late FirebaseRepository firebaseRepository;

  FinanceController(this.firebaseRepository);

  RxList<FinanceModel> finances = <FinanceModel>[].obs;

  Future<void> start() async {
    final prefs = await SharedPrefsRepository.instance;
    if (prefs.firebaseID != null && prefs.firebaseID!.isNotEmpty) {
      firebaseRepository.db.collection('financeiro').snapshots().listen((event) {
        finances.clear();
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
}
