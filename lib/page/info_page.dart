import 'package:flutter/material.dart';
import '../model/user_info.dart';
import '../widget/user_info_view.dart';

class InfoPage extends StatelessWidget {
  final UserInfo userInfo;
  final Function onLoginoutTap;
  InfoPage({@required this.userInfo, this.onLoginoutTap})
      : assert(userInfo != null);

  Widget _buildBody() => new Container(
      height: 100.0,
      padding: const EdgeInsets.all(32.0),
      child:
          new UserInfoView(this.userInfo, onLoginoutTap: this.onLoginoutTap));

  @override
  Widget build(BuildContext context) => _buildBody();
}
