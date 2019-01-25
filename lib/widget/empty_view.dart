import 'package:flutter/material.dart';
import '../values/strings.dart';
import '../values/images.dart';
import '../model/empty_view_status.dart';

class EmptyView extends StatelessWidget {
  final Widget child;
  final String image;
  final String remark;
  final EmptyViewStatus status;
  EmptyView(
      {Key key,
      @required this.child,
      @required this.status,
      this.image = ImageValues.EMPTY_VIEW_NO_DATA_IMAGE,
      this.remark = StringValus.EMPTY_NO_DATA_REMARK})
      : super(key: key);

  Widget _buildLoadingView() =>
      new Center(child: const CircularProgressIndicator());

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
  Widget build(BuildContext context) {
    switch (this.status) {
      case EmptyViewStatus.loading:
        return _buildLoadingView();
        break;
      case EmptyViewStatus.hasData:
        return this.child;
        break;
      case EmptyViewStatus.noData:
        return _buildNoDataView();
        break;
    }
    return _buildLoadingView();
  }
}
