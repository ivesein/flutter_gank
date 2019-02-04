import 'package:flutter/material.dart';
import '../values/strings.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _account = '';
  String _passWord = '';
  final GlobalKey<FormState> _formKey = new GlobalKey();

  void _login(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {}
  }

  Widget _buildAppBar() => new AppBar(
      elevation: 0.0,
      leading: new IconButton(
          icon: new Icon(Icons.close),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop()),
      backgroundColor: Colors.white);

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
                  onSaved: (value) => setState(() => this._account = value)),

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
                  onSaved: (value) => setState(() => this._passWord = value))
            ]),
          ),

          divider,

          // 登录按钮
          new FloatingActionButton(
              child: const Icon(Icons.send), onPressed: () => _login(context))
        ]));
  }

  Widget build(BuildContext context) {
    final Widget appBar = _buildAppBar();

    final Widget body = _buildBody();

    return new Scaffold(appBar: appBar, body: body);
  }
}
