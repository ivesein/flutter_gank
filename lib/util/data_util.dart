import '../util/net_util.dart';
import '../api/api.dart';
import '../model/today_indfo.dart';
import 'dart:convert';

class DataUtil {
  /// 获取发过干货的日期列表
  static Future<List<String>> getDateList() async {
    String _response = await Netutil.get(Api.HISTORY);
    List<dynamic> _list = json.decode(_response)['results'];
    List<String> _results = new List<String>.from(_list);
    return _results;
  }

  /// 获取最新一天的干货
  static Future<TodayInfo> getLastDayData() async {
    String _response = await Netutil.get(Api.TODAY);
    Map<String, dynamic> _json = json.decode(_response);
    TodayInfo _info = TodayInfo.fromJson(_json);
    return _info;
  }
}
