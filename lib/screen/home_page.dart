import 'dart:math';

import 'package:fastchat_0_2/models/chat.dart';
import 'package:fastchat_0_2/models/user.dart';
import 'package:fastchat_0_2/screen/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:fastchat_0_2/firebase/auth/base_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
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
  StreamSubscription<Event> _onChatAddedSubscription;
  List<Chat> _chatsList;
//  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _chatsRef = _database.reference().child('chats');

    Query _userQuery = _chatsRef
        .orderByChild("userId")
        .equalTo(widget.userId);

    _userQuery.once().then((DataSnapshot snapshot){
      if (snapshot.value==null)
        addChatUser();
    });

    _chatsList = new List();
    Query _chatQuery = _chatsRef
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onChatAddedSubscription = _chatQuery.onChildAdded.listen(onEntryAdded);
//    _onTodoChangedSubscription =
//        _todoQuery.onChildChanged.listen(onEntryChanged);
  }

  onEntryAdded(Event event) {
    setState(() {
      _chatsList.add(Chat.fromSnapshot(event.snapshot.key, event.snapshot));
    });
  }

  @override
  void dispose() {
    _onChatAddedSubscription.cancel();
//    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  addChatUser() {
//    if (transactionResult.committed) {
      _chatsRef.push().set(<String, String>{
        "userId": widget.userId,
        "name": "Диспетчер",
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

  Widget __showListChat() {
    if (_chatsList.length > 0) {
      return ListView.builder(
        itemCount: _chatsList.length,
        itemBuilder: (BuildContext context, int index){
          Chat chat = _chatsList[index];
          return ListTile(
            title: Text(
              chat.name,
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LetsChat(chat, widget.userId)),
              );
            },
            trailing: IconButton(
                icon: (true)
                    ? Icon(
                  Icons.done_outline,
                  color: Colors.green,
                  size: 20.0,
                )
                    : Icon(Icons.done, color: Colors.grey, size: 20.0),
                onPressed: () {
//                  updateTodo(_todoList[index]);
                }),
          );
        },
      );
//    return ListTile(
//      title: Row(
//        children: [
//          Expanded(
//            child: Text(
//              chat.name,
//              style: Theme.of(context).textTheme.headline,
//            ),
//          ),
////          Container(
////            decoration: const BoxDecoration(
////                color: Color(0xffddddff)
////            ),
////            padding: const EdgeInsets.all(10.0),
////            child: Text(
////              document["votes"].toString(),
////              style: Theme.of(context).textTheme.display1,
////            ),
////          )
//        ],
//      ),
//      onTap: () {
////        Firestore.instance.runTransaction((transaction) async{
////          DocumentSnapshot freshSnap =
////          await transaction.get(document.reference);
////          await transaction.update(freshSnap.reference, {
////            "votes": freshSnap["votes"] + 1
////          });
////        });
//      },
//    );
    } else {
      return Center(
          child: Text(
            "Welcome. Your list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
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
                widget.auth.signOut();
                Navigator.pushNamed(context, '/');
              }
          ),
        ],
      ),
      body: __showListChat(),
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