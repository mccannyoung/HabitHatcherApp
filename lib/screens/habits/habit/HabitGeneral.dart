import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habithatcher/model/habit.dart';

class HabitGeneral extends StatelessWidget {
  final Habit habit;
  final Function(Habit) updateFn;

  HabitGeneral({Key key, this.habit, this.updateFn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TextFormField(
            keyboardType: TextInputType.text,
            initialValue: habit.description,
            decoration: new InputDecoration(labelText: 'Name'),
            validator: (val) =>
                val.length == 0 ? "Enter a habit you want to start." : null,
                onChanged: (val) {
                  print("in HG onChanged");
                  this.habit.description = val;
                this.updateFn(this.habit);    
                },
            onSaved: (val) {
              print("in HG onSaved");
              this.habit.description = val;
              this.updateFn(this.habit);
            }),
        new TextFormField(
            keyboardType: TextInputType.text,
            initialValue: habit.notes,
            decoration: new InputDecoration(labelText: 'Notes'),
            validator: (val) => val.length == 0 ? 'Enter Notes' : null,
            onChanged: (val) {
              print("in HG onChanged");
              this.habit.notes = val;
              this.updateFn(this.habit);
            },
            onSaved: (val) {
              print("in HG onChanged");
              this.habit.notes = val;
              this.updateFn(this.habit);
            }),
      ],
    );
  }
}
