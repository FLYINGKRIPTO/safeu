import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String userName;
  String photoUrl;
  String email;

  User(this.userName, this.photoUrl, this.email);

  User.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      userName = snapshot.value["username"],
      photoUrl  = snapshot.value["user_photoUrl"],
      email = snapshot.value["user_email"];

  toJson() {
    return {
      "username" : userName,
      "user_photoUrl" : photoUrl,
      "user_email" : email,
    } ;
  }
}
