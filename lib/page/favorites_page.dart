import 'package:flutter/material.dart';
import '../manager/favorite_manager.dart';
import '../model/gank_info.dart';
import '../widget/gank_list_item.dart';
import '../manager/bus_manager.dart';
import '../event/update_favorites_event.dart';
import '../values/strings.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin {
  List<GankInfo> _gankInfos = [];

  @override
  void initState() {
    super.initState();
    _registBusEvent();
    _loadData();
  }

  void _registBusEvent() async {
    BusManager.bus.on<UpdateFavoritesEvent>().listen((updateFavoriteBusEvent) {
      GankInfo gankInfo = updateFavoriteBusEvent.gankInfo;
      if (_gankInfos.contains(gankInfo)) {
        // 删除
        _gankInfos.remove(gankInfo);
      } else {
        // 添加
        _gankInfos.add(gankInfo);
      }
    });
  }

  void _loadData() async {
    await FavoriteManager.find({}).then((datas) {
      setState(() {
        _gankInfos =
            datas.map<GankInfo>((data) => GankInfo.fromJson(data)).toList();
      });
    });
  }

  void _onItemDismissed(int currentIndex, GankInfo currentGankInfo) async {
    int count = await FavoriteManager.delete(currentGankInfo);
    if (count > 0) {
      setState(() {
        _gankInfos.remove(currentGankInfo);
      });

      SnackBar snackBar = new SnackBar(
          content: const Text(StringValus.DELETE_SUCCESS),
          action: new SnackBarAction(
              label: StringValus.RETRACT,
              onPressed: () async {
                await FavoriteManager.insert(currentGankInfo).then((objectId) {
                  setState(() {
                    _gankInfos.insert(currentIndex, currentGankInfo);
                  });
                });
              }));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Widget _renderList(int index) => new GankListItem(_gankInfos[index],
      currentIndex: index,
      dataCount: _gankInfos.length,
      dismissible: true,
      onDismissed: _onItemDismissed);

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Theme.of(context).backgroundColor,
        child: new ListView.builder(
          itemCount: _gankInfos.length,
          itemBuilder: (context, index) => _renderList(index),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
