import '../util/net_util.dart';
import '../api/api.dart';
import '../model/today_indfo.dart';
import '../model/history_content_info.dart';
import '../model/gank_info.dart';
import '../model/api_basic_result.dart';
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

  /// 获取某个分类下的数据
  /// [category] 分类名称
  /// [page] 页号
  /// [count] 每页数量
  static Future<List<GankInfo>> getCategoryData(String category, int page,
      {count = 20}) async {
    String response = await Netutil.get('${Api.DATA}$category/$count/$page');
    List<dynamic> dataList = json.decode(response)['results'];
    List<GankInfo> resultList = [];
    dataList.forEach((json) {
      try {
        resultList.add(GankInfo.fromJson(json));
      } catch (e) {
        print('GanInfo转换异常');
      }
    });
    return resultList;
  }

  /// 查询数据
  /// [query] 查询内容
  /// [page] 页号
  /// [category] 分类,目前默认是搜索全部
  /// [count] 每页数量
  static Future<List<GankInfo>> searchData(String query, int page,
      {category = 'all', count = 20}) async {
    String response = await Netutil.get(
        '${Api.SEARCH}query/$query/category/$category/count/$count/page/$page');
    List<dynamic> dataList = json.decode(response)['results'];
    List<GankInfo> resultList = [];
    dataList.forEach((json) {
      try {
        resultList.add(GankInfo.fromJson(json));
      } catch (e) {
        print('GankInfo转换异常');
      }
    });
    return resultList;
  }

  static Future<ApiBasicResult> submit(Map<dynamic, dynamic> params) async {
    String response = await Netutil.post(Api.SUBMIT, params);
    ApiBasicResult result = ApiBasicResult.fromJson(json.decode(response));
    return result;
  }
}
