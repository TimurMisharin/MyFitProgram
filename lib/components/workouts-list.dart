import 'package:flutter/material.dart';
import '../domain/workout.dart';

class WorkoutsList extends StatefulWidget {
  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {
  @override
  void initState() {
    clearFilter();
    super.initState();
  }

  final workouts = <Workout>[
    Workout(
        title: 'Test1',
        author: 'timur1',
        description: 'Test Workout1',
        level: 'Beginner'),
    Workout(
        title: 'Test2',
        author: 'timur2',
        description: 'Test Workout2',
        level: 'Intermediate'),
    Workout(
        title: 'Test3',
        author: 'timur3',
        description: 'Test Workout3',
        level: 'Advanced'),
    Workout(
        title: 'Test4',
        author: 'timur4',
        description: 'Test Workout4',
        level: 'Beginner'),
    Workout(
        title: 'Test5',
        author: 'timur5',
        description: 'Test Workout5',
        level: 'Intermediate'),
  ];

  var filterHeight = 0.0;
  var filterText = '';
  var filterOnlyMyWorkouts = false;
  var filterTitle = '';
  var filterLevel = 'Any Level';
  var filterTitleController = TextEditingController();

  List<Workout> filter() {
    setState(() {
      filterText = filterOnlyMyWorkouts ? 'My Workouts' : 'All workouts';
      filterText += '/' + filterLevel;
      print(filterTitle);
      if (filterTitle.isNotEmpty) filterText += '/' + filterTitle;
      filterHeight = 0;
    });

    var list = workouts;
    return list;
  }

  List<Workout> clearFilter() {
    setState(() {
      filterText = 'All workouts/Any Level';
      filterOnlyMyWorkouts = false;
      filterTitle = '';
      filterLevel = 'Any Level';
      filterTitleController.clear();
      filterHeight = 0;
    });

    var list = workouts;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var filterInfo = Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      height: 40,
      child: RaisedButton(
        child: Row(
          children: <Widget>[
            Icon(Icons.filter_list),
            Text(
              filterText,
              style: TextStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            filterHeight = (filterHeight == 0.0 ? 280.0 : 0.0);
          });
        },
      ),
    );
    var levelMenuItems = <String>[
      'Any Level',
      'Beginner',
      'Intermediate',
      'Advanced'
    ].map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList();
    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                  title: const Text('Only My Workouts'),
                  value: filterOnlyMyWorkouts,
                  onChanged: (bool val) =>
                      setState(() => filterOnlyMyWorkouts = val)),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Level'),
                items: levelMenuItems,
                value: filterLevel,
                onChanged: (String val) => setState(() => filterLevel = val),
              ),
              TextFormField(
                controller: filterTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (String val) => setState(() => filterTitle = val),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        filter();
                      },
                      child:
                          Text("Apply", style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        clearFilter();
                      },
                      child:
                          Text("Clear", style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: filterHeight,
    );
    var widgetsList = Expanded(
      child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.fitness_center,
                        color: Theme.of(context).textTheme.headline6.color),
                    decoration: BoxDecoration(
                        border: Border(
                            right:
                                BorderSide(width: 1, color: Colors.white24))),
                  ),
                  title: Text(workouts[i].title,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Theme.of(context).textTheme.headline6.color),
                  subtitle: subtitle(context, workouts[i]),
                ),
              ),
            );
          }),
    );

    return Column(children: [
      filterInfo,
      filterForm,
      widgetsList,
    ]);
  }
}

Widget subtitle(BuildContext context, Workout workout) {
  var color = Colors.grey;
  double indicatorLevel = 0;

  switch (workout.level) {
    case 'Beginner':
      color = Colors.green;
      indicatorLevel = 0.33;
      break;
    case 'Intermediate':
      color = Colors.yellow;
      indicatorLevel = 0.66;
      break;
    case 'Advanced':
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
              valueColor: AlwaysStoppedAnimation(color))),
      SizedBox(width: 10),
      Expanded(
          flex: 3,
          child: Text(workout.level,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color)))
    ],
  );
}
