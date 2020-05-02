import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/database/database.dart' as db;

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

    // Habit values
    int id;
    String description;
    String notes;
    //HabitGoal values
    String timeFrame;
    int goalValue;
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
        child: new  SingleChildScrollView(
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
                        decoration: new InputDecoration(labelText: 'number of times?'),
                        validator: (val)=>
                        val.length == 0 && int.parse(val) > 0? "Enter a number of times you wish to do your new habit" : null,
                        onSaved: (val)=>this.goalValue = int.parse(val),
                    ),
                    ),
                    new Text('per'),
                    new DropdownButton(
                      hint: Text('how often?'),
                      value: timeFrame,
                      items: this.timeLengths.map((String value){
                        return new DropdownMenuItem(
                          
                          child: new Text(value),
                          value: value,);
                      }).toList(), 
                      onChanged:  (val) {
                        setState(() {
                          timeFrame = val;
                        });
                        print('in on timeframe change');
                       },
                      ),
                  ]
                ),
                  new Text('Please rate a difficulty level (this will determine how forgiving the app is)'),
                  new DropdownButton(
                    hint:  Text('difficulty level?'),
                    value: handicap,
                    items: 
                      this.levels.map((String value) {
                        return new DropdownMenuItem(child: new Text(value), value: value,);
                      }
                    ).toList()
                  , onChanged: (val) {
                    setState(() {
                      handicap = val;
                    });
                    print('in on handicap change');
                  }
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
                    //navigateToPrevScreen();  
                  },
                  child: new Text('Add Habit'),
                  ),
                  )
              ],
          ),
      ),
    ),
      ),
      );
    }

    _saveHabit() async {

        if(this.formKey.currentState.validate()) {
          formKey.currentState.save();
        } else {
          return null;
        }

        var _db = db.DBHelper();

        id = await _db.getIdforNewHabit();

        print(id.toString());
        print(timeFrame);
        print(goalValue.toString());
        print(handicap);
        
        var habitGoal = HabitGoal(habitId: id,  timeFrame: timeFrame, goalValue: goalValue, handicap: handicap);
        var habit = Habit(description: description, notes: notes, goal: habitGoal);
        _db.newHabit(habit);
        navigateToPrevScreen();  
      }
  }


