import 'package:flutter/material.dart';
import 'package:fastchat_0_2/services/authentication.dart';

class LoginSignUpPhone extends StatefulWidget {
  LoginSignUpPhone({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _LoginSignUpPhone createState() => _LoginSignUpPhone();
}

class _LoginSignUpPhone extends State<LoginSignUpPhone> {
  String _phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ваш Телефон"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _phoneForm()
          ],
        ),
      ),
    );
  }

  Widget _phoneForm() {
    return ListTile(
      leading: Icon(Icons.phone),
      title: TextField(
        decoration: InputDecoration(
          labelText: "Номер телефона"
        ),
        keyboardType: TextInputType.phone,
        onChanged: (value) => _phone = value,
      ),
    );
  }
}