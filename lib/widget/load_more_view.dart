import 'package:flutter/material.dart';

class LoadMoreView extends StatelessWidget {
  final bool hasMore;
  LoadMoreView(this.hasMore, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => new Container(
      padding: const EdgeInsets.all(8.0),
      child: this.hasMore
          ? new Center(child: const CircularProgressIndicator())
          : new Column(
              children: <Widget>[
                new Text(
                  '我是有底线的,不要往上拉了,不然......',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                new SizedBox(height: 8.0),
                new Image.asset('images/ic_list_no_more.jpg')
              ],
            ));
}
