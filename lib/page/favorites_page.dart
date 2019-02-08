import 'package:flutter/material.dart';
import '../manager/favorite_manager.dart';
import '../model/gank_info.dart';
import '../model/empty_view_status.dart';
import '../widget/gank_list_item.dart';
import '../widget/empty_view.dart';
import '../manager/bus_manager.dart';
import '../event/update_favorites_event.dart';
import '../constant/strings.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin {
  List<GankInfo> _gankInfos = [];

  // 默认无数据
  EmptyViewStatus _emptyViewStatus = EmptyViewStatus.noData;

  @override
  void initState() {
    super.initState();
    _registBusEvent();
    _loadData();
  }

  void _registBusEvent() async {
    BusManager.bus.on<UpdateFavoritesEvent>().listen((updateFavoriteBusEvent) {
      _loadData();
    });
  }

  void _loadData() async {
    await FavoriteManager.find({}).then((datas) {
      setState(() {
        _gankInfos =
            datas.map<GankInfo>((data) => GankInfo.fromJson(data)).toList();
        _updateEmptyViewStatus();
      });
    });
  }

  void _updateEmptyViewStatus() {
    _emptyViewStatus =
        _gankInfos.isEmpty ? EmptyViewStatus.noData : EmptyViewStatus.hasData;
  }

  void _onItemDismissed(int currentIndex, GankInfo currentGankInfo) async {
    int count = await FavoriteManager.delete(currentGankInfo);
    if (count > 0) {
      setState(() {
        _gankInfos.remove(currentGankInfo);
        _updateEmptyViewStatus();
      });

      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: const Text(StringValues.DELETE_SUCCESS),
          action: new SnackBarAction(
              label: StringValues.RETRACT,
              onPressed: () async {
                await FavoriteManager.insert(currentGankInfo).then((objectId) {
                  setState(() {
                    _gankInfos.insert(currentIndex, currentGankInfo);
                    _updateEmptyViewStatus();
                  });
                });
              })));
    }
  }

  Widget _renderList(int index) => new GankListItem(_gankInfos[index],
      currentIndex: index,
      dataCount: _gankInfos.length,
      dismissible: true,
      onDismissed: _onItemDismissed);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new EmptyView(
        status: _emptyViewStatus,
        // image: ImageValues.EMPTY_VIEW_NO_FAVORITE_IMAGE,
        remark: StringValues.EMPTY_NO_FAVORITE_DATA_REMARK,
        child: new Container(
            color: Theme.of(context).backgroundColor,
            child: new ListView.builder(
              itemCount: _gankInfos.length,
              itemBuilder: (context, index) => _renderList(index),
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
