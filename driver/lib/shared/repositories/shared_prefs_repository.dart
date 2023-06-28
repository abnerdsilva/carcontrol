import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlavorSharedPrefs {
  static const accessTOKEN = '/CARCONTROL_ACCESS_TOKEN/';
  static const deviceID = '/CARCONTROL_DEVICE_ID/';
  static const firebaseID = '/CARCONTROL_FIREBASE_ID/';
  static const userEMAIL = '/CARCONTROL_FIREBASE_ID/';
}

class SharedPrefsRepository {
  static const _accessTOKEN = FlavorSharedPrefs.accessTOKEN;
  static const _deviceID = FlavorSharedPrefs.deviceID;
  static const _firebaseID = FlavorSharedPrefs.firebaseID;
  static const _userEMAIL = FlavorSharedPrefs.userEMAIL;

  static SharedPreferences? prefs;
  static SharedPrefsRepository? _instanceRepository;

  SharedPrefsRepository._();

  static Future<SharedPrefsRepository> get instance async {
    prefs ??= await SharedPreferences.getInstance();
    _instanceRepository ??= SharedPrefsRepository._();

    return _instanceRepository!;
  }

  Future<void> registerUserEmail(String email) async {
    await prefs!.setString(_userEMAIL, email);
  }

  String? get userEmail => prefs!.getString(_userEMAIL);

  Future<void> registerAccessToken(String token) async {
    await prefs!.setString(_accessTOKEN, token);
  }

  String? get accessToken => prefs!.getString(_accessTOKEN);

  Future<void> registerDeviceId(String deviceId) async {
    await prefs!.setString(_deviceID, deviceId);
  }

  String? get deviceId => prefs!.getString(_deviceID);

  Future<void> registerFirebaseId(String id) async {
    await prefs!.setString(_firebaseID, id);
  }

  String? get firebaseID => prefs!.getString(_firebaseID);

  Future<void> logout() async {
    prefs!.clear();
    Get.offAndToNamed('/');
  }
}
