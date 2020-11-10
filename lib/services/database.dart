import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fit_program/domain/workout.dart';

class DatabaseService {
  //first collection: workoutsSchedules save all workout data
  //second collection: workouts save data for display in workout page
  final CollectionReference _workoutCollection =
      FirebaseFirestore.instance.collection('workouts');

  final CollectionReference _workoutSchedulesCollection =
      FirebaseFirestore.instance.collection('workoutsSchedules');

  Future addOrUpdateWorkout(WorkoutSchedule schedule) async {
    //to save in second collection with same id
    DocumentReference workoutRef = _workoutCollection.doc(schedule.uid);

    return workoutRef.set(schedule.toWorkoutMap()).then((_) async {
      //save collection with same id
      var docId = workoutRef.id;
      await _workoutSchedulesCollection.doc(docId).set(schedule.toMap());
    });
  }

  Stream<List<Workout>> getWorkouts({String level, String author}) {
    //filter by author or if fit is public
    Query query = author != null
        ? _workoutCollection.where('author', isEqualTo: author)
        : _workoutCollection.where('isOnline', isEqualTo: true);

    if (level != null) {
      query = query.where('level', isEqualTo: level);
    }

    //take from firebase current state of collections
    return query.snapshots().map(
          (QuerySnapshot data) => data.docs
              .map(
                (DocumentSnapshot document) => Workout.fromJson(
                  document.id,
                  document.data(),
                ),
              )
              .toList(),
        );
  }
}
