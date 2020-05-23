import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/screens/habits/AddHabitGoal.dart';
import 'package:habithatcher/model/habit_reminder.dart';

import 'package:habithatcher/database/database.dart' as db;

class AddHabit extends StatefulWidget {
  AddHabit({Key key}) : super(key: key);


  @override
  _AddHabitState createState() => new _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  // Habit values
  int id;
  String description;
  String notes;
  HabitGoal goal; 
  List<String> colors;
  List<HabitReminder> reminders;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  _navigateToPrevScreen() {
    Navigator.pop(context);
  }
  _getNewIdForHabit() async {
    var _db = db.DBHelper();
    id = await _db.getIdforNewHabit();
  }
  updateGoal(HabitGoal goalUpdated)  {
    //print('updating goal:');
    //print(this.goal.prettyPrint());
    //print('to');
    this.goal = new HabitGoal(habitId: id, goalValue: goalUpdated.goalValue, handicap: goalUpdated.handicap, timeFrame: goalUpdated.timeFrame);
    //print(this.goal.prettyPrint());
  }
  @override
  Widget build(BuildContext context) {
    _getNewIdForHabit();
    if(goal == null)
      goal = new HabitGoal(habitId:  id);
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(title: new Text('Add a New Habit'), actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.cancel),
          tooltip: 'Cancel',
          onPressed: () {
            _navigateToPrevScreen();
          },
        ),
      ]),
      body: 
        new Form(
          key: formKey,        
          child:  new ListView(
            padding: const EdgeInsets.all(16),            
            children: [
              new Row( children: <Widget>[
                new Text('Habit Info'),
                new Text('Set Goal'),
                new Text('Color Codes'),
              ],),              
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Name'),
                validator: (val) => val.length == 0
                    ? "Enter a habit you want to start."
                    : null,
                onSaved: (val) => this.description = val,
              ), 
              Padding(padding: EdgeInsets.all(16.0), child: 
                new AddHabitGoal(habitGoal: goal, updateGoal: updateGoal, ),),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: 'Notes'),
                  validator: (val) => val.length == 0 ? 'Enter Notes' : null,
                  onSaved: (val) => this.notes = val,
                ),

                new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: new RaisedButton(
                    onPressed: () {
                      _saveHabit();
                    },
                    child: new Text('Add Habit'),
                  ),
                )
              ],
            ),
          ),
    );
  }

  _showSuccessDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('SUCCESS!'),
            content: new Text('Habit successfully added'),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: new Text('OK')),
            ],
          );
        });
  }

  _saveHabit() async {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return null;
    }
    print(goal.prettyPrint());

    var _db = db.DBHelper();
    var habit = Habit(description: description, notes: notes, goal: goal);
    print(habit.prettyPrint());
    _db.newHabit(habit);
    _showSuccessDialog();
    //_navigateToPrevScreen();
  }
}
