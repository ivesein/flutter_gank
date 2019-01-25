import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static Future<SharedPreferences> getInstance() async =>
      await SharedPreferences.getInstance();
}
