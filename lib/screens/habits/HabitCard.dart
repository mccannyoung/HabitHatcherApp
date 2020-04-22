//import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';



class HabitCard extends StatelessWidget{

final List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Edit', action: 'edit'),
  CustomPopupMenu(title: 'View History', action: 'history'),
  CustomPopupMenu(title: 'Delete', action: 'delete'),
];

  final Habit habit;
  final HabitGoal goal;
  var vis = true;
  final dbHelper = db.DBHelper();

   HabitCard({this.habit, this.goal});

  @override
  Widget build(BuildContext context) {
    Visibility(
      visible: vis,
      child: 
      Card(
                  child: ListTile(
                  leading: Icon(Icons.add_circle_outline, size: 48.0),
                  title: Text(habit.description),
                  
                  subtitle: Text(
                    goal.goalValue.toString() + " per " + goal.timeFrame
                  ),
                trailing: PopupMenuButton<CustomPopupMenu>(
                  elevation: 0.0,
                  //initialValue:  choices[1],
                  onCanceled: (){
                    print('You have not chosen anything');
                  },
                  tooltip: 'Do things to this item',
                  onSelected: (value){
                    print("something is selected!!");
                    print('for habit');
                    print(habit.id);
                    print(habit.description);
                    print(habit.notes);
                    print(value.action);
                    if (value.action == 'edit') {
                      print('edit goes here');
                    } else if (value.action == 'delete') {
                      print('delete goes here');
                      dbHelper.deleteHabit(habit);
                      vis = false;
                    } else {
                      print('history goes here');
                    }
                  },
                  itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            }
              ),
                isThreeLine: true,
                ),
              )
    );

      }
}

class CustomPopupMenu{
  String title;
  String action;

  CustomPopupMenu({this.title, this.action});
}