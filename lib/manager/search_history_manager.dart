import 'package:shared_preferences/shared_preferences.dart';
import './preferences_manager.dart';

class SearchHistoryManager {
  static const String SEARCH_HISTORY_LIST = 'search_history_list';

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
      await preferences.setStringList(SEARCH_HISTORY_LIST, historys);
    }
  }

  static Future<List<String>> findAll() async {
    SharedPreferences preferences = await PreferencesManager.getInstance();
    return preferences.getStringList(SEARCH_HISTORY_LIST) ?? [];
  }
}
