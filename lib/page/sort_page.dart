import 'package:flutter/material.dart';
import '../model/category_info.dart';
import '../page/category_item_page.dart';

class SortPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage>
    with AutomaticKeepAliveClientMixin {
  Tab _buildTab(CategoryInfo category) => new Tab(text: category.name);

  Widget _buildPage(CategoryInfo category) =>
      new CategoryItemPage(category.name);
  @override
  Widget build(BuildContext context) {
    final TabBar tabBar = new TabBar(
      isScrollable: true,
      unselectedLabelColor: Theme.of(context).primaryColor,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: categorys.map(_buildTab).toList(),
    );

    final TabBarView body =
        new TabBarView(children: categorys.map(_buildPage).toList());

    return new DefaultTabController(
      length: categorys.length,
      child: new Scaffold(
        appBar: tabBar,
        body: body,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
