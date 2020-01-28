import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ChatsToUsers {
  String key;
  String userId;
  String chatsId;

  ChatsToUsers();

  ChatsToUsers.fromSnapshot(String key, DataSnapshot snapshot) :
        key = key,
        userId = snapshot.value["userId"],
        chatsId = snapshot.value["chatsId"];

  toJson() {
    return {
      "key":  key,
      "userId": userId,
      "chatsId": chatsId,
    };
  }
}
