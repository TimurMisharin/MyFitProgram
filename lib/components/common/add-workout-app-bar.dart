import 'package:flutter/material.dart';

import 'save-button.dart';
import 'app-bar-title-text.dart';

class AddWorkoutAppBar extends StatelessWidget with PreferredSizeWidget {
  final String titleText;
  final Function onPressCallback;

  AddWorkoutAppBar({@required this.titleText, @required this.onPressCallback});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppBarTitleText(this.titleText),
      actions: <Widget>[
        SaveButton(
          onPressed: onPressCallback,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
