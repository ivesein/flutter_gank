import '../util/net_util.dart';
import '../api/api.dart';
import '../model/today_indfo.dart';
import '../model/history_content_info.dart';
import 'dart:convert';

class DataUtil {
  /// 获取发过干货的日期列表
  static Future<List<String>> getDateList() async {
    String response = await Netutil.get(Api.HISTORY);
    List<dynamic> dataList = json.decode(response)['results'];
    List<String> resultList = new List<String>.from(dataList);
    return resultList;
  }

  /// 获取最新一天的干货
  static Future<TodayInfo> getLastDayData() async {
    String response = await Netutil.get(Api.TODAY);
    Map<String, dynamic> map = json.decode(response);
    TodayInfo info = TodayInfo.fromJson(map);
    return info;
  }

  /// 获取所有历史干货
  /// [pageNum] 页数
  static Future<List<HistoryContentInfo>> getHistoryContentData(int pageNum,
      {int count = 20}) async {
    String response =
        await Netutil.get('${Api.HISTORY_CONTENT}/$count/$pageNum');
    List<dynamic> dataList = json.decode(response)['results'];
    List<HistoryContentInfo> resultList = [];
    dataList.forEach((json) {
      try {
        resultList.add(HistoryContentInfo.fromJson(json));
      } catch (e) {
        print('HistoryContentInfo转换异常');
      }
    });
    return resultList;
  }

  /// 获取某个日期下的干货数据
  /// [date] 日期
  static Future<TodayInfo> getSpecialDayData(String date) async {
    String response =
        await Netutil.get('${Api.SPECIAL_DAY}${date.replaceAll('-', '/')}');
    Map<String, dynamic> map = json.decode(response);
    TodayInfo info = TodayInfo.fromJson(map);
    return info;
  }
}
