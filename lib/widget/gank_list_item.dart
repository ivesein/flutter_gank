import 'package:flutter/material.dart';
import '../model/gank_info.dart';
import '../widget/icon_and_text.dart';
import '../widget/placeholder_image_view.dart';
import '../util/time_util.dart';
import '../page/article_page.dart';

class GankListItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GankListItemState();
  final GankInfo gankInfo;
  final int currentIndex;
  final int dataCount;
  // 是否支持测滑删除
  final bool dismissible;
  final Function(int, GankInfo) onDismissed;
  GankListItem(this.gankInfo,
      {Key key,
      @required this.currentIndex,
      @required this.dataCount,
      this.dismissible = false,
      this.onDismissed})
      : super(key: key);
}

class _GankListItemState extends State<GankListItem> {
  bool _readingRecordStatus = false;
  final double _defaultSpacing = 8.0;

  /// 构建文字信息
  Widget _buildText() => new Text(widget.gankInfo.desc,
      style: new TextStyle(
          fontSize: 18.0,
          color: this._readingRecordStatus ? Colors.grey : Colors.blueGrey[800],
          fontWeight: FontWeight.bold));

  /// 构建底部布局
  Widget _buildBottom(BuildContext context) => Row(children: <Widget>[
        new IconAndText(
          Icons.person,
          widget.gankInfo.who,
        ),
        new SizedBox(width: _defaultSpacing),
        new IconAndText(
            Icons.update, getTimeDuration(widget.gankInfo.publishedAt))
      ]);

  ///构建缩略图
  Widget _buildPreView() =>
      widget.gankInfo.images == null || widget.gankInfo.images.isEmpty
          ? new Container()
          : new ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              child: new PlaceholderImageView(
                  // 禁止播放GIF,容易造成OOM
                  widget.gankInfo.images[0].replaceAll('large', 'thumbnail'),
                  width: 100.0,
                  height: 100.0),
            );

  /// 构建内容
  Widget _buildContent(BuildContext context) {
    final borderRadius = const BorderRadius.all(Radius.circular(4.0));
    return new Material(
        borderRadius: borderRadius,
        child: new InkWell(
            borderRadius: borderRadius,
            child: new Container(
              padding: new EdgeInsets.all(_defaultSpacing),
              child: new Row(children: <Widget>[
                new Expanded(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildText(),
                        new SizedBox(height: _defaultSpacing),
                        _buildBottom(context)
                      ]),
                ),
                new SizedBox(width: _defaultSpacing),
                _buildPreView()
              ]),
            ),
            onTap: () => _onItemTap(context)));
  }

  /// 构建布局
  Widget _buildLayout(BuildContext context) {
    final double topSpacing = widget.currentIndex == 0 ? _defaultSpacing : .0;
    final double bottomSpacing =
        widget.currentIndex == widget.dataCount ? .0 : _defaultSpacing;
    return new Card(
        margin: new EdgeInsets.only(
            left: _defaultSpacing,
            right: _defaultSpacing,
            top: topSpacing,
            bottom: bottomSpacing),
        child: _buildContent(context));
  }

  void _onItemTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new ArticlePage(widget.gankInfo)));
  }

  @override
  Widget build(BuildContext context) {
    return widget.dismissible
        ? new Dismissible(
            key: new Key(widget.gankInfo.itemId),
            child: _buildLayout(context),
            onDismissed: (decoration) {
              widget.onDismissed(widget.currentIndex, widget.gankInfo);
            })
        : _buildLayout(context);
  }
}
