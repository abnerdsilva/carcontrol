import 'package:carcontrol/core/db/db_firestore.dart';
import 'package:carcontrol/model/race_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {
  late FirebaseFirestore db;

  HomeRepository() {
    startRepository();
  }

  Future<void> startRepository() async {
    await startFirestore();
  }

  startFirestore() {
    db = DBFirestore.get();
  }

  saveRaceConcluded(String docId, RaceModel race) async {
    await db.collection('races').doc(docId).set({
      'address-destination': race.addressDestination,
      'address-origem': race.addressOrigem,
      'dest-position': {
        'latitude': race.destinationPosition!.latitude,
        'longitude': race.destinationPosition!.longitude,
      },
      'orig-position': {
        'latitude': race.origemPosition!.latitude,
        'longitude': race.origemPosition!.longitude,
      },
      'distance-destination': race.distanceDestination,
      'distance-origem': race.distanceOrigem,
      'driverValue': race.valueDriver,
      'totalValue': race.value,
      'id': race.id,
      'status': 'concluded'
    });
  }

  deleteCollectionPendingRaces(String id) async {
    await db.collection('pending-races').doc(id).delete();
  }
}