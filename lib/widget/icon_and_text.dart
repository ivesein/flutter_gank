import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  final double size;
  final IconData iconData;
  final String text;
  final int color;

  IconAndText(this.iconData, this.text,
      {this.color = 0xFF546E7A, this.size = 16.0});

  @override
  Widget build(BuildContext context) => new Row(children: <Widget>[
        new Icon(this.iconData, size: this.size, color: new Color(this.color)),
        new SizedBox(width: 5.0),
        new Text(text, style: new TextStyle(fontSize: this.size))
      ]);
}
