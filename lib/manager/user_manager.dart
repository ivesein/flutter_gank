import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../manager/preferences_manager.dart';
import '../model/user_info.dart';

class UserManager {
  static const String KEY_USER_INFO = 'key_user_info';

  static Future<bool> isLogin() async {
    SharedPreferences preferences = await PreferencesManager.getInstance();
    return preferences.getString(KEY_USER_INFO) != null;
  }

  static Future<void> saveToLocal(UserInfo userInfo) async {
    String userInfoData = json.encode(userInfo.toJson());
    SharedPreferences preferences = await PreferencesManager.getInstance();
    await preferences.setString(KEY_USER_INFO, userInfoData);
  }

  static Future<UserInfo> getUserInfo() async {
    SharedPreferences preferences = await PreferencesManager.getInstance();
    String userInfoData = preferences.getString(KEY_USER_INFO);
    UserInfo info = UserInfo.fromJson(json.decode(userInfoData));
    return info;
  }
}
