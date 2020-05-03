import 'package:flutter/material.dart';
import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/screens/habits/UpdateHabit.dart';
import 'package:habithatcher/screens/history/AddHistory.dart';
import 'package:habithatcher/screens/history/HistoryList.dart';

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
        leading: IconButton( icon: Icon(Icons.add_circle_outline, size: 48.0), tooltip: 'Log activity', onPressed: (){
          print("about to pass habit id " + habit.id.toString());
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new AddHabitHistory(habit: habit),
              settings: RouteSettings(
              arguments: habit,
            ),
          )
          );
        }),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new UpdateHabit(habit: habit,))
                );
                refreshParent();
              } else if (value.action == 'delete') {
                print('delete goes here');
                dbHelper.deleteHabit(habit);
                refreshParent();
              } else {
                print('history goes here');
                print(habit.prettyPrint());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new HistoryList(history: habit.history, habitId: habit.id,))
                );
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