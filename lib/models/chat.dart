import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Chat {
  String userId;
  String name;
  ListView chats;

  Chat(value);

  Chat.fromSnapshot(DataSnapshot snapshot) :
        userId = snapshot.value["userId"],
        name = snapshot.value["name"];

  toJson() {
    return {
      "userId": userId,
      "name": name,
    };
  }
}
