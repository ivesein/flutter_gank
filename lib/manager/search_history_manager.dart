import 'package:shared_preferences/shared_preferences.dart';
import './preferences_manager.dart';

class SearchHistoryManager {
  static const String KEY_SEARCH_HISTORYS = 'key_search_historys';

  static add(String history) async {
    if (history.isNotEmpty) {
      SharedPreferences preferences = await PreferencesManager.getInstance();
      List<String> historys = await findAll();
      if (historys.contains(history)) {
        // 如果已经保存了当前记录,将位置移动到第一个
        historys.remove(history);
      }
      int index = 0;
      historys.insert(index, history);

      // 保存记录
      await preferences.setStringList(KEY_SEARCH_HISTORYS, historys);
    }
  }

  static Future<List<String>> findAll() async {
    SharedPreferences preferences = await PreferencesManager.getInstance();
    return preferences.getStringList(KEY_SEARCH_HISTORYS) ?? [];
  }
}
