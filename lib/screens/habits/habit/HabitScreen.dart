import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/screens/habits/habit/HabitTopBar.dart';
import 'package:habithatcher/screens/habits/habit/HabitGeneral.dart';
import 'package:habithatcher/screens/habits/habit/HabitGoal.dart';
import 'package:habithatcher/screens/habits/habit/HabitReminderScreen.dart';
import 'package:habithatcher/screens/habits/habit/HabitColors.dart';
import 'package:habithatcher/model/habit_reminder.dart';
import 'package:habithatcher/database/database.dart' as db;

class HabitScreen extends StatefulWidget {
  Habit habit;
  final int tabOpen;

  HabitScreen({Key key, this.habit, this.tabOpen =0}) : super(key: key);
  @override
  
  _HabitScreenState createState() => new _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  int displayOption;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  _navigateToPrevScreen() {
    Navigator.pop(context);
  }

  void _getNewIdForHabit() async {
    var _db = db.DBHelper();
    setState(() async {
      if (this.widget.habit == null) {
        this.widget.habit = new Habit();  
        this.widget.habit.id = await _db.getIdforNewHabit();
      }
    });
  }

  updateGeneral(Habit uHabit) {
    setState(() {
      this.widget.habit.description = uHabit.description;
      this.widget.habit.notes = uHabit.notes;
    });
  }

  updateGoal(HabitGoal goalUpdated) {
    setState(() {
      this.widget.habit.goal = goalUpdated;
    });
  }

  updateReminders(List<HabitReminder> reminders) {
    setState(() {
      this.widget.habit.reminders = reminders;
    });
  }

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    // If the habit isn't set, create a new one if it isn't.
    if (this.widget.habit == null) _getNewIdForHabit();

    displayOption = 0;
  }

  getScreen2Show(int screen) {
    print('got passed in screen number ');
    print(screen.toString());
    setState(() {
      this.displayOption = screen;  
    });
    
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.habit == null || this.widget.habit.id == null)
      _getNewIdForHabit();
    if (this.widget.habit.goal == null)
      this.widget.habit.goal = new HabitGoal(habitId: this.widget.habit.id);
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
      body: new Form(
        key: formKey,
        child: new ListView(
          padding: const EdgeInsets.all(16),
          children: [
            new AddHabitTopBar(updateFn: getScreen2Show),
            new Visibility(
              visible: (displayOption == 0),
              child: new HabitGeneral(
                habit: this.widget.habit,
                updateFn: updateGeneral,
              ),
            ),
            new Visibility(
              visible: (displayOption == 1),
              child: new HabitGoalScreen(
                habitGoal: this.widget.habit.goal,
                updateGoal: updateGoal,
              ),
            ),
            new Visibility(
              visible: (displayOption == 2),
              child: new HabitColors(),
            ),
            new Visibility(
              visible: (displayOption == 3),
              child: new HabitReminderScreen(
                reminders: this.widget.habit.reminders,
              ),
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
    print(this.widget.habit.goal.prettyPrint());

    var _db = db.DBHelper();
    _db.newHabit(this.widget.habit);
    _showSuccessDialog();
    //_navigateToPrevScreen();
  }
}
