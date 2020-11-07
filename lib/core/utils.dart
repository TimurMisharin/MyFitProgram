import 'package:my_fit_program/domain/workout.dart';

isNumeric(string) =>
    string != null && int.tryParse(string.toString().trim()) != null;

cleanInt(string) => int.parse(string.toString().trim());

bool canSelectDrillsCount(WorkoutDrillsBlock block) =>
    !(block is WorkoutRestDrillBlock || block is WorkoutSingleDrillBlock);

bool isMultisetWorkout(WorkoutDrillsBlock block) =>
    block is WorkoutMultisetDrillBlock;
