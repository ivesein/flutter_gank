import 'package:flutter/material.dart';
import '../model/today_indfo.dart';
import '../model/gank_info.dart';
import '../util/data_util.dart';
import '../widget/gank_title_item.dart';
import '../widget/gank_list_item.dart';
import '../widget/gank_pic_item.dart';
import '../manager/bus_manager.dart';
import '../event/update_news_date_event.dart';
import '../page/photo_gallery_page.dart';

class NewsPage extends StatefulWidget {
  final String date;
  NewsPage({this.date = ''});
  @override
  State<StatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin {
  String _currentDate = '';
  String _girlImage;
  Map<String, List<GankInfo>> _itemData = new Map();

  double _lastPixels = 0.0;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.date;
    _registerBusEvent();
    _initController();
    _loadData();
  }

  void _registerBusEvent() => BusManager.bus
          .on<UpdateNewsDateEvent>()
          .listen((UpdateNewsDateEvent event) {
        setState(() => _currentDate = event.date);
        _onRefresh();
      });

  void _initController() {
    _scrollController = new ScrollController();
  }

  Future<void> _loadData() async {
    if (_currentDate.isEmpty) {
      await DataUtil.getLastDayData()
          .then((todayInfo) => _setTodayInfo(todayInfo));
    } else {
      await DataUtil.getSpecialDayData(_currentDate)
          .then((todayInfo) => _setTodayInfo(todayInfo));
    }
  }

  Future<void> _onRefresh() async {
    _itemData.clear();
    await _loadData();
    return null;
  }

  void _setTodayInfo(TodayInfo todayInfo) {
    setState(() {
      _girlImage = todayInfo.girlImage;
      _itemData = todayInfo.itemData;
    });
  }

  void _itemPhotoTap(List<String> images) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => new PhotoGalleryPage(images)));

  List<Widget> _buildItem() {
    List<Widget> _widgets = [];

    // 妹子图
    _widgets.add(new GankPicItem(_girlImage,
        onPhototap: () => _itemPhotoTap([_girlImage])));
    _itemData.forEach((title, gankInfos) {
      // 分类标题
      _widgets.add(new GankTitleItem(title));

      for (int i = 0; i < gankInfos.length; i++) {
        // 分类
        _widgets.add(new GankListItem(gankInfos[i],
            currentIndex: i, dataCount: gankInfos.length));
      }
    });
    return _widgets;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) => _itemData.isEmpty
      ? new Center(child: const CircularProgressIndicator())
      : new Container(
          color: Theme.of(context).backgroundColor,
          child: new RefreshIndicator(
              child: new ListView(
                  children: _buildItem(), controller: _scrollController),
              onRefresh: _onRefresh));

  @override
  bool get wantKeepAlive => true;
}
