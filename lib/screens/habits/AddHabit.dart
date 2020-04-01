//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter_svg/flutter_svg.dart';

//import 'dart:math';

import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/database/database.dart' as db;

class AddHabit extends StatefulWidget {
  AddHabit({Key key, this.title}) : super (key: key);
  final String title;

  @override
  _AddHabitState createState() => new _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
    var newHabit = new Habit("","");

    int id;
    String description;
    String notes;

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
            children: [
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Habit'),
                validator: (val) =>
                    val.length == 0 ?"Enter a habit you want to start." : null,
                onSaved: (val) => this.description = val,
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

    _saveHabit(){
        if(this.formKey.currentState.validate()) {
          formKey.currentState.save();
        } else {
          return null;
        }        
        var _db = db.DBHelper();
        var habit = Habit(description, notes);
        if (_db.newHabit(habit)){
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
}

