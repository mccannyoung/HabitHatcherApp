import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_history.dart';

import 'package:habithatcher/database/database.dart' as db;

class AddHabitHistory extends StatefulWidget {

  final String title;
  final Habit habit;

  AddHabitHistory({@required this.habit, Key key, this.title}) : super (key: key);

  @override
  _AddHabitHistoryState createState() => new _AddHabitHistoryState(habit);
}

class _AddHabitHistoryState extends State<AddHabitHistory> {
  
  int habitId;
  DateTime habitDate;
  int value;
  String notes;


  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  _AddHabitHistoryState(Habit habit){
    habitId =  habit.id;
    habitDate = DateTime.now();
    value = 0;
    notes = '';
  }    
 _navigateToPrevScreen() {
  Navigator.pop(context);
 }

    _saveHabitHistory() async {

        if(this.formKey.currentState.validate()) {
          formKey.currentState.save();
        } else {
          return null;
        }
        HabitHistory log = HabitHistory(habitId: habitId, date: habitDate, notes:  notes, value: value); 

        var _db = db.DBHelper();
        _db.addHabitHistory(log);
        _navigateToPrevScreen();  
    }
   

  _getDateToDisplay(date2check) {
    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    DateTime checkThis = DateTime(date2check.year, date2check.month, date2check.day);

    if (checkThis == today) {
      return 'Today';
    } else if (checkThis == yesterday) {
      return 'Yesterday';
    } else if (checkThis == tomorrow) {
      return 'Tomorrow';
    } else {
      return checkThis.month.toString() + '/' + checkThis.day.toString() + ' /' + checkThis.year.toString();
    }   
  }  



  @override
  Widget build(BuildContext context){
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Log '+ this.widget.habit.description),
        actions: <Widget> [
          new IconButton(
            icon: const Icon(Icons.cancel),
            tooltip: 'Cancel',
            onPressed: () {
              _navigateToPrevScreen();                
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
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Text('Date :'),
                    new Text(_getDateToDisplay(habitDate)),
                    new RaisedButton(
                      child: new Text('Change Date'),
                      onPressed: () {
                        showDatePicker(
                          context: context, 
                          initialDate: habitDate, 
                          firstDate: DateTime(DateTime.now().add(new Duration(days: -365)).year), // from 1 year in the past
                          lastDate: DateTime(DateTime.now().add(new Duration(days: 365)).year) // up to 1 year in the future
                        ).then((date){
                          this.habitDate = date;
                        });
                      },
                    ),
                  ]),
                  new TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(labelText: 'Enter a value'),
                        validator: (val)=>
                        val.length == 0 && int.parse(val) > 0? "Enter a number of times you completed your habit" : null,
                        onSaved: (val)=>this.value = int.parse(val),
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
                    _saveHabitHistory();
                    //navigateToPrevScreen();  
                  },
                  child: new Text('Add Log'),
                  ),
                  )
              ],
          ),
      ),
    ),
      ),
      );
    }
}
