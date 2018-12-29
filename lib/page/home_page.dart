import 'package:flutter/material.dart';
import '../model/bottom_tab.dart';
import '../page/news_page.dart';
import '../page/sort_page.dart';
import '../page/meizi_page.dart';
import '../page/collections_page.dart';
import '../util/data_util.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HoPageState();
}

class _HoPageState extends State<HomePage> {
  int _tabIndex = 0;
  PageController _pageController;

  List<String> _historyDates = [];
  String _lastDate;

  BottomNavigationBarItem _buildTab(BottomTab tab) =>
      new BottomNavigationBarItem(title: tab.title, icon: tab.icon);

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> _loadData() async {
    await DataUtil.getDateList().then((resultList) {
      setState(() {
        _historyDates = resultList;
        _lastDate = _historyDates[0];
      });
    });
  }

  void _selectedTab(int index) {
    setState(() {
      _tabIndex = index;
      _pageController.animateToPage(_tabIndex,
          duration: new Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  Widget _buildLeading() {
    IconButton _iconButton;
    if (_tabIndex == TabCategory.news.index) {
      _iconButton =
          new IconButton(icon: const Icon(Icons.date_range), onPressed: () {});
    } else if (_tabIndex == TabCategory.sort.index) {
      _iconButton =
          new IconButton(icon: const Icon(Icons.add), onPressed: () {});
    } else if (_tabIndex == TabCategory.meizi.index) {
      _iconButton =
          new IconButton(icon: const Icon(Icons.sort), onPressed: () {});
    } else {
      _iconButton =
          new IconButton(icon: const Icon(Icons.settings), onPressed: () {});
    }
    return _iconButton;
  }

  void _doSearch() {}

  @override
  Widget build(BuildContext context) {
    final AppBar _appBar = new AppBar(
        title: _tabIndex == TabCategory.news.index
            ? new Text(_lastDate ?? '')
            : null,
        leading: _buildLeading(),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.search), onPressed: _doSearch)
        ]);

    final _body = new PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          new NewsPage(),
          new SortPage(),
          new MeiZiPage(),
          new CollectionsPage()
        ]);

    final _bottomTabBar = new BottomNavigationBar(
        items: bottomTabs.map(_buildTab).toList(),
        type: BottomNavigationBarType.fixed,
        currentIndex: _tabIndex,
        onTap: _selectedTab);

    return new Scaffold(
        appBar: _appBar, body: _body, bottomNavigationBar: _bottomTabBar);
  }
}
