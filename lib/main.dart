import 'package:flutter/material.dart';
import './screens/landing.dart';

//enter to app
void main() => runApp(MyFitProgram());

class MyFitProgram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Fit Program',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(50, 65, 85, 1),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        home: LandingPage());
  }
}
