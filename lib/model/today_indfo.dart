import './gank_info.dart';
import '../constant/strings.dart';

class TodayInfo {
  final bool error;
  final String girlImage;
  final List<String> category;
  final List<GankInfo> gankInfos;

  TodayInfo({this.error, this.girlImage, this.category, this.gankInfos});

  factory TodayInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> results = json['results'];
    List<GankInfo> gankInfos = [];
    String girlImage = '';
    results.forEach((key, value) {
      if (key == CATEGORY_WELFARE) {
        girlImage = value[0]['url'];
      } else {
        gankInfos.add(new GankInfo(isTitle: true, title: key));
        gankInfos.addAll((value as List<dynamic>)
            .map<GankInfo>((item) => GankInfo.fromJson(item))
            .toList());
      }
    });
    List<String> category = (json['category'] as List)
        ?.map((categoty) => categoty.toString())
        ?.toList();
    return TodayInfo(
        error: json['error'],
        girlImage: girlImage,
        category: category,
        gankInfos: gankInfos);
  }
}
