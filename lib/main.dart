import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './domain/myUser.dart';
import './services/auth.dart';
import './screens/landing.dart';
import './core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyFitProgram());
}

class MyFitProgram extends StatefulWidget {
  @override
  _MyFitProgramState createState() => _MyFitProgramState();
}

class _MyFitProgramState extends State<MyFitProgram> {
  //stream for auth user from firebase
  StreamSubscription<MyUser> userStreamSubscription;
  //more data for user from firebase
  Stream<MyUser> userDataStream;


  StreamSubscription<MyUser> setUserDataStream() {
    final auth = AuthService();
    // subscription for user for first stream
    return auth.currentUser.listen((user) {
      //add more data from second stream
      userDataStream = auth.getCurrentUserWithData(user);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    userStreamSubscription = setUserDataStream();
  }

  @override
  void dispose() {
    super.dispose();
    userStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: userDataStream,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Max Fitness',
          theme: ThemeData(
              primaryColor: bgColorPrimary,
              textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
          home: LandingPage()),
    );
  }
}
