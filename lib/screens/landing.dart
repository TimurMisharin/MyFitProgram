import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../domain/myUser.dart';
import './auth.dart';
import './home.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<MyUser>(context);
    final bool isLoggedIn = user != null;

    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}
