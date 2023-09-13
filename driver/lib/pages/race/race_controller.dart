import 'package:carcontrol/model/race_model.dart';
import 'package:carcontrol/shared/repositories/firebase_repository.dart';
import 'package:carcontrol/shared/repositories/shared_prefs_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RaceController extends GetxController {
  late FirebaseRepository firebaseRepository;

  RaceController(this.firebaseRepository);

  RxList<RaceModel> races = <RaceModel>[].obs;

  Future<void> getRaces() async {
    final prefs = await SharedPrefsRepository.instance;
    final racesHistory = await firebaseRepository.getRacesHistory(prefs.vehicleId.toString());
    races.clear();

    racesHistory.sort((a, b) {
      final dateStart = DateTime.parse(a.landingDate!);
      final dateEnd = DateTime.parse(b.landingDate!);
      return dateEnd.compareTo(dateStart);
    });

    races.addAll(racesHistory);
    update();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyy HH:mm').format(date);
  }
}
