import 'package:flutter/material.dart';
import '../page/gank_item_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  SearchResultsPage(this.query);
  @override
  State<StatefulWidget> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  @override
  Widget build(BuildContext context) =>
      new GankItemPage('all', query: widget.query);
}
