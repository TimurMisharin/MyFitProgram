import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class AppBarTitleText extends StatelessWidget {
  final String titleText;

  AppBarTitleText(this.titleText);

  @override
  Widget build(BuildContext context) {
    return Text('My Fit Program // ${this.titleText}');
  }
}
