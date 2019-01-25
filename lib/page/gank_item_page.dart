import 'package:flutter/material.dart';
import 'dart:async';
import '../model/gank_info.dart';
import '../util/data_util.dart';
import '../widget/load_more_view.dart';
import '../widget/gank_list_item.dart';
import '../widget/empty_view.dart';

class GankItemPage extends StatefulWidget {
  final String categotyName;
  // 是不是进行查询
  final String query;
  GankItemPage(this.categotyName, {this.query = ''});
  @override
  State<StatefulWidget> createState() => _GankItemPageState();
}

class _GankItemPageState extends State<GankItemPage>
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
    List<GankInfo> resultList = [];
    if (widget.query.isNotEmpty) {
      // 搜索数据
      resultList = await DataUtil.searchData(widget.query, _pageNo);
    } else {
      // 获取分类数据
      resultList = await DataUtil.getCategoryData(widget.categotyName, _pageNo);
    }
    _gankInfos.addAll(resultList);
    _streamController.sink.add(_gankInfos);
    _hasMore = resultList.length >= 20;
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

  Widget _renderList(int index) {
    if (index == _gankInfos.length) {
      return new LoadMoreView(_hasMore);
    }
    return GankListItem(_gankInfos[index],
        currentIndex: index, dataCount: _gankInfos.length);
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<List<GankInfo>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Center(child: const CircularProgressIndicator());
          }
          return new EmptyView(
              child: new Container(
                  color: Theme.of(context).backgroundColor,
                  child: new RefreshIndicator(
                      child: new ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (context, index) => _renderList(index),
                      ),
                      onRefresh: _onRefresh)),
              hasData: _gankInfos.isNotEmpty);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
