import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../components/workouts-list.dart';
import '../components/active-workouts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _navigationBar = CurvedNavigationBar(
      items: const <Widget>[
        Icon(Icons.fitness_center),
        Icon(Icons.search),
      ],
      index: 0,
      height: 50,
      color: Colors.white.withOpacity(0.5),
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(0.5),
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 500),
      onTap: (int index) {
        setState(() {
          _sectionIndex = index;
        });
      },
    );

    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            'My Fit Program // ' +
                (_sectionIndex == 0 ? 'Active Workouts' : 'Find Workouts'),
          ),
          leading: Icon(Icons.fitness_center),
        ),
        body: _sectionIndex == 0 ? ActiveWorkouts() : WorkoutsList(),
        bottomNavigationBar: _navigationBar,
      ),
    );
  }
}
