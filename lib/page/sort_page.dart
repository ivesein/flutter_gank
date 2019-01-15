import 'package:flutter/material.dart';
import '../model/category_info.dart';
import '../page/category_item_page.dart';

class SortPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _tabController = TabController(vsync: this, length: categorys.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Tab _buildTab(CategoryInfo category) =>
      new Tab(text: category.name == 'all' ? '全部' : category.name);

  Widget _buildPage(CategoryInfo category) =>
      new CategoryItemPage(category.name);

  @override
  Widget build(BuildContext context) {
    final TabBar tabBar = new TabBar(
        controller: _tabController,
        isScrollable: true,
        unselectedLabelColor: Theme.of(context).primaryColor,
        labelColor: Colors.grey[800],
        indicatorSize: TabBarIndicatorSize.label,
        tabs: categorys.map(_buildTab).toList());

    final Widget body = new Expanded(
        child: new Container(
            decoration: new BoxDecoration(
                border: Border(
                    top:
                        new BorderSide(color: Theme.of(context).dividerColor))),
            child: new TabBarView(
                controller: _tabController,
                children: categorys.map(_buildPage).toList())));

    return new DefaultTabController(
      length: categorys.length,
      child: new Column(
        children: <Widget>[tabBar, body],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
