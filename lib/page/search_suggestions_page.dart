import 'package:flutter/material.dart';
import '../manager/search_history_manager.dart';
import '../widget/search_hisotry_item_list.dart';

class SearchSuggestionsPage extends StatefulWidget {
  final Function(String) onSelected;
  SearchSuggestionsPage({@required this.onSelected});

  @override
  State<StatefulWidget> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestionsPage> {
  List<String> _historys = [];

  @override
  void initState() {
    super.initState();
    _initHistorys();
  }

  void _initHistorys() async {
    await SearchHistoryManager.findAll().then((historys) {
      setState(() {
        this._historys = historys;
      });
    });
  }

  Widget _renderList(int index) => new SearchHistorItemList(
      history: _historys[index],
      onTap: (history) => widget.onSelected(history));

  @override
  Widget build(BuildContext context) => new ListView.builder(
      itemCount: _historys.length,
      itemBuilder: (context, index) => _renderList(index));
}
