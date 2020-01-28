import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Chat {
  String key;
  String name;
  ListView chats;

  Chat();

  Chat.fromSnapshot(String key, DataSnapshot snapshot) :
        key = key,
        name = snapshot.value["name"];

  toJson() {
    return {
      "key":  key,
      "name": name,
    };
  }
}
