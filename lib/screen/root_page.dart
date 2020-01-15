import 'package:fastchat_0_2/firebase/auth/base_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
//  RootPage({this.auth})

//  final BaseAuth auth;
  final BaseAuth auth = new Auth();

  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  void initState() {
//    super.initState();
////    widget.auth.signInPhone("+79376977289");
////    widget.auth.signInPhone("+79376906348");
//    widget.auth.getCurrentUser().then((user) {
//      setState(() {
//        if (user != null) {
//          _userId = user?.uid;
//        }
//        authStatus =
//        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
//      });
//    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return buildWaitingScreen();
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return HomePage(
//            userId: _userId,
//            auth: widget.auth,
          );
        }
        return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}