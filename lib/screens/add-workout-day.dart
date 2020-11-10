import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../components/drill/drill-remove-alert.dart';
import '../components/drill/drill.dart';
import '../components/common/add-workout-app-bar.dart';
import '../components/common/toastr.dart';
import '../core/constants.dart';

import '../domain/workout.dart';

class AddWorkoutDay extends StatefulWidget {
  final WorkoutWeekDay day;
  AddWorkoutDay({Key key, this.day}) : super(key: key);

  @override
  _AddWorkoutDayState createState() => _AddWorkoutDayState();
}

class _AddWorkoutDayState extends State<AddWorkoutDay> {
  WorkoutWeekDay day = WorkoutWeekDay(drillBlocks: []);

  @override
  void initState() {
    if (widget.day != null) {
      day = widget.day.copy();
    }

    if (day.drillBlocks == null || day.drillBlocks.length == 0)
      day.drillBlocks = [WorkoutSingleDrillBlock(WorkoutDrill())];

    super.initState();
  }

  final _fbKey = GlobalKey<FormBuilderState>();
  String _defaultNewDrillType = 'Single Drill';

  var _drillTypeMenuItems = <String>[
    'Rest',
    'Single Drill',
    'Multiset Drill',
    'For Time',
    'AMRAP',
    'EMOM',
  ]
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  void _addDrillsBlock() {
    WorkoutDrillsBlock newBlock;
    switch (_defaultNewDrillType) {
      case 'Single Drill':
        newBlock = WorkoutSingleDrillBlock(WorkoutDrill());
        break;
      case 'Multiset Drill':
        newBlock = WorkoutMultisetDrillBlock([WorkoutDrill(), WorkoutDrill()]);
        break;
      case 'For Time':
        newBlock =
            WorkoutForTimeDrillBlock(drills: [WorkoutDrill(), WorkoutDrill()]);
        break;
      case 'AMRAP':
        newBlock =
            WorkoutAmrapDrillBlock(drills: [WorkoutDrill(), WorkoutDrill()]);
        break;
      case 'EMOM':
        newBlock =
            WorkoutEmomDrillBlock(drills: [WorkoutDrill(), WorkoutDrill()]);
        break;
      case 'Rest':
        newBlock = WorkoutRestDrillBlock();
        break;
    }

    setState(() {
      if (newBlock != null) day.drillBlocks.add(newBlock);
    });
  }

  void _newDrillTypeDialog() {
    var alert = AlertDialog(
      title: Text("Select Drill Type"),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Drill Type'),
              items: _drillTypeMenuItems,
              value: _defaultNewDrillType,
              onChanged: (String val) =>
                  setState(() => _defaultNewDrillType = val),
            ),
          ],
        );
      }),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _addDrillsBlock();
              Navigator.pop(context);
            },
            child: Text('Select')),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel'))
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _saveDayPlan() {
    if (_fbKey.currentState.saveAndValidate()) {
      if (day.drillBlocks.length > 0) {
        print(day.drillBlocks.where((d) => d is WorkoutRestDrillBlock).length);
        if (day.drillBlocks.where((d) => d is WorkoutRestDrillBlock).length ==
            day.drillBlocks.length) {
          buildToastr('Please add at least one Drill');
          return;
        }
      }

      Navigator.of(context).pop(day);
    } else {
      buildToastr('Ooops! Something is not right');
    }
  }

  void _removeDrill(WorkoutDrillsBlock block) {
    setState(() {
      day.drillBlocks.remove(block);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddWorkoutAppBar(
          titleText: 'Create day plan', onPressCallback: _saveDayPlan),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: _newDrillTypeDialog,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: bgColorWhite),
          child: FormBuilder(
            key: _fbKey,
            initialValue: {},
            readOnly: false,
            child: Column(
              children: <Widget>[
                Column(
                    children: day.drillBlocks.map((block) {
                  var index = day.drillBlocks.indexOf(block);
                  return _buildDrillsBlock(index, block);
                }).toList()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "notes",
                    decoration: InputDecoration(
                      labelText: "Notes",
                    ),
                    initialValue: day.notes,
                    onChanged: (dynamic val) {
                      setState(() {
                        day.notes = val;
                      });
                    },
                    validators: [
                      FormBuilderValidators.maxLength(500),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrillsBlock(int blockIndex, WorkoutDrillsBlock block) {
    return Container(
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Container(
          decoration:
              BoxDecoration(color: _getDrillBlockHeaderColor(context, block)),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                title: Row(children: <Widget>[
                  Text(_getDrillBlockHeader(block),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 20),
                  _canSelectDrillsCount(block)
                      ? DropdownButton(
                          items: Iterable<int>.generate(5)
                              .map((val) => DropdownMenuItem(
                                    value: _isMultisetWorkout(block)
                                        ? val + 2
                                        : val + 1,
                                    child: Text(
                                        '${_isMultisetWorkout(block) ? (val + 2) : (val + 1)} Drills'),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              block.changeDrillsCount(val);
                            });
                          },
                          value: block.drills.length,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      : SizedBox.shrink()
                ]),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () async {
                    var result = await showDialog(
                        context: context,
                        builder: (_) => drillRemoveAlert(context));
                    if (result) _removeDrill(block);
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  _buildDrillBlockParams(blockIndex, block),
                  _buildDrills(blockIndex, block)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  isNumeric(string) =>
      string != null && int.tryParse(string.toString().trim()) != null;
  cleanInt(string) => int.parse(string.toString().trim());

  Widget _buildDrills(int blockIndex, WorkoutDrillsBlock block) {
    return Column(
        children: Iterable<int>.generate(block.drills.length)
            .map(
              (ind) => Drill(
                isSingleDrill: block.drills.length <= 1,
                drillBlockIndex: blockIndex,
                index: ind,
                drill: block.drills[ind],
              ),
            )
            .toList());
  }

  Widget _buildDrillBlockParams(int index, WorkoutDrillsBlock block) {
    if (block is WorkoutAmrapDrillBlock) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.minutes == null ? '' : block.minutes.toString(),
                attribute: "minutes_$index",
                decoration: InputDecoration(
                  labelText: "Minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.minutes = cleanInt(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                  FormBuilderValidators.numeric(),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    } else if (block is WorkoutForTimeDrillBlock) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.timeCapMin == null ? '' : block.timeCapMin.toString(),
                attribute: "timeCapMin_$index",
                decoration: InputDecoration(
                  labelText: "Time Cap in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.timeCapMin = cleanInt(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                  FormBuilderValidators.numeric(),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.rounds == null ? '' : block.rounds.toString(),
                attribute: "rounds_$index",
                decoration: InputDecoration(
                  labelText: "Rounds *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.rounds = cleanInt(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                  FormBuilderValidators.numeric(),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue: block.restBetweenRoundsMin == null
                    ? ''
                    : block.restBetweenRoundsMin.toString(),
                attribute: "restBetweenRoundsMin_$index",
                decoration: InputDecoration(
                  labelText: "Rest between rounds in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val))
                    block.restBetweenRoundsMin = cleanInt(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                  FormBuilderValidators.numeric(),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    } else if (block is WorkoutEmomDrillBlock) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.timeCapMin == null ? '' : block.timeCapMin.toString(),
                attribute: "timeCapMin_$index",
                decoration: InputDecoration(
                  labelText: "Time Cap in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.timeCapMin = cleanInt(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                  FormBuilderValidators.numeric(),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue: block.intervalMin == null
                    ? ''
                    : block.intervalMin.toString(),
                attribute: "intervalMin_$index",
                decoration: InputDecoration(
                  labelText: "Interval length in minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.intervalMin = cleanInt(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                  FormBuilderValidators.numeric(),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    } else if (block is WorkoutRestDrillBlock) {
      return Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 4, right: 4),
              child: FormBuilderTextField(
                initialValue:
                    block.timeMin == null ? '' : block.timeMin.toString(),
                attribute: "timeMin_$index",
                decoration: InputDecoration(
                  labelText: "Minutes *",
                ),
                onChanged: (dynamic val) {
                  if (isNumeric(val)) block.timeMin = cleanInt(val);
                },
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(100),
                  FormBuilderValidators.numeric(),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }

  Color _getDrillBlockHeaderColor(
      BuildContext context, WorkoutDrillsBlock block) {
    if (block is WorkoutRestDrillBlock) return Color.fromRGBO(80, 150, 70, 0.9);

    return Color.fromRGBO(50, 65, 85, 0.9);
  }

  String _getDrillBlockHeader(WorkoutDrillsBlock block) {
    if (block is WorkoutAmrapDrillBlock)
      return 'AMRAP';
    else if (block is WorkoutForTimeDrillBlock)
      return 'For Time';
    else if (block is WorkoutEmomDrillBlock)
      return 'EMOM';
    else if (block is WorkoutMultisetDrillBlock)
      return 'Multi Drill';
    else if (block is WorkoutSingleDrillBlock)
      return 'Single Drill';
    else if (block is WorkoutRestDrillBlock) return 'Rest';

    return '';
  }

  bool _canSelectDrillsCount(WorkoutDrillsBlock block) =>
      !(block is WorkoutRestDrillBlock || block is WorkoutSingleDrillBlock);

  bool _isMultisetWorkout(WorkoutDrillsBlock block) =>
      block is WorkoutMultisetDrillBlock;
}
