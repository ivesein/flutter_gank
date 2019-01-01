import './gank_info.dart';
import '../constant/strings.dart';

class TodayInfo {
  final bool error;
  final String girlImage;
  final List<String> category;
  final Map<String, List<GankInfo>> itemData;

  TodayInfo({this.error, this.girlImage, this.category, this.itemData});

  factory TodayInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> _results = json['results'];
    Map<String, List<GankInfo>> _itemData = {};
    String _girlImage = '';
    _results.forEach((key, value) {
      if (key == CATEGORY_WELFARE) {
        _girlImage = value[0]['url'];
      } else {
        _itemData[key] = (value as List<dynamic>)
            .map<GankInfo>((item) => GankInfo.fromJson(item))
            .toList();
      }
    });
    List<String> _category = (json['category'] as List)
        ?.map((categoty) => categoty.toString())
        ?.toList();
    return TodayInfo(
        error: json['error'],
        girlImage: _girlImage,
        category: _category,
        itemData: _itemData);
  }
}
