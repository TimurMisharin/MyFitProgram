import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/myUser.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final CollectionReference _userDataCollection =
      FirebaseFirestore.instance.collection("userData");

  Future<MyUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      var user = MyUser.fromFirebase(firebaseUser);

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<MyUser> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      var user = MyUser.fromFirebase(firebaseUser);
      var userData = UserData();
      await _userDataCollection.doc(user.id).set(userData.toMap());

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<MyUser> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User user) => user != null ? MyUser.fromFirebase(user) : null);
  }

  Stream<MyUser> getCurrentUserWithData(MyUser user) {
    //return other stream from userDataCollection
    // ? is for null check
    return _userDataCollection.doc(user?.id).snapshots().map((snapshot) {
      if (snapshot?.data == null) return null;
      var userData = UserData.fromJson(snapshot.id, snapshot.data());
      user.setUserData(userData);
      return user;
    });
  }
}
