import 'package:flutter/material.dart';
import '../model/bottom_tab.dart';
import '../page/news_page.dart';
import '../page/category_page.dart';
import '../page/meizi_page.dart';
import '../page/favorites_page.dart';
import '../page/search_page.dart';
import '../page/submit_page.dart';
import '../util/data_util.dart';
import '../widget/history_date_view.dart';
import '../manager/bus_manager.dart';
import '../event/update_news_date_event.dart';
import '../manager/favorite_manager.dart';
import '../values/strings.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HoPageState();
}

class _HoPageState extends State<HomePage> {
  int _tabIndex = 0;
  PageController _pageController;

  double _appBarElevation = 4.0;
  double _historyOpacity = .0;
  String _currentDate = '';
  List<String> _historyDates = [];

  BottomNavigationBarItem _buildTab(BottomTab tab) =>
      new BottomNavigationBarItem(title: tab.title, icon: tab.icon);

  @override
  void initState() {
    super.initState();
    _initApp();
    _initController();
    _loadData();
  }

  void _initApp() async {
    // 收藏数据库
    await FavoriteManager.init();
  }

  void _initController() {
    _pageController = new PageController();
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

      // 切换到其他分类,隐藏历史日期选择控件
      if (_historyOpacity != 0.0) _historyOpacity = 0.0;

      _appBarElevation = _tabIndex != TabCategory.sort.index ? 4.0 : 0.0;
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

  /// 发布干货事件
  void _postTap(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => new SubmitPage()));

  /// 历史日期选择栏点击事件
  void _historyDateItemTap(String date) {
    setState(() {
      if (_currentDate != date) {
        _currentDate = date;

        /// 通知[NewsPage]刷新
        BusManager.bus.fire(new UpdateNewsDateEvent(_currentDate));
      }
    });
  }

  Widget _buildLeading() {
    IconButton iconButton;
    if (_tabIndex == TabCategory.news.index) {
      iconButton = new IconButton(
          icon: const Icon(Icons.date_range), onPressed: _dateRangeTap);
    } else if (_tabIndex == TabCategory.sort.index) {
      iconButton = new IconButton(
          icon: const Icon(Icons.add), onPressed: () => _postTap(context));
    } else if (_tabIndex == TabCategory.meizi.index) {
      iconButton =
          new IconButton(icon: const Icon(Icons.details), onPressed: () {});
    } else {
      iconButton =
          new IconButton(icon: const Icon(Icons.settings), onPressed: () {});
    }
    return iconButton;
  }

  void _doSearch(BuildContext context) async {
    await showSearch(context: context, delegate: SearchPage());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 标题栏
    final Widget appBar = new AppBar(
        title: new Text(_tabIndex == TabCategory.news.index
            ? _currentDate
            : StringValus.APP_NAME),
        leading: _buildLeading(),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _doSearch(context))
        ],
        elevation: _appBarElevation);

    // 历史日期选择栏
    final Widget historyView = new HistoryDateView(
        opacity: _historyOpacity,
        currentDate: _currentDate,
        historyDates: _historyDates,
        onTap: (date) => _historyDateItemTap(date));

    // 内容
    final Widget body = new Stack(children: <Widget>[
      new PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            new NewsPage(),
            new CategoryPage(),
            new MeiZiPage(),
            new FavoritesPage()
          ]),
      historyView
    ]);

    // Tab栏
    final Widget bottomTabBar = new BottomNavigationBar(
        items: bottomTabs.map(_buildTab).toList(),
        type: BottomNavigationBarType.fixed,
        currentIndex: _tabIndex,
        onTap: _selectedTab);

    return new Scaffold(
        appBar: appBar, body: body, bottomNavigationBar: bottomTabBar);
  }
}
