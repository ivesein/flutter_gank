import 'package:flutter/material.dart';
import '../widget/placeholder_image_view.dart';

class GankPicItem extends StatelessWidget {
  final String url;
  GankPicItem(this.url);

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PlaceholderImageView(this.url),
    );
  }
}
