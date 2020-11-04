import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_fit_program/domain/myUser.dart';
import 'package:my_fit_program/services/auth.dart';
import 'package:provider/provider.dart';
import './screens/landing.dart';
import './domain/myUser.dart';

//enter to app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyFitProgram());
}

class MyFitProgram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
          title: 'My Fit Program',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(50, 65, 85, 1),
            textTheme: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          home: LandingPage()),
    );
  }
}
