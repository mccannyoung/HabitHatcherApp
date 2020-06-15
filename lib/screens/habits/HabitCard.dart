import 'package:flutter/material.dart';
import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/screens/habits/UpdateHabit.dart';
import 'package:habithatcher/screens/history/AddHistory.dart';
import 'package:habithatcher/screens/history/HistoryList.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final Function() refreshParent;

  HabitCard({this.habit, @required this.refreshParent, Key key})
      : super(key: key);
  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  final List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'Edit', action: 'edit'),
    CustomPopupMenu(title: 'View History', action: 'history'),
    CustomPopupMenu(title: 'Delete', action: 'delete'),
  ];

  final dbHelper = db.DBHelper();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
            icon: Icon(Icons.assignment, size: 48.0),
            tooltip: 'Log activity',
            onPressed: () {
              print(
                  "about to pass habit id " + this.widget.habit.id.toString());

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        new AddHabitHistory(habit: this.widget.habit),
                    settings: RouteSettings(
                      arguments: this.widget.habit,
                    ),
                  ));
            }),
        title: Text(this.widget.habit.description),
        subtitle: (this.widget.habit.goal != null)
            ? Text(this.widget.habit.goal.handicap.toString() +
                ": " +
                this.widget.habit.goal.goalValue.toString() +
                " per " +
                this.widget.habit.goal.timeFrame.toString())
            : Text("No goal, add one if you'd like but not required"),
        trailing: PopupMenuButton<CustomPopupMenu>(
            elevation: 0.0,
            //initialValue:  choices[1],
            onCanceled: () {
              print('You have not chosen anything');
            },
            tooltip: 'Do things to this item',
            onSelected: (value) {
              print("something is selected!!");
              print('for habit');
              print(this.widget.habit.id);
              print(this.widget.habit.description);
              print(this.widget.habit.notes);
              print(this.widget.habit.goal.goalValue);
              print(this.widget.habit.goal.timeFrame);
              print(value.action);
              if (value.action == 'edit') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new UpdateHabit(
                              habit: this.widget.habit,
                            )));
                this.widget.refreshParent();
              } else if (value.action == 'delete') {
                print('delete goes here');
                dbHelper.deleteHabit(this.widget.habit);
                this.widget.refreshParent();
              } else {
                print('history goes here');
                print(this.widget.habit.prettyPrint());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new HistoryList(
                              history: this.widget.habit.history,
                              habitId: this.widget.habit.id,
                            )));
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            }),
        isThreeLine: true,
      ),
    );
  }
}

class CustomPopupMenu {
  String title;
  String action;

  CustomPopupMenu({this.title, this.action});
}
