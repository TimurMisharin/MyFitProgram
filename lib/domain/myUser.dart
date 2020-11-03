import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String id;

  MyUser.fromFireBase(User user) {
    this.id = user.uid;
  }
}
