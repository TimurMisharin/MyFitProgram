import 'package:flutter/material.dart';

import '../components/common/add-workout-app-bar.dart';
import '../core/constants.dart';
import '../domain/workout.dart';
import './add-workout-day.dart';

class AddWorkoutWeek extends StatefulWidget {
  final WorkoutWeek week;
  AddWorkoutWeek({Key key, this.week}) : super(key: key);
  @override
  _AddWorkoutWeekState createState() => _AddWorkoutWeekState();
}

class _AddWorkoutWeekState extends State<AddWorkoutWeek> {
  var week = WorkoutWeek();

  @override
  void initState() {
    if (widget.week != null && widget.week.days.length == 7) {
      week = widget.week.copy();
    } else {
      week.days = [
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
      ];
    }
    super.initState();
  }

  void _saveWorkout() {
    Navigator.of(context).pop(week);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddWorkoutAppBar(
          titleText: 'Create Week Plan', onPressCallback: _saveWorkout),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(color: bgColorWhite),
        child: ListView.builder(
          itemCount: week.days.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                onTap: () async {
                  var day = week.days[index];
                  var newDay = await Navigator.push<WorkoutWeekDay>(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => AddWorkoutDay(day: day)));
                  if (newDay != null) {
                    setState(() {
                      week.days[index] = newDay;
                    });
                  }
                },
                child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12),
                      child: week.days[index].isSet
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.hourglass_empty,
                              color: Colors.blue,
                            ),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      'Day ${index + 1} - ' +
                          (week.days[index].isSet
                              ? '${week.days[index].notRestDrillBlocksCount} drills'
                              : 'Rest Day'),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
