import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class CreateAccountForm extends StatelessWidget {
  CreateAccountForm(this.setNewAccount, this.onSubmit);

  final Function setNewAccount;
  final Function onSubmit;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _passCtrl = new TextEditingController();
  final TextEditingController _pass2Ctrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).account;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: dic['create.name'],
                labelText: dic['create.name'],
              ),
              controller: _nameCtrl,
              validator: (v) {
                return v.trim().length > 0 ? null : dic['create.name.error'];
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: dic['create.password'],
                labelText: dic['create.password'],
              ),
              controller: _passCtrl,
              validator: (v) {
                return Fmt.checkPassword(v.trim())
                    ? null
                    : dic['create.password.error'];
              },
              obscureText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: dic['create.password2'],
                labelText: dic['create.password2'],
              ),
              controller: _pass2Ctrl,
              obscureText: true,
              validator: (v) {
                return _passCtrl.text != v
                    ? dic['create.password2.error']
                    : null;
              },
            ),
          ),
          Expanded(child: Container()),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: RoundedButton(
              text: I18n.of(context).home['next'],
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setNewAccount(_nameCtrl.text, _passCtrl.text);
                  onSubmit();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
