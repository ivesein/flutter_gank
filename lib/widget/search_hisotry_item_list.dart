import 'package:flutter/material.dart';

class SearchHistorItemList extends StatelessWidget {
  final String history;
  final Function(String) onTap;
  SearchHistorItemList({Key key, @required this.history, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => new ListTile(
      leading: const Icon(Icons.history),
      title: new Text(this.history),
      onTap: () => this.onTap(history));
}
