import 'package:flutter/material.dart';
import 'package:otakolist_app/widget/textform.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 36, 16, 36),
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            child: FlatButton(
              child: Text(
                'Voltar',
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            padding: EdgeInsets.all(26),
            child: FieldForm(
              label: 'E-Mail',
              hint: 'Digite seu e-mail',
              icon: Icon(Icons.email),
              textInputType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (text) {
                if (text.isEmpty || !text.contains('@')) {
                  return 'E-Mail Invalido!';
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(26.0),
            child: FieldForm(
              label: 'Senha',
              hint: 'Digite sua senha',
              icon: Icon(Icons.vpn_key),
              textInputType: TextInputType.text,
              obscureText: true,
              controller: _passwordController,
              validator: (text) {
                if (text.isEmpty || text.length < 6) {
                  return 'Senha Invalida!';
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 32, right: 32, top: 22),
            child: RaisedButton(
              child: Text('Registrar'),
              color: Colors.orangeAccent,
              textColor: Colors.white,
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
