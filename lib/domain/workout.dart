class Workout {
  String title;
  String author;
  String description;
  String level;

  Workout({this.title, this.author, this.description, this.level});
}

//All workout plan
class WorkoutSchedule {
  List<WorkoutWeek> weeks;
  WorkoutSchedule({this.weeks});

  //deep copy - for modify exist objects
  WorkoutSchedule copy() {
    var copiedWeeks = weeks.map((w) => w.copy()).toList();
    return WorkoutSchedule(weeks: copiedWeeks);
  }
}

class WorkoutWeek {
  String notes;
  List<WorkoutWeekDay> days;

  WorkoutWeek({this.days, this.notes});

  WorkoutWeek copy() {
    var copiedDays = days.map((d) => d.copy()).toList();

    return WorkoutWeek(days: copiedDays, notes: notes);
  }

  int get daysWithDrills =>
      days != null ? days.where((d) => d.isSet).length : 0;
}

class WorkoutWeekDay {
  String notes;
  List<WorkoutDrillsBlock> drillBlocks;

  bool get isSet => drillBlocks != null && drillBlocks.length > 0;
  int get notRestDrillBlocksCount =>
      isSet ? drillBlocks.where((b) => !(b is WorkoutDrillsBlock)).length : 0;

  WorkoutWeekDay({this.drillBlocks, this.notes});

  WorkoutWeekDay copy() {
    var copiedBlocks = drillBlocks.map((w) => w.copy()).toList();
    return WorkoutWeekDay(notes: notes, drillBlocks: copiedBlocks);
  }
}

class WorkoutDrill {
  String title;
  String weigth;
  int sets;
  int reps;

  WorkoutDrill({this.title, this.weigth, this.sets, this.reps});

  WorkoutDrill copy() {
    return WorkoutDrill(title: title, weigth: weigth, sets: sets, reps: reps);
  }
}

//accepted type of training
enum WorkoutDrillType { SINGLE, MULTISET, AMRAP, ForTime, EMOM }

abstract class WorkoutDrillsBlock {
  WorkoutDrillType type;
  List<WorkoutDrill> drills;

  WorkoutDrillsBlock({this.type, this.drills});

  void changeDrillsCount(int count) {
    var diff = count - drills.length;

    if (diff == 0) {
      return;
    }

    if (diff < 0) {
      drills = drills.sublist(0, drills.length + diff);
      return;
    }

    if (diff > 0) {
      for (int i = 0; i < diff; i++) {
        drills.add(WorkoutDrill());
      }
      return;
    }
  }

  WorkoutDrillsBlock copy();

  List<WorkoutDrill> copyDrills() {
    return drills.map((w) => w.copy()).toList();
  }
}

//Single workout
class WorkoutSingleDrillBlock extends WorkoutDrillsBlock {
  WorkoutSingleDrillBlock(WorkoutDrill drill)
      : super(type: WorkoutDrillType.SINGLE, drills: [drill]);

  WorkoutSingleDrillBlock copy() {
    return WorkoutSingleDrillBlock(copyDrills()[0]);
  }
}

//2 and more workout
class WorkoutMultisetDrillBlock extends WorkoutDrillsBlock {
  WorkoutMultisetDrillBlock(List<WorkoutDrill> drills)
      : super(type: WorkoutDrillType.MULTISET, drills: drills);

  WorkoutMultisetDrillBlock copy() {
    return WorkoutMultisetDrillBlock(copyDrills());
  }
}

//number of workouts per some minutes
class WorkoutAmrapDrillBlock extends WorkoutDrillsBlock {
  int minutes;
  WorkoutAmrapDrillBlock({this.minutes, List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.AMRAP, drills: drills);

  WorkoutAmrapDrillBlock copy() {
    return WorkoutAmrapDrillBlock(minutes: minutes, drills: copyDrills());
  }
}

class WorkoutForTimeDrillBlock extends WorkoutDrillsBlock {
  int timeCapMin;
  int rounds;
  int restBetweenRoundsMin;

  WorkoutForTimeDrillBlock(
      {this.timeCapMin,
      this.rounds,
      this.restBetweenRoundsMin,
      List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.ForTime, drills: drills);

  WorkoutForTimeDrillBlock copy() {
    return WorkoutForTimeDrillBlock(
        timeCapMin: timeCapMin,
        rounds: rounds,
        restBetweenRoundsMin: restBetweenRoundsMin,
        drills: copyDrills());
  }
}

class WorkoutEmomDrillBlick extends WorkoutDrillsBlock {
  int timeCapMin;
  int intervalMin;

  WorkoutEmomDrillBlick(
      {this.timeCapMin, this.intervalMin, List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.EMOM, drills: drills);
  WorkoutEmomDrillBlick copy() {
    return WorkoutEmomDrillBlick(
        timeCapMin: timeCapMin, intervalMin: intervalMin, drills: copyDrills());
  }
}

class WorkoutRestDrillBlock extends WorkoutDrillsBlock {
  int timeMin;

  WorkoutRestDrillBlock({this.timeMin})
      : super(type: WorkoutDrillType.EMOM, drills: []);

  WorkoutRestDrillBlock copy() {
    return WorkoutRestDrillBlock(timeMin: timeMin);
  }
}
