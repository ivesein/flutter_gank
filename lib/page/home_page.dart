import 'package:flutter/material.dart';
import '../model/bottom_tab.dart';
import '../page/news_page.dart';
import '../page/category_page.dart';
import '../page/meizi_page.dart';
import '../page/favorites_page.dart';
import '../page/search_page.dart';
import '../page/submit_page.dart';
import '../page/login_page.dart';
import '../page/settings_page.dart';
import '../util/data_util.dart';
import '../widget/history_date_view.dart';
import '../manager/bus_manager.dart';
import '../manager/user_manager.dart';
import '../event/update_news_date_event.dart';
import '../event/update_user_info_event.dart';
import '../manager/favorite_manager.dart';
import '../values/strings.dart';
import '../model/user_info.dart';
import '../widget/placeholder_image_view.dart';

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

  UserInfo _userInfo;

  BottomNavigationBarItem _buildTab(BottomTab tab) =>
      new BottomNavigationBarItem(title: tab.title, icon: tab.icon);

  @override
  void initState() {
    super.initState();
    _initApp();
    _initData();
    _registerBusEvent();
    _initController();
    _loadData();
  }

  void _initApp() async {
    // 收藏数据库
    await FavoriteManager.init();
  }

  void _initData() async {
    _userInfo = await UserManager.getUserInfo();
  }

  void _registerBusEvent() => BusManager.bus
          .on<UpdateUserInfoEvent>()
          .listen((UpdateUserInfoEvent event) {
        setState(() => this._userInfo = event.userInfo);
      });

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

      _appBarElevation = _tabIndex != TabCategory.category.index ? 4.0 : 0.0;
    });
  }

  /// 日期选择
  void _onDateRangeTap() {
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

  /// 历史日期选择栏点击
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
          icon: const Icon(Icons.date_range), onPressed: _onDateRangeTap);
    } else {
      iconButton = null;
    }
    return iconButton;
  }

  List<Widget> _buildActions() => [
        // 添加
        new IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _onSubmitTap(context)),
        // 搜索
        new IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearch(context)),
        // 头像
        new IconButton(
            icon: this._userInfo == null
                ? const Icon(Icons.account_circle)
                : new CircleAvatar(
                    radius: 12.0,
                    child: new ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        child:
                            new PlaceholderImageView(this._userInfo.avatarUl))),
            onPressed: () => _onAccountTap(context))
      ];

  /// 打开[发布干货页]
  void _onSubmitTap(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => new SubmitPage()));

  /// 打开[搜索页]
  void _onSearch(BuildContext context) async {
    await showSearch(context: context, delegate: SearchPage());
  }

  void _onAccountTap(BuildContext context) async {
    // 判断是否登陆
    Widget page =
        await UserManager.isLogin() ? new SettingsPage() : new LoginPage();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
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
        actions: _buildActions(),
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
