import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../model/gank_info.dart';
import '../manager/favorite_manager.dart';
import '../manager/bus_manager.dart';
import '../event/update_favorites_event.dart';
import '../constant/strings.dart';

class ArticlePage extends StatefulWidget {
  final GankInfo gankInfo;
  ArticlePage(this.gankInfo);
  @override
  State<StatefulWidget> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool _favoriteStatus = false;
  Completer<WebViewController> _webViewController;
  GlobalKey<ScaffoldState> _scffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _initController();
    _initData();
  }

  void _initController() {
    _webViewController = new Completer();
  }

  void _initData() async {
    String dataId = widget.gankInfo.itemId;
    // 获取收藏状态
    Map<String, dynamic> query = {'itemId': dataId};
    await FavoriteManager.find(query).then((resultList) {
      setState(() => _favoriteStatus = resultList.isEmpty ? false : true);
    });
  }

  /// 收藏点击
  void _favoriteTap(BuildContext context) async {
    if (_favoriteStatus) {
      // 取消
      await FavoriteManager.delete(widget.gankInfo).then((result) {
        if (result > 0) {
          setState(() => _favoriteStatus = false);
        }
      });
    } else {
      // 收藏
      await FavoriteManager.insert(widget.gankInfo).then((objectId) {
        setState(() => _favoriteStatus = true);
      });
    }

    _scffoldKey.currentState.hideCurrentSnackBar();
    _scffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(_favoriteStatus
            ? StringValues.FAVORITE_ARTICLE_SUCCESS
            : StringValues.CANCEL_FAVORITE_ARTICLE_SUCCESS)));

    BusManager.bus.fire(new UpdateFavoritesEvent(widget.gankInfo));
  }

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
        title: new Text(widget.gankInfo.desc), leading: const BackButton());

    final Widget body = new WebView(
        initialUrl: widget.gankInfo.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController.complete(webViewController);
        });

    final Widget actionButton = new FloatingActionButton(
        child: new Icon(
            _favoriteStatus ? Icons.favorite : Icons.favorite_border,
            color: _favoriteStatus ? Colors.red : Colors.black),
        onPressed: () => _favoriteTap(context));

    return new Scaffold(
        key: _scffoldKey,
        appBar: appBar,
        body: body,
        floatingActionButton: actionButton);
  }
}
