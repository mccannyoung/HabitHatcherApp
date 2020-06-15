import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habithatcher/model/habit.dart';

class HabitGeneral extends StatefulWidget {
  final Habit habit;
  final Function(Habit) updateFn;

  HabitGeneral({Key key, this.habit, this.updateFn}) : super(key: key);

  _HabitGeneralState createState() => _HabitGeneralState();
}

class _HabitGeneralState extends State<HabitGeneral> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TextFormField(
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(labelText: 'Name'),
            validator: (val) =>
                val.length == 0 ? "Enter a habit you want to start." : null,
            onSaved: (val) {
              this.widget.habit.description = val;
              this.widget.updateFn(this.widget.habit);
            }),
        new TextFormField(
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(labelText: 'Notes'),
            validator: (val) => val.length == 0 ? 'Enter Notes' : null,
            onSaved: (val) {
              this.widget.habit.notes = val;
              this.widget.updateFn(this.widget.habit);
            }),
      ],
    );
  }
}
