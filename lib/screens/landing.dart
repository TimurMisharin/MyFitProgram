import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/myUser.dart';
import '../screens/auth.dart';
import '../screens/home.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<MyUser>(context);
    final bool isLoggedIn = user != null;

    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}
