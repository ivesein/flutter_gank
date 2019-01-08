import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../model/gank_info.dart';

class ArticlePage extends StatefulWidget {
  final GankInfo gankInfo;
  ArticlePage(this.gankInfo);
  @override
  State<StatefulWidget> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Completer<WebViewController> _webViewController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _webViewController = new Completer();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
        title: new Text(widget.gankInfo.desc), leading: const BackButton());

    final Widget _body = new WebView(
        initialUrl: widget.gankInfo.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController.complete(webViewController);
        });

    final Widget actionButton = new FloatingActionButton(
        child: const Icon(Icons.favorite_border), onPressed: () {});

    return new Scaffold(
        appBar: appBar, body: _body, floatingActionButton: actionButton);
  }
}
