import 'package:flutter/material.dart';
import '../widget/placeholder_image_view.dart';

class GankPicItem extends StatelessWidget {
  final String url;
  final Function onPhototap;
  GankPicItem(this.url, {Key key, this.onPhototap}) : super(key: key);

  @override
  Widget build(BuildContext context) => new Container(
          child: new Hero(
        tag: url,
        child: new Card(
            margin: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: new Material(
                child: new InkWell(
                    child: new PlaceholderImageView(this.url),
                    onTap: () => this.onPhototap()))),
      ));
}
