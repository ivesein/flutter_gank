import 'package:flutter/material.dart';
import '../util/data_util.dart';
import '../model/history_content_info.dart';
import '../widget/load_more_view.dart';
import '../widget/history_content_list_item.dart';
import '../page/detail_page.dart';
import 'dart:async';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final int _pageCount = 20;
  int _pageNum = 1;
  bool _isLoadMore = false;
  bool _hasMore = false;
  List<HistoryContentInfo> _historyList = [];
  StreamController<List<HistoryContentInfo>> _streamController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initController();
    _initLoad();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _scrollController.dispose();
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

  Future<void> _initLoad() async {
    if (_isLoadMore) {
      _pageNum += 1;
    } else {
      _pageNum = 1;
    }
    await DataUtil.getHistoryContentData(_pageNum, count: _pageCount)
        .then((resultList) {
      _historyList.addAll(resultList);
      _streamController.sink.add(_historyList);
      _hasMore = resultList.length >= _pageCount;
    });
  }

  Future<void> _onRefresh() async {
    _historyList.clear();
    _isLoadMore = false;
    await _initLoad();
  }

  Future<void> _onLoadMore() async {
    if (_hasMore) {
      _isLoadMore = true;
      await _initLoad();
    }
  }

  void _itemTap(BuildContext context, String date) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => new DetailPage(date)));

  Widget _renderList(
      BuildContext context, int index, List<HistoryContentInfo> dataList) {
    if (index == dataList.length) {
      return new LoadMoreView(_hasMore);
    }
    return new HistoryContentListItem(dataList[index], onTap: _itemTap);
  }

  @override
  Widget build(BuildContext context) {
    final Widget appBar = new AppBar(
      title: const Text('干货历史'),
      leading: const BackButton(),
    );

    final Widget body = new StreamBuilder<List<HistoryContentInfo>>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Center(child: const CircularProgressIndicator());
        }
        return Container(
          color: Theme.of(context).backgroundColor,
          child: new RefreshIndicator(
            child: new ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) =>
                    _renderList(context, index, snapshot.data)),
            onRefresh: _onRefresh,
          ),
        );
      },
    );

    return new Scaffold(appBar: appBar, body: body);
  }
}
