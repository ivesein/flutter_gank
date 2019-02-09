import 'package:flutter/material.dart';
import '../model/user_info.dart';
import '../constant/colors.dart';

/// 用户信息控件
class UserInfoView extends StatelessWidget {
  final UserInfo userInfo;
  final Function onLoginoutTap;
  UserInfoView(this.userInfo, {Key key, this.onLoginoutTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new CircleAvatar(
            backgroundColor: const Color(ColorValues.IMAGE_PLACHEHOLDER_COLOR),
            backgroundImage: new NetworkImage(this.userInfo.avatarUl),
          ),
          new Expanded(
              child: new Align(
                  alignment: Alignment.center,
                  child: new Text(this.userInfo.login,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)))),
          new IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pop(context);
                this.onLoginoutTap();
              })
        ]);
  }
}
