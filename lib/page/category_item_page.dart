import 'package:flutter/material.dart';

class CategoryItemPage extends StatefulWidget {
  final String categotyName;
  CategoryItemPage(this.categotyName);
  @override
  State<StatefulWidget> createState() => _CategoryItemPageState();
}

class _CategoryItemPageState extends State<CategoryItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return new Center(child: new Text(widget.categotyName));
  }

  @override
  bool get wantKeepAlive => true;
}
