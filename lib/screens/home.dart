import 'package:flutter/material.dart';
import '../domain/workout.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text('My Fit Program'),
          leading: Icon(Icons.fitness_center),
        ),
        body: WorkoutsList(),
      ),
    );
  }
}

class WorkoutsList extends StatelessWidget {
  final workouts = <Workout>[
    Workout(
        title: 'test1',
        author: 'Timur1',
        description: 'test workout1',
        level: 'low'),
    Workout(
        title: 'test2',
        author: 'Timur2',
        description: 'test workout2',
        level: 'medium'),
    Workout(
        title: 'test3',
        author: 'Timur3',
        description: 'test workout3',
        level: 'high'),
    Workout(
        title: 'test4',
        author: 'Timur4',
        description: 'test workout4',
        level: 'low'),
    Workout(
        title: 'test5',
        author: 'Timur5',
        description: 'test workout5',
        level: 'low'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(50, 65, 85, 0.9),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.fitness_center_sharp,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                      right: BorderSide(
                        width: 1,
                        color: Colors.white24,
                      ),
                    )),
                  ),
                  title: Text(
                    workouts[index].title,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  subtitle: subtitle(context, workouts[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget subtitle(BuildContext context, Workout workout) {
  var color = Colors.grey;
  double indicatorLevel = 0;
  switch (workout.level) {
    case 'low':
      color = Colors.green;
      indicatorLevel = 0.33;
      break;
    case 'medium':
      color = Colors.yellow;
      indicatorLevel = 0.66;
      break;
    case 'high':
      color = Colors.red;
      indicatorLevel = 1;
      break;
  }

  return Row(
    children: <Widget>[
      Expanded(
        flex: 1,
        child: LinearProgressIndicator(
          backgroundColor: Theme.of(context).textTheme.headline6.color,
          value: indicatorLevel,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        flex: 3,
        child: Text(
          workout.level,
          style: TextStyle(
            color: Theme.of(context).textTheme.headline6.color,
          ),
        ),
      )
    ],
  );
}
