import 'dart:async';

import 'package:flutter/material.dart';

import 'package:habithatcher/model/habit.dart';

import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/screens/habits/HabitCard.dart';

class HabitList extends StatefulWidget{
  @override 
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
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

reload(){
  setState(() {
    habitList = loadHabitData();
  });
}

  @override 
  Widget build(BuildContext context) {
    return  Scaffold( 
      appBar: AppBar(title: Text("Habits"),),
      body: FutureBuilder (
        builder:  (context,  snapshot) {     
          
        if (snapshot.data==null || snapshot.hasData == false) {
          return 
          Container( 
            child: 
            Center( 
              child: new Text("loading data"),
            ),
          ); 
        }
        return snapshot.data.isEmpty ? Container( child: Center(child: Text('Please add a habit')) ): 
        Container(
          child: 
            ListView.builder(
              itemCount: snapshot.data.length, 
              itemBuilder: (context, index){
                Habit habit = snapshot.data[index];              
                return  HabitCard(habit: habit,  refreshParent: reload);
              }
            )   
        );
        },
        future: loadHabitData(),
    ),
    );
  }
}