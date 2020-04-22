import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:habithatcher/model/habit.dart';
//import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/model/habit_goal.dart';

class AddHabit extends StatefulWidget {
  AddHabit({Key key, this.title}) : super (key: key);
  final String title;

  @override
  _AddHabitState createState() => new _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
    final List<String> timeLengths = [
    'Day',
    'Week',
    'Month',
    'Year'
  ];

  final List<String> levels = [
    'Easy',
    'Medium',
    'Hard',
    'Impossible'
  ];

    int id;
    String description;
    String notes;
    
    int goalid;
    String timeFrame;
    int goalValue;
    bool active;
    String handicap;

    final scaffoldKey = new GlobalKey<ScaffoldState>();
    final formKey = new GlobalKey<FormState>();
    navigateToPrevScreen() {
      Navigator.pop(context);
    }
    @override
    Widget build(BuildContext context){
      return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text('Add a New Habbit'),
          actions: <Widget> [
            new IconButton(
              icon: const Icon(Icons.cancel),
              tooltip: 'Cancel',
              onPressed: () {
                navigateToPrevScreen();                
             },
            ),
          ]
        ),
        body: new Padding(
          padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Habit'),
                validator: (val) =>
                    val.length == 0 ?"Enter a habit you want to start." : null,
                onSaved: (val) => this.description = val,
              ),
              new Row( 
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(
                    width: 100,
                  child:
                   new TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(labelText: 'How often?'),
                      validator: (val)=>
                      val.length == 0 && int.parse(val) > 0? "Enter a number of times you wish to do your new habit" : null,
                      onSaved: (val)=>this.goalValue = int.parse(val),
                  ),
                  ),
                  new Text('per'),
                  new DropdownButton(
                    items: this.timeLengths.map((String value){
                      return new DropdownMenuItem(
                        child: new Text(value),
                      value: value,);
                    }).toList(), 
                    onChanged: (val) =>this.timeFrame = val,
                    ),
                ]
              ),
                new Text('Please rate a difficulty level (this will determine how forgiving the app is)'),
                new DropdownButton(items: 
                this.levels.map((String value) {
                  return new DropdownMenuItem(child: new Text(value), value: value,);
                }).toList()
                , onChanged: (val) => this.handicap = val,
                ),
            new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Notes'),
                validator: (val) =>
                    val.length ==0 ? 'Enter Notes' : null,
                onSaved: (val) => this.notes = val,
              ),
              new Container(margin: const EdgeInsets.only(top: 10.0),child: new RaisedButton(
                onPressed: (){
                   _saveHabit();
                   navigateToPrevScreen();  
                },
                child: new Text('Add Habit'),
                ),
                )
            ],
        ),
      ),
      ),
      );
    }

    _getNextId() async {
      var _db = db.DBHelper();
      id = await _db.getIdforNewHabit();
    }
    _getNextGoalId() async {
      var _db = db.DBHelper();
      goalid = await _db.getIdforNewHabitGoal();
    }


    _saveHabit() async {
        await _getNextId();
        await _getNextGoalId();
        if(this.formKey.currentState.validate()) {
          formKey.currentState.save();
        } else {
          return null;
        }        
        var _db = db.DBHelper();
        var habit = Habit(id, description, notes);
        var habitGoal = HabitGoal(goalid, id, timeFrame, goalValue, true, handicap);
        _db.newHabit(habit);
        _db.newHabitGoal(habitGoal);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                title: Center(child: Text('Success')),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'New habit saved successfully!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                ),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Ok'),
                  onPressed: (){
                    description = "";
                    notes = "";
                    Navigator.of(context).pop();
                  }
                ),
              ]
              );
            }
          );
        }
    }


