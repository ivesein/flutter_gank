import 'package:flutter/material.dart';
import '../model/bottom_tab.dart';
import '../page/news_page.dart';
import '../page/sort_page.dart';
import '../page/meizi_page.dart';
import '../page/collections_page.dart';
import '../util/data_util.dart';
import '../widget/history_date_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HoPageState();
}

class _HoPageState extends State<HomePage> {
  int _tabIndex = 0;
  PageController _pageController;

  double _appBarElevation = .0;
  double _historyOpacity = .0;
  String _currentDate;
  List<String> _historyDates = [];
  BottomNavigationBarItem _buildTab(BottomTab tab) =>
      new BottomNavigationBarItem(title: tab.title, icon: tab.icon);

  @override
  void initState() {
    super.initState();
    _initController();
    _loadData();
  }

  void _initController() {
    _pageController = new PageController();
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
        _currentDate = _historyDates[0];
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

  /// 日期选择事件
  void _dateRangeTap() {
    setState(() {
      if (_historyOpacity == .0) {
        // 取消AppBar底部阴影
        _appBarElevation = .0;
        // 显示日期选择栏
        _historyOpacity = 1.0;
      } else {
        _appBarElevation = 4.0;
        _historyOpacity = .0;
      }
    });
  }

  /// 更多日期
  void _moreHistoryTap() {}

  void _doSearch() {}

  Widget _buildLeading() {
    IconButton _iconButton;
    if (_tabIndex == TabCategory.news.index) {
      _iconButton = new IconButton(
          icon: const Icon(Icons.date_range), onPressed: _dateRangeTap);
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

  @override
  Widget build(BuildContext context) {
    // 标题栏
    final Widget _appBar = new AppBar(
        title: _tabIndex == TabCategory.news.index
            ? new Text(_currentDate ?? '')
            : null,
        leading: _buildLeading(),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.search), onPressed: _doSearch)
        ],
        elevation: _appBarElevation);

    // 历史日期选择栏
    final Widget _historyView = new AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _historyOpacity,
        child: new HistoryDateView(
            currentDate: _currentDate,
            historyDates: _historyDates,
            onTap: (date) {
              setState(() {
                _currentDate = date;
              });
            }));

    // 内容
    final Widget _body = new Stack(children: <Widget>[
      new PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            new NewsPage(),
            new SortPage(),
            new MeiZiPage(),
            new CollectionsPage()
          ]),
      _historyView
    ]);

    // Tab栏
    final Widget _bottomTabBar = new BottomNavigationBar(
        items: bottomTabs.map(_buildTab).toList(),
        type: BottomNavigationBarType.fixed,
        currentIndex: _tabIndex,
        onTap: _selectedTab);

    return new Scaffold(
        appBar: _appBar, body: _body, bottomNavigationBar: _bottomTabBar);
  }
}
