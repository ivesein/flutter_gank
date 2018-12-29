import 'package:flutter/material.dart';

class GankTitleItem extends StatelessWidget {
  final String _title;
  GankTitleItem(this._title);

  @override
  Widget build(BuildContext context) => new Container(
      padding: const EdgeInsets.all(8.0),
      child: new Text(_title,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)));
}
