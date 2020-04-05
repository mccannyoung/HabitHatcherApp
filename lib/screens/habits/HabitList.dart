import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/database/database.dart' as db;

class HabitListWidget extends StatefulWidget{
  @override 
  _HabitListWidgetState createState() => _HabitListWidgetState();
}

class _HabitListWidgetState extends State<HabitListWidget> {
  Future<List<Habit>> habitList;
  
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    habitList = loadHabitData();
  }

 Future<List<Habit>> loadHabitData() async {
      var dbHelper = db.DBHelper();
      var habitsList = await dbHelper.getHabits();
      return habitsList;
  }

  @override 
  Widget build(BuildContext context) {
    return 
      Container (
        height:  150,
        child: 
         ListView(
          padding: const EdgeInsets.all(8),
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(title:  Text('Hello World 1'),),
              ListTile(title:  Text('Hello World 2'),),
              ListTile(title:  Text('Hello World 3'),),
              ListTile(title:  Text('Hello World 4'),),
            ]
          ) .toList(),
        ),
        );
       
  }
}


