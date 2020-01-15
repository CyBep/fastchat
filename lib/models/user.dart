import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String userId;

  User(this.userId);

  User.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"];

  toJson() {
    return {
      "userId": userId,
    };
  }
}
