import './gank_info.dart';

class TodayInfo {
  final bool error;
  final List<String> category;
  final Map<String, List<GankInfo>> itemData;

  TodayInfo({this.error, this.category, this.itemData});

  factory TodayInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> _results = json['results'];
    Map<String, List<GankInfo>> _itemData = {};
    _results.forEach((key, value) {
      _itemData[key] = (value as List<dynamic>)
          .map<GankInfo>((item) => GankInfo.fromJson(item))
          .toList();
    });
    return TodayInfo(
        error: json['error'],
        category: (json['category'] as List)
            ?.map((categoty) => categoty.toString())
            ?.toList(),
        itemData: _itemData);
  }
}
