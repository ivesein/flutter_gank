import 'package:flutter/material.dart';
import '../values/strings.dart';
import '../util/data_util.dart';
import '../model/user_info.dart';
import '../manager/user_manager.dart';
import '../manager/bus_manager.dart';
import '../event/update_user_info_event.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _account = '';
  String _passWord = '';
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final GlobalKey<FormState> _formKey = new GlobalKey();

  void _login(BuildContext context) async {
    // 关闭键盘
    FocusScope.of(context).requestFocus(new FocusNode());

    FormState form = _formKey.currentState;
    if (form.validate()) {
      // 保存表单
      form.save();

      // 显示Loading
      setState(() => _isLoading = true);

      // 获取用户信息
      UserInfo userInfo = await DataUtil.login(this._account, this._passWord);

      // 隐藏Loading
      setState(() => _isLoading = false);

      if (userInfo != null) {
        // 保存用户信息到本地
        await UserManager.saveToLocal(userInfo);

        // 通知更新用户信息
        BusManager.bus.fire(new UpdateUserInfoEvent(userInfo));

        // 关闭页面
        Navigator.of(context).pop();
      } else {
        // 显示错误提示
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: const Text(StringValus.LOGIN_FAILED)));
      }
    }
  }

  Widget _buildAppBar() => new AppBar(
      elevation: 0.0,
      leading: new IconButton(
          icon: new Icon(Icons.close),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop()),
      backgroundColor: Colors.white);

  Widget _buildActionButton() => _isLoading
      ? new CircularProgressIndicator()
      : new FloatingActionButton(
          child: const Icon(Icons.send),
          onPressed: () => _login(context),
        );

  Widget _buildBody() {
    final Widget divider = new SizedBox(height: 32.0);

    return new Container(
        color: Colors.white,
        padding: const EdgeInsets.all(32.0),
        child: new Column(children: <Widget>[
          // 标题
          const Text(StringValus.APP_NAME,
              style:
                  const TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),

          divider,

          // 表单
          new Form(
            key: _formKey,
            child: new Column(children: <Widget>[
              // 账号输入框
              new TextFormField(
                  maxLines: 1,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: StringValus.TEXT_FILED_ACCOUNT_LABEL_TEXT),
                  validator: (value) => value.isEmpty
                      ? StringValus.TEXT_FIELD_ACCOUNT_EMPTY_TEXT
                      : null,
                  onSaved: (value) => this._account = value),

              divider,

              // 密码输入框
              new TextFormField(
                  maxLines: 1,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: StringValus.TEXT_FILED_PASSWORD_LABEL_TEXT),
                  validator: (value) => value.isEmpty
                      ? StringValus.TEXT_FIELD_PASSWORD_EMPTY_TEXT
                      : null,
                  onSaved: (value) => this._passWord = value)
            ]),
          ),

          divider,

          // 登录按钮
          _buildActionButton()
        ]));
  }

  Widget build(BuildContext context) {
    final Widget appBar = _buildAppBar();

    final Widget body = _buildBody();

    return new Scaffold(key: _scaffoldKey, appBar: appBar, body: body);
  }
}
