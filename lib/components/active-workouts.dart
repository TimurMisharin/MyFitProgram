import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/common/workout-level.dart';
import '../domain/myUser.dart';
import '../domain/workout.dart';
import '../services/database.dart';

class ActiveWorkouts extends StatelessWidget {
  const ActiveWorkouts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<MyUser>(context);

    return Container(
        alignment: FractionalOffset.center,
        child: user.workoutIds.isEmpty
            ? Text('No active workouts')
            : StreamBuilder<List<Workout>>(
                stream: DatabaseService().getUserWorkouts(user),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Workout>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasError) {
                    children = <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text("Can't load data",
                            style: TextStyle(color: Colors.white)),
                      )
                    ];
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.done:
                        children = <Widget>[
                          SizedBox(
                            child: const CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting data...',
                                style: TextStyle(color: Colors.white)),
                          )
                        ];
                        break;
                      case ConnectionState.active:
                        var workouts = snapshot.data;
                        children = <Widget>[
                          Expanded(
                            child: ListView.builder(
                                itemCount: workouts.length,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () {
                                      //Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => WorkoutDetails(id:workouts[i].id)));
                                    },
                                    child: Card(
                                      key: Key(workouts[i].id),
                                      elevation: 2.0,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                50, 65, 85, 0.9)),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          leading: Container(
                                            padding: EdgeInsets.only(right: 12),
                                            child: Icon(Icons.fitness_center,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .color),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Colors.white24))),
                                          ),
                                          title: Text(workouts[i].title,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .color,
                                                  fontWeight: FontWeight.bold)),
                                          trailing: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .color),
                                          subtitle: WorkoutLevel(
                                              level: workouts[i].level),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ];
                        break;
                    }
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  );
                },
              ));
  }
}
