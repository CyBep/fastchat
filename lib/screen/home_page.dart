import 'dart:math';

import 'package:fastchat_0_2/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fastchat_0_2/firebase/auth/base_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId})
      : super(key: key);

  final BaseAuth auth;
////  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _counterRef;
  DatabaseReference _chatsRef;
//  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _chatsRef = _database.reference().child('chats');
//    User currentUser = new User(widget.userId);
    print(widget.userId);
//    print(currentUser);
    Query _userQuery = _chatsRef
        .orderByChild("userId")
        .equalTo(widget.userId);

    print("test");
    _userQuery.onValue.isEmpty.then((bool value){
      print(value);
      if (!value)
        addChatUser();
    });
    print("test2");

//        .then((DataSnapshot value) {
//      print("test2");
//      print(value);
//    });
//    _userQuery.once().then((DataSnapshot value) {
//      print("test2");
//      print(value);
//    });
//
//    _userQuery.once().then((onValue) {
//      print("test");
//    });
  }

  @override
  void dispose() {
//    _onTodoAddedSubscription.cancel();
//    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  addChatUser() {
//    if (transactionResult.committed) {
      _chatsRef.push().set(<String, String>{
        "userId": widget.userId,
        "messeges": "",
      }).then((_) {
        print('Transaction  committed.');
      });
//    } else {
//      print('Transaction not committed.');
//      if (transactionResult.error != null) {
//        print(transactionResult.error.message);
//      }
//    }
  }

  final _textEditingController = TextEditingController();
  showAddChat(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: new InputDecoration(
                        labelText: "Создать чат",
                      ),
                    )
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Отмена")
              ),
              new FlatButton(
                  onPressed: () {
//                    addChat(_textEditingController.text.toString());
                    Navigator.pop(context);
                  },
                  child: const Text("Создать")
              )
            ],
          );
        }
    );
  }
  addNewTodo(String todoItem) {
    if (todoItem.length > 0) {
//      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
//      _database.reference()
//          .child("todo")
//          .push()
//          .set(todo.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("FastChat"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: (){
//                widget.auth.signOut();
              }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddChat(context);
        },
        tooltip: "Добавить чат",
        child: Icon(Icons.add),
      ),
    );
  }
}