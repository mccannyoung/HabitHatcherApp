import 'dart:async';

import 'package:flutter/material.dart';

import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_history.dart';
import 'package:habithatcher/screens/history/HistoryCard.dart';

import 'package:habithatcher/database/database.dart' as db;

class HistoryList extends StatefulWidget{

  final List<HabitHistory> history;
  final String title;
  final int habitId;
  
  HistoryList({@required this.history, this.habitId, Key key, this.title});
  
  @override 
  _HistoryListState createState() => new _HistoryListState(history, habitId);

}

class _HistoryListState extends State<HistoryList> {
  List<HabitHistory> historyList;
  int habitId; 

  _HistoryListState(history, habitId){
    historyList = history;
    habitId = habitId;
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();  
  }

  Future<List<Habit>> loadHabitData() async {
      var dbHelper = db.DBHelper();
      var habitsList = await dbHelper.getHabits();
      return habitsList;
  }

  reload(){
    setState(() {
      loadHabitData().then((habitList) {
        for (var i = 0; i < habitList.length; i++ ){
            if(habitList[i].id == habitId)
              historyList = habitList[i].history;
        }
      }
      );
    });
  }

  @override 
  Widget build(BuildContext context) {
    return  Scaffold( 
      appBar: AppBar(title: Text("Log"),),
      body: 
        new Container(
          child: 
            ListView.builder(
              itemCount: historyList.length, 
              itemBuilder: (context, index){
                HabitHistory log = historyList[index];              
                return  HistoryCard(history: log,  refreshParent: reload);
              }
            )   
        ),
    );
        
  }

}