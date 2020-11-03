import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_fit_program/domain/myUser.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<MyUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return MyUser.fromFireBase(user);
    } catch (e) {
      print('signInWithEmailAndPassword: ' + e);
      return null;
    }
  }

  Future<MyUser> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return MyUser.fromFireBase(user);
    } catch (e) {
      print('signInWithEmailAndPassword: ' + e);
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<MyUser> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User user) => user != null ? MyUser.fromFireBase(user) : null);
  }
}
