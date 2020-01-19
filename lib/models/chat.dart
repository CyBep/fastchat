import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Chat {
  String key;
  String userId;
  String name;
  ListView chats;

  Chat();

  Chat.fromSnapshot(String key, DataSnapshot snapshot) :
        key = key,
        userId = snapshot.value["userId"],
        name = snapshot.value["name"];

  toJson() {
    return {
      "key":  key,
      "userId": userId,
      "name": name,
    };
  }
}
