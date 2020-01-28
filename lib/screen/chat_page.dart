import 'dart:async';

import 'package:fastchat_0_2/models/chat.dart';
import 'package:fastchat_0_2/screen/templates_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//void main() => runApp(MaterialApp(home: LetsChat()));
//
class Session {
  static bool isSelectMode = false;
}

class LetsChat extends StatefulWidget {
  Chat _chat;
  final String userId;

  LetsChat(this._chat, this.userId);

  @override
  _LetsChatState createState() => _LetsChatState();
}

class _LetsChatState extends State<LetsChat> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _messegesRef;

  StreamSubscription<Event> _onMessagesAddedSubscription;
  StreamSubscription<Event> _onMessagesChangedSubscription;

  TextEditingController _textEditingController = TextEditingController();
  StreamController<List<Message>> messages = StreamController();

  ScrollController scrollController = ScrollController();

  List<Message> list = [];
  List<String> _stringTemplate = [];

  @override
  void initState() {
    _messegesRef = _database.reference().child('chats').child(widget._chat.key).child("messeges");

    _onMessagesAddedSubscription = _messegesRef.onChildAdded.listen(onEntryAdded);
    _onMessagesChangedSubscription = _messegesRef.onChildChanged.listen(onEntryChanged);
    super.initState();
  }

  onEntryAdded(Event event) {
    DataSnapshot snapshot = event.snapshot;
    setState(() {
      list.add(new Message(
          message: snapshot.value["message"],
          userId: snapshot.value["userId"],
          timestamp: snapshot.value["timestamp"],
          type: snapshot.value["userId"] == widget.userId
              ? MessageType.IncomingText
              : MessageType.OutgoingText));
    });
  }

  onEntryChanged(Event event) {
    print(event.snapshot);
    var oldEntry = list.singleWhere((entry) {
      return entry.message == "asd";
    });

    setState(() {
      list[list.indexOf(oldEntry)] =
          Message(message: "asd",
              timestamp: DateTime.now().toString(),
              type: list.length % 2 == 0
                  ? MessageType.IncomingText
                  : MessageType.OutgoingText);
    });
  }

  @override
  void dispose() {
    _onMessagesAddedSubscription.cancel();
    _onMessagesChangedSubscription.cancel();
    messages.close();
    _textEditingController.dispose();
    messages.sink.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._chat.name),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 4.0, bottom: 20.0, left: 4.0, right: 4.0),
        child: StreamBuilder<List<Message>>(
            stream: messages.stream,
            initialData: list,
            builder:
                (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
              return snapshot.hasData
                  ? snapshot.data != null
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (context, index) {
                            return snapshot.data.length == index
                                ? SizedBox(height: 40.0)
                                : TextMessage(message: snapshot.data[index]);
                          },
                          physics: BouncingScrollPhysics(),
                        )
                      : Container()
                  : Container();
            }),
      ),
      bottomSheet: getSendMessageField(),
    );
  }

  sendMessage(message) {
    if (_textEditingController.text.length > 0) {
      _textEditingController.clear();
      Message _message = new Message(
          message: message,
          userId: widget.userId,
          timestamp: DateTime.now().toString());

      _messegesRef.push().set(_message.toJson()).then((_) {
        print('Transaction  committed.');
      }).catchError((_) {
        print(_);
      });
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      });
    }
  }
//  Card(
//  child: TextFormField(
//  controller: controller,
//  autofocus: true,
//  keyboardType: TextInputType.phone,
//  key: Key('EnterPhone-TextFormField'),
//  decoration: InputDecoration(
//  border: InputBorder.none,
//  errorMaxLines: 1,
//  prefix: Text("  " + prefix + "  "),
//  ),
//  ),
//  );
  Widget getSendMessageField() {
    return Row(
      key: Key('sendMessageField'),
      children: <Widget>[
        Expanded(
          key: Key('textField'),
          child: Container(
            margin: EdgeInsets.all(8.0),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TextFormField(
                    controller: _textEditingController,
//                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    showCursor: true,
                    cursorColor: Colors.blue,
                    maxLengthEnforced: false,
                    cursorWidth: 3.0,
                    style: TextStyle(color: Colors.black),
                    onSaved: (String message) {
                      if (message.length != 0) {
                        sendMessage(message);
  //                          _textEditingController.clear();
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Сообщение...',
                    )
                  ),
                )
            ),
          ),
        ),
        CupertinoButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              print("button pressed 2");
              _awaitTemplateData(context);
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => Templates()),
//              );
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.attachment, color: Colors.black26, size: 22.0),
            )),
        CupertinoButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              print("button pressed");
              print(_textEditingController.text);
              sendMessage(_textEditingController.text);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
              child: Icon(Icons.send, color: Colors.white, size: 22.0),
            )),
        SizedBox(width: 10.0)
      ],
    );
  }

  void _awaitTemplateData(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Templates()),
    );

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      _textEditingController.clear();
      _stringTemplate = result;
      int i = 0;
      _stringTemplate.forEach((string) {
        i++;
        print(string);
        if (i == _stringTemplate.length) {
          _textEditingController.text += string;
        } else {
          _textEditingController.text += string+"\n";
        }

      });
//      _textEditingController.text
    });
  }
}

class Message {
  String message, userId, timestamp, timestampValue;
  MessageType type;

  Message({
      this.message,
      this.userId,
      this.timestamp,
      this.timestampValue,
      this.type});

  toJson() {
    return {
      "message": this.message,
      "userId": this.userId,
      "timestamp": this.timestamp,
      "type": this.type,
    };
  }
}

enum MessageType { IncomingText, OutgoingText }

class TextMessage extends StatefulWidget {
  Message message;

  TextMessage({this.message});

  @override
  _TextMessageState createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: selected
            ? Container(color: Colors.blue.withOpacity(0.4), child: child())
            : child(),
        onLongPress: (){
          if(!Session.isSelectMode)
            setState(() {
              Session.isSelectMode = true;
              selected = true;
            });
      },
      onTap: (){
          if(Session.isSelectMode){
            setState(() {
                selected = !selected;
            });
          }
      },
    );
  }

  Widget child() => Align(
        alignment: widget.message.type == MessageType.IncomingText
            ? Alignment.topLeft
            : Alignment.topRight,
        child: Card(
          elevation: 1.5,
          margin: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 3.5, top: 3.5),
          color: widget.message.type == MessageType.IncomingText
              ? Colors.white
              : Color(0xFFDCF8C6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.grey.withOpacity(0.1))),
          child: Container(
            margin: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
            constraints: BoxConstraints(maxWidth: 250.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.message.message,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.message.timestamp,
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
