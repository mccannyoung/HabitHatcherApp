import 'dart:async';

import 'package:flutter/material.dart';

import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/screens/habits/habit/HabitScreen.dart';
import 'package:habithatcher/database/database.dart' as db;
import 'package:habithatcher/screens/habits/HabitCard.dart';

class HabitList extends StatefulWidget {
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

  reload() {
    setState(() {
      habitList = loadHabitData();
    });
  }

  _onReorder(int oldIndex, int newIndex) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Habits"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.hasData == false) {
            return Container(
              child: Center(
                child: new Text("loading data"),
              ),
            );
          }
          return snapshot.data.isEmpty
              ? Container(child: Center(child: Text('You have no habits\nPlease add a habit')))
              : Container(
                  child: ReorderableListView(
                    onReorder: _onReorder,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: List.generate(
                      snapshot.data.length,
                      (index) {
                        Habit habit = snapshot.data[index];
                        return HabitCard(
                          key: Key(habit.id.toString()), 
                          habit: habit, 
                          refreshParent: reload
                        );
                      },
                    ),
                  ),
                );
        },
        future: loadHabitData(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_circle_outline),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new HabitScreen()));
          }),
    );
  }
}
