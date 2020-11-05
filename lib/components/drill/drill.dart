import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../domain/workout.dart';
import '../../core/utils.dart';

class Drill extends StatelessWidget {
  final bool isSingleDrill;
  final int drillBlockIndex;
  final int index;
  final WorkoutDrill drill;

  Drill(
      {Key key,
      this.drillBlockIndex,
      this.index,
      this.isSingleDrill,
      this.drill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 4, right: 4),
        decoration: BoxDecoration(color: Colors.white54),
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              initialValue: drill.title,
              attribute: 'title_${drillBlockIndex}_$index',
              decoration: InputDecoration(
                labelText: isSingleDrill ? 'Drill *' : 'Drill #${index + 1}',
              ),
              onChanged: (dynamic val) {
                drill.title = val;
              },
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(100),
              ],
            ),
            FormBuilderTextField(
              initialValue: drill.sets == null ? '' : drill.sets.toString(),
              attribute: 'sets_${drillBlockIndex}_$index',
              decoration: InputDecoration(
                labelText: isSingleDrill ? 'Sets *' : 'Sets #${index + 1}',
              ),
              onChanged: (dynamic val) {
                if (isNumeric(val)) {
                  drill.sets = cleanInt(val);
                }
              },
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(100),
                FormBuilderValidators.numeric(),
              ],
              keyboardType: TextInputType.number,
            ),
            FormBuilderTextField(
              initialValue: drill.reps == null ? '' : drill.reps.toString(),
              attribute: 'reps_${drillBlockIndex}_$index',
              decoration: InputDecoration(
                labelText: isSingleDrill ? 'Reps *' : 'Reps #${index + 1} *',
              ),
              onChanged: (dynamic val) {
                if (isNumeric(val)) {
                  drill.reps = cleanInt(val);
                }
              },
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.maxLength(500),
                FormBuilderValidators.numeric(),
              ],
              keyboardType: TextInputType.number,
            ),
            FormBuilderTextField(
              initialValue: drill.weigth,
              attribute: 'weigth_${drillBlockIndex}_$index',
              decoration: InputDecoration(
                labelText: isSingleDrill ? 'Weight' : 'Weigth #${index + 1}',
              ),
              onChanged: (dynamic val) {
                drill.weigth = val;
              },
              validators: [
                FormBuilderValidators.maxLength(100),
              ],
            )
          ],
        ),
      ),
    );
  }
}
