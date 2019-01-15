import 'package:flutter/material.dart';
import 'dart:async';
import '../model/gank_info.dart';
import '../util/data_util.dart';
import '../widget/load_more_view.dart';
import '../widget/gank_list_item.dart';

class CategoryItemPage extends StatefulWidget {
  final String categotyName;
  CategoryItemPage(this.categotyName);
  @override
  State<StatefulWidget> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage>
    with AutomaticKeepAliveClientMixin {
  int _pageNo = 1;
  bool _isLoadMore = false;
  bool _hasMore = false;
  List<GankInfo> _gankInfos = [];
  StreamController<List<GankInfo>> _streamController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initController();
    _loadData();
  }

  void _initController() {
    _streamController = new StreamController();

    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _onLoadMore();
      }
    });
  }

  Future<void> _loadData() async {
    _isLoadMore ? _pageNo++ : _pageNo = 1;
    await DataUtil.getCategoryData(widget.categotyName, _pageNo)
        .then((resultList) {
      _gankInfos.addAll(resultList);
      _streamController.sink.add(_gankInfos);
      _hasMore = resultList.length >= 20;
    });
  }

  Future<void> _onRefresh() async {
    _isLoadMore = false;
    _gankInfos.clear();
    await _loadData();
    return null;
  }

  Future<void> _onLoadMore() async {
    _isLoadMore = true;
    await _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  Widget _renderList(int index, List<GankInfo> gankInfos) {
    if (index == gankInfos.length) {
      return new LoadMoreView(_hasMore);
    }
    return GankListItem(gankInfos[index],
        currentIndex: index, dataCount: gankInfos.length);
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<List<GankInfo>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Center(child: const CircularProgressIndicator());
          }
          return new Container(
            color: Theme.of(context).backgroundColor,
            child: new RefreshIndicator(
              child: new ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) =>
                    _renderList(index, snapshot.data),
              ),
              onRefresh: _onRefresh,
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
