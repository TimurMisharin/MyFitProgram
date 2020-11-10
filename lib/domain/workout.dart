class Workout {
  String uid;
  String title;
  String author;
  String description;
  String level;
  bool isOnline;

  Workout({this.uid, this.title, this.author, this.description, this.level});

  Workout.fromJson(String uid, Map<String, dynamic> data) {
    uid = uid;
    title = data['title'];
    author = data['author'];
    description = data['description'];
    level = data['level'];
  }
}

class WorkoutSchedule {
  String uid;
  String title;
  String author;
  String description;
  String level;

  List<WorkoutWeek> weeks;

  WorkoutSchedule(
      {this.uid,
      this.author,
      this.title,
      this.level,
      this.description,
      this.weeks});

  WorkoutSchedule copy() {
    var copiedWeeks = weeks.map((w) => w.copy()).toList();
    return WorkoutSchedule(weeks: copiedWeeks);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "level": level,
      "author": author,
      "weeks": weeks.map((w) => w.toMap()).toList()
    };
  }

  Map<String, dynamic> toWorkoutMap() {
    return {
      "title": title,
      "description": description,
      "level": level,
      "author": author,
      "isOnline": true,
      "createdOn": DateTime.now().millisecondsSinceEpoch
    };
  }
}

class WorkoutWeek {
  String notes;
  List<WorkoutWeekDay> days;

  int get daysWithDrills =>
      days != null ? days.where((d) => d.isSet).length : 0;

  WorkoutWeek({this.days, this.notes});

  WorkoutWeek copy() {
    var copiedDays = days.map((w) => w.copy()).toList();

    return WorkoutWeek(days: copiedDays, notes: notes);
  }

  Map<String, dynamic> toMap() {
    return {"notes": notes, "days": days.map((w) => w.toMap()).toList()};
  }
}

class WorkoutWeekDay {
  String notes;
  List<WorkoutDrillsBlock> drillBlocks;

  bool get isSet => drillBlocks != null && drillBlocks.length > 0;
  int get notRestDrillBlocksCount => isSet
      ? drillBlocks.where((b) => !(b is WorkoutRestDrillBlock)).length
      : 0;

  WorkoutWeekDay({this.drillBlocks, this.notes});

  WorkoutWeekDay copy() {
    var copiedBlocks = drillBlocks.map((w) => w.copy()).toList();
    return WorkoutWeekDay(notes: notes, drillBlocks: copiedBlocks);
  }

  Map<String, dynamic> toMap() {
    return {
      "notes": notes,
      "drillBlocks": drillBlocks.map((w) => w.toMap()).toList()
    };
  }
}

class WorkoutDrill {
  String title;
  String weight;
  int sets;
  int reps;

  WorkoutDrill({this.title, this.weight, this.sets, this.reps});

  WorkoutDrill copy() {
    return WorkoutDrill(title: title, weight: weight, sets: sets, reps: reps);
  }

  Map<String, dynamic> toMap() {
    return {"title": title, "weight": weight, "sets": sets, "reps": reps};
  }
}

enum WorkoutDrillType {
  SINGLE,
  MULTISET,
  AMRAP,
  ForTime,
  EMOM,
  REST
  //TABATA
}

abstract class WorkoutDrillsBlock {
  WorkoutDrillType type;
  List<WorkoutDrill> drills;

  WorkoutDrillsBlock({this.type, this.drills});

  void changeDrillsCount(int count) {
    var diff = count - drills.length;

    if (diff == 0) return;

    if (diff > 0) {
      for (int i = 0; i < diff; i++) {
        drills.add(WorkoutDrill());
      }
    } else {
      drills = drills.sublist(0, drills.length + diff);
    }
  }

  WorkoutDrillsBlock copy();
  Map<String, dynamic> toMapParams();

  Map<String, dynamic> toMap() {
    var mainMap = {
      "type": type.toString(),
      "drills": drills.map((w) => w.toMap()).toList()
    };

    return {}..addAll(mainMap)..addAll(toMapParams());
  }

  List<WorkoutDrill> copyDrills() {
    return drills.map((w) => w.copy()).toList();
  }
}

class WorkoutSingleDrillBlock extends WorkoutDrillsBlock {
  WorkoutSingleDrillBlock(WorkoutDrill drill)
      : super(type: WorkoutDrillType.SINGLE, drills: [drill]);

  WorkoutSingleDrillBlock copy() {
    return WorkoutSingleDrillBlock(copyDrills()[0]);
  }

  Map<String, dynamic> toMapParams() {
    return {};
  }
}

class WorkoutMultisetDrillBlock extends WorkoutDrillsBlock {
  WorkoutMultisetDrillBlock(List<WorkoutDrill> drill)
      : super(type: WorkoutDrillType.MULTISET, drills: drill);

  WorkoutMultisetDrillBlock copy() {
    return WorkoutMultisetDrillBlock(copyDrills());
  }

  Map<String, dynamic> toMapParams() {
    return {};
  }
}

class WorkoutAmrapDrillBlock extends WorkoutDrillsBlock {
  int minutes;

  WorkoutAmrapDrillBlock({this.minutes, List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.AMRAP, drills: drills);

  WorkoutAmrapDrillBlock copy() {
    return WorkoutAmrapDrillBlock(minutes: minutes, drills: copyDrills());
  }

  Map<String, dynamic> toMapParams() {
    return {"minutes": minutes};
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

  Map<String, dynamic> toMapParams() {
    return {
      "timeCapMin": timeCapMin,
      "rounds": rounds,
      "restBetweenRoundsMin": restBetweenRoundsMin
    };
  }
}

class WorkoutEmomDrillBlock extends WorkoutDrillsBlock {
  int timeCapMin;
  int intervalMin;

  WorkoutEmomDrillBlock(
      {this.timeCapMin, this.intervalMin, List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.EMOM, drills: drills);

  WorkoutEmomDrillBlock copy() {
    return WorkoutEmomDrillBlock(
        timeCapMin: timeCapMin, intervalMin: intervalMin, drills: copyDrills());
  }

  Map<String, dynamic> toMapParams() {
    return {"timeCapMin": timeCapMin, "intervalMin": intervalMin};
  }
}

class WorkoutRestDrillBlock extends WorkoutDrillsBlock {
  int timeMin;

  WorkoutRestDrillBlock({this.timeMin})
      : super(type: WorkoutDrillType.REST, drills: []);

  WorkoutRestDrillBlock copy() {
    return WorkoutRestDrillBlock(timeMin: timeMin);
  }

  Map<String, dynamic> toMapParams() {
    return {
      "timeMin": timeMin,
    };
  }
}
