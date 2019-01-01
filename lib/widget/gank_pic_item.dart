import 'package:flutter/material.dart';
import '../widget/placeholder_image_view.dart';
import '../util/display_util.dart';

class GankPicItem extends StatelessWidget {
  final String url;
  GankPicItem(this.url);

  @override
  Widget build(BuildContext context) {
    return new Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PlaceholderImageView(this.url),
    );
  }
}
