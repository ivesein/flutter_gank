import 'package:flutter/material.dart';
import 'dart:async';
import '../model/gank_info.dart';
import '../util/data_util.dart';
import '../widget/load_more_view.dart';
import '../widget/gank_list_item.dart';
import '../widget/empty_view.dart';
import '../model/empty_view_status.dart';

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
  ScrollController _scrollController;

  // 默认Loading
  EmptyViewStatus _emptyViewStatus = EmptyViewStatus.loading;

  @override
  void initState() {
    super.initState();
    _initController();
    _loadData();
  }

  void _initController() {
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
    List<GankInfo> resultList = widget.query.isNotEmpty
        ? await DataUtil.searchData(widget.query, _pageNo)
        : await DataUtil.getCategoryData(widget.categotyName, _pageNo);

    if (this.mounted) {
      setState(() {
        _gankInfos.addAll(resultList);
        _has More = resultList.length >= 20;

        _emptyViewStatus = _gankInfos.isEmpty && _pageNo == 1
            ? EmptyViewStatus.noData
            : EmptyViewStatus.hasData;
      });
    }
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
    _scrollController.dispose();
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
    return new EmptyView(
      status: _emptyViewStatus,
      child: new Container(
          color: Theme.of(context).backgroundColor,
          child: new RefreshIndicator(
              child: new ListView.builder(
                controller: _scrollController,
                itemCount: _gankInfos.length + 1,
                itemBuilder: (context, index) => _renderList(index),
              ),
              onRefresh: _onRefresh)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
