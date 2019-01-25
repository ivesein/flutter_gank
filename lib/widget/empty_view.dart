import 'package:flutter/material.dart';
import '../values/strings.dart';
import '../values/images.dart';

class EmptyView extends StatelessWidget {
  final Widget child;
  final bool hasData;
  final String image;
  final String remark;
  EmptyView(
      {Key key,
      @required this.child,
      @required this.hasData,
      this.image = ImageValues.EMPTY_VIEW_NO_DATA_IMAGE,
      this.remark = StringValus.EMPTY_NO_DATA_REMARK})
      : super(key: key);

  Widget _buildNoDataView() => new Center(
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        new Text(this.remark,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        new Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: new Image.asset(this.image))
      ]));

  @override
  Widget build(BuildContext context) =>
      this.hasData ? this.child : _buildNoDataView();
}
