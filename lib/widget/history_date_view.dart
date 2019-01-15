import 'package:flutter/material.dart';
import '../widget/history_list_item.dart';
import '../page/history_page.dart';

class HistoryDateView extends StatelessWidget {
  final double opacity;
  // 日期列表
  final List<String> historyDates;
  // 当前选中的日期
  final String currentDate;
  // item点击回调
  final Function(String) onTap;

  HistoryDateView(
      {Key key,
      @required this.opacity,
      @required this.historyDates,
      @required this.currentDate,
      this.onTap})
      : super(key: key);

  /// 构建日期Item
  Widget _renderDateList(BuildContext context, int index) => index == 7
      ? new IconButton(
          color: Colors.grey[800],
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => new HistoryPage()));
          },
        )
      : new HistoryListItem(this.historyDates[index], this.currentDate,
          onTap: (date) {
          this.onTap(date);
        });

  @override
  Widget build(BuildContext context) => new Material(
      elevation: 4.0,
      child: new AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: this.opacity,
        child: new Container(
            height: this.opacity == 0 ? 0 : 60.0,
            child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: historyDates.isEmpty ? historyDates.length : 8,
              itemBuilder: (context, index) {
                return _renderDateList(context, index);
              },
            )),
      ));
}
