import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/workout.dart';
import '../domain/myUser.dart';

class DatabaseService {
  //first collection: workoutsSchedules save all workout data
  //second collection: workouts save data for display in workout page
  final CollectionReference _workoutCollection =
      FirebaseFirestore.instance.collection('workouts');

  final CollectionReference _workoutSchedulesCollection =
      FirebaseFirestore.instance.collection('workoutsSchedules');

  final CollectionReference _userDataCollection =
      FirebaseFirestore.instance.collection("userData");

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
          (QuerySnapshot data) => data?.docs
              .map(
                (DocumentSnapshot document) => Workout.fromJson(
                  document.data(),
                  id: document.id,
                ),
              )
              .toList(),
        );
  }

  Future<WorkoutSchedule> getWorkout(String id) async {
    var doc = await _workoutSchedulesCollection.doc(id).get();
    return WorkoutSchedule.fromJson(doc.id, doc.data());
  }

  // User Data
  Future updateUserData(MyUser user) async {
    final userData = user.userData.toMap();
    await _userDataCollection.doc(user.id).set(userData);
  }

  Future addUserWorkout(MyUser user, WorkoutSchedule workout) async {
    var userWorkout = UserWorkout.fromWorkout(workout);
    user.userData.addUserWorkout(userWorkout);
    await updateUserData(user);
  }

  Stream<List<Workout>> getUserWorkouts(MyUser user) {
    var query = _workoutCollection.where(FieldPath.documentId,
        whereIn: user.workoutIds);

    return query.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => Workout.fromJson(doc.data(), id: doc.id))
        .toList());
  }
}
