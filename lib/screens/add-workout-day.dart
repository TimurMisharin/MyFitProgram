import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../domain/workout.dart';

class AddWorkoutDay extends StatefulWidget {
  final WorkoutWeekDay day;

  AddWorkoutDay({Key key, this.day}) : super(key: key);

  @override
  _AddWorkoutDayState createState() => _AddWorkoutDayState();
}

class _AddWorkoutDayState extends State<AddWorkoutDay> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
