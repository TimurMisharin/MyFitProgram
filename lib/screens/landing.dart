import "package:flutter/material.dart";
import './auth.dart';
import './home.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = true;

    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}
