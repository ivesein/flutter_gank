import 'package:flutter/material.dart';
import '../values/strings.dart';
import '../values/images.dart';

class EmptyView extends StatelessWidget {
  final Widget child;
  final bool hasData;
  EmptyView({Key key, @required this.child, @required this.hasData})
      : super(key: key);

  Widget _buildNoDataView() => new Center(
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        new Text(StringValus.EMPTY_NO_DATA_REMARK,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        new Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: new Image.asset(ImageValues.EMPTY_VIEW_NO_DATA_IMAGE))
      ]));

  @override
  Widget build(BuildContext context) =>
      this.hasData ? child : _buildNoDataView();
}
