import 'package:flutter/material.dart';
import '../model/gank_info.dart';
import '../widget/icon_and_text.dart';

class GankListItem extends StatelessWidget {
  final GankInfo _gankInfo;

  GankListItem(this._gankInfo);

  static const double _defaultSpacing = 8.0;

  /// 构建内容
  Widget _buildContent() => new Text(_gankInfo.desc,
      style: new TextStyle(
          fontSize: 18.0,
          color: Colors.blueGrey[800],
          fontWeight: FontWeight.bold));

  /// 构建底部布局
  Widget _buildBottom(BuildContext context) => Row(
        children: <Widget>[
          new IconAndText(
            Icons.face,
            _gankInfo.who,
          ),
          new SizedBox(width: 8.0),
          new IconAndText(Icons.timer, '2天前')
        ],
      );

  ///构建缩略图
  Widget _buildPreView() => _gankInfo.images == null
      ? new Container()
      : new ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          child: new Image.network(
            _gankInfo.images[0],
            width: 100.0,
            height: 100.0,
            fit: BoxFit.contain,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: const EdgeInsets.only(
          left: _defaultSpacing,
          right: _defaultSpacing,
          bottom: _defaultSpacing),
      child: new Container(
        padding: const EdgeInsets.all(_defaultSpacing),
        child: new Row(children: <Widget>[
          new Expanded(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildContent(),
                  new SizedBox(height: _defaultSpacing),
                  _buildBottom(context)
                ]),
          ),
          new SizedBox(width: _defaultSpacing),
          _buildPreView()
        ]),
      ),
    );
  }
}
