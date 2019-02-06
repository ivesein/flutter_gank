import 'package:flutter/material.dart';
import 'dart:async';
import '../values/strings.dart';
import '../model/category_info.dart';
import '../util/data_util.dart';

class SubmitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  Timer _time;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _url = '';
  String _desc = '';
  String _nickname = '';
  String _category = 'Android';

  void _onSubmit(BuildContext context) async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      Map<String, String> params = {
        'url': _url,
        'desc': _desc,
        'who': _nickname,
        'type': _category,
        'debug': 'true',
      };
      await DataUtil.submit(params).then((result) {
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text(result.msg)));

        Duration duration = new Duration(milliseconds: 1500);
        _time = new Timer(duration, () {
          if (!result.error) Navigator.of(context).pop();
        });
      });
    }
  }

  DropdownMenuItem<String> _buildCatrgoeyItems(CategoryInfo info) =>
      new DropdownMenuItem(value: info.name, child: new Text(info.name));

  Widget _buildDivider() => new SizedBox(height: 16.0);

  Widget _buildBody() => new Form(
      key: _formKey,
      child: new Container(
          margin: const EdgeInsets.all(16.0),
          child: new ListView(children: <Widget>[
            new TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: StringValus.TEXT_FILED_URL_HINT_TEXT,
                    labelText: StringValus.TEXT_FILED_URL_LABEL_TEXT),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                validator: (value) => value.isEmpty
                    ? StringValus.TEXT_FIELD_URL_EMPTY_TEXT
                    : null,
                onSaved: (value) => this._url = value),
            _buildDivider(),
            new TextFormField(
                decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: StringValus.TEXT_FILED_DESC_HINT_TEXT,
                    labelText: StringValus.TEXT_FILED_DESC_LABEL_TEXT),
                textInputAction: TextInputAction.next,
                validator: (value) => value.isEmpty
                    ? StringValus.TEXT_FIELD_DESC_EMPTY_TEXT
                    : null,
                onSaved: (value) => this._desc = value),
            _buildDivider(),
            new TextFormField(
                maxLength: 15,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: StringValus.TEXT_FILED_NICKNAME_HINT_TEXT,
                    labelText: StringValus.TEXT_FILED_NICKNAME_LABEL_TEXT),
                textInputAction: TextInputAction.next,
                validator: (value) => value.isEmpty
                    ? StringValus.TEXT_FIELD_NICKNAME_EMPTY_TEXT
                    : null,
                onSaved: (value) => this._nickname = value),
            _buildDivider(),
            new DropdownButtonFormField<String>(
                value: _category,
                decoration:
                    const InputDecoration(border: const OutlineInputBorder()),
                items: categorys
                    .sublist(1, categorys.length - 1)
                    .map(_buildCatrgoeyItems)
                    .toList(),
                onChanged: (value) => setState(() => this._category = value))
          ])));

  @override
  void dispose() {
    super.dispose();
    _time?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Widget appBar = new AppBar(
        leading: const BackButton(), title: const Text(StringValus.POST_GANK));

    final Widget body = _buildBody();

    final Widget actionButton = new FloatingActionButton(
        child: const Icon(Icons.send), onPressed: () => _onSubmit(context));

    return Scaffold(
        key: _scaffoldKey,
        appBar: appBar,
        body: body,
        floatingActionButton: actionButton);
  }
}
