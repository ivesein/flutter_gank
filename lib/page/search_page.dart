import 'package:flutter/material.dart';
import '../manager/search_history_manager.dart';
import '../page/search_suggestions_page.dart';
import '../page/search_results_page.dart';
import '../page/gank_item_page.dart';

class SearchPage extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[
        query.isNotEmpty
            ? new IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  query = '';
                  showSuggestions(context);
                })
            : new Container()
      ];
  @override
  Widget buildLeading(BuildContext context) => new IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null));

  @override
  Widget buildSuggestions(BuildContext context) =>
      new SearchSuggestionsPage(onSelected: (history) {
        SearchHistoryManager.add(history);
        query = history;
        showResults(context);
      });

  @override
  Widget buildResults(BuildContext context) {
    SearchHistoryManager.add(query);
    return SearchResultsPage(query);
  }
}
