import 'package:flutter/material.dart';
import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/model/habit.dart';

class HabitCard extends StatelessWidget{

final List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Edit', action: 'edit'),
  CustomPopupMenu(title: 'View History', action: 'history'),
  CustomPopupMenu(title: 'Delete', action: 'delete'),
];

  final Habit habit;
  final Function() refreshParent;

  final dbHelper = db.DBHelper();

   HabitCard({this.habit, @required this.refreshParent});

  @override
  Widget build(BuildContext context) {
    return 
      Card(
        child: ListTile(
        leading: Icon(Icons.add_circle_outline, size: 48.0),
        title: Text(habit.description),                  
        subtitle: (habit.goal != null) ? Text(
          habit.goal.handicap + ": " + habit.goal.goalValue.toString() + " per " + habit.goal.timeFrame
        ) :
        Text( "no goal set? "),
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
              print(habit.goal.goalValue);
              print(habit.goal.timeFrame);
              print(value.action);
              if (value.action == 'edit') {
                print('edit goes here');
              } else if (value.action == 'delete') {
                print('delete goes here');
                dbHelper.deleteHabit(habit);
                refreshParent();
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
    );
  }
}

class CustomPopupMenu{
  String title;
  String action;

  CustomPopupMenu({this.title, this.action});
}