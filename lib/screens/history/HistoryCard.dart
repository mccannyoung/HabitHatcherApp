import 'package:flutter/material.dart';
import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/model/habit_history.dart';
import 'package:habithatcher/screens/history/UpdateHistory.dart';


class HistoryCard extends StatelessWidget{

final List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Edit', action: 'edit'),  
  CustomPopupMenu(title: 'Delete', action: 'delete'),
];

  final HabitHistory history;
  final Function() refreshParent;

  final dbHelper = db.DBHelper();

   HistoryCard({@required this.history, @required this.refreshParent});

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
  Widget build(BuildContext context) {
    return 
      Card(
        child: ListTile(
        title: Text(_getDateToDisplay(history.date)),                  
        subtitle: Text(history.value.toString() + ': '+ history.notes),
        trailing: PopupMenuButton<CustomPopupMenu>(
            elevation: 0.0,
            onCanceled: (){
              print('You have not chosen anything');
            },
            tooltip: 'Do things to this item',
            onSelected: (value){
              print("something is selected!!");
              print('for history');
              print(value.action);
              if (value.action == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new UpdateHistory(history: history,))
                );
                refreshParent();
              } else if (value.action == 'delete') {
                print('delete goes here');
                dbHelper.deleteHabitHistoryById(history.id);
                refreshParent();
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