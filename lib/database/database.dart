import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/model/habit_history.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name habits.db in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "habits.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
      'CREATE TABLE habits (id INTEGER PRIMARY KEY, description TEXT, notes TEXT)'
    );
    await db.execute(
      'CREATE TABLE habit_goals (id INTEGER PRIMARY KEY, habitId INTEGER UNIQUE,  timeFrame TEXT, goalValue INTEGER, active INTEGER, handicap TEXT)'
    );
    await db.execute(
        'CREATE TABLE habit_history(id INTEGER PRIMARY KEY, habitId INTEGER,  date TEXT, value INTEGER, notes TEXT)'
    );
    print("Created habit table");
  }
  
  // Retrieving employees from Employee Tables
  Future<List<Habit>> getHabits() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM habits');
    List<Habit> habits = new List();
    for (int i = 0; i < list.length; i++) {
      habits.add(new Habit( list[i]["id"], list[i]["description"], list[i]["notes"]));
    }
    print(habits.length);
    return habits;
  }

    Future<HabitGoal> getHabitGoalById(int id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM habit_goals where habit_id = ?', [id.toString()]);
   HabitGoal goal = new HabitGoal(list[0]["id"], id, list[0]["timeFrame"], list[0]["goalValue"], list[0]["active"], list[0]["handicap"]);
    return goal;
  }
  
  getIdforNewHabit() async{
    var dbClient = await db;
    var res = await dbClient.rawQuery('Select max(id)+1 as id from habits');
    return res[0]["id"];
  }

  getIdforNewHabitGoal() async{
    var dbClient = await db;
    var res = await dbClient.rawQuery('Select max(id)+1 as id from habit_goals');
    return res[0]["id"];
  }


  newHabit(Habit habit) async {
    var dbClient = await db;
    var res = await dbClient.rawInsert(
          'INSERT INTO habits(description, notes) ' 
          'VALUES(?,?)', [habit.description, habit.notes]);
    print('insert returned ');
    print(res);
    return res;
  }

  newHabitGoal(HabitGoal habitGoal) async {
    var dbClient = await db;
    var res = await dbClient.rawInsert(
          'INSERT INTO habits(habitId, timeFrame, goalValue, active, handicap) ' 
          'VALUES(?, ?, ?, ?, ?, ?) ', [habitGoal.habitId, habitGoal.timeFrame, habitGoal.goalValue, 1, habitGoal.handicap]);
    print('insert returned ');
    print(res);
    return res;
  }


  // This is a cheap hack of a cascade delete 
  deleteHabit(Habit habit) async {
     var dbClient = await db;
    print(habit.id);
    var res = await dbClient.rawDelete(
          'DELETE FROM habits ' 
          'WHERE id = ?', [habit.id]
          );
    print('delete from habits returned ');
    print(res);
    res = await dbClient.rawDelete(
          'DELETE FROM habit_goals ' 
          'WHERE habitId = ?', [habit.id]
    );
    print('delete from habit goals returned ');
    print(res);
    res = await dbClient.rawDelete(
          'DELETE FROM habit_history ' 
          'WHERE habitId = ?', [habit.id]
          );
    print('delete habit hisotry returned ');
    print(res);
    return res;
  }

  editHabit(Habit habit) async {
    var dbClient = await db;

    var res = await dbClient.rawUpdate(
          'UPDATE habits ' 
          'SET description = ?, notes = ? '
          'WHERE id = ?', [habit.description, habit.notes, habit.id]);
    
    print('edit returned ');
    print(res);
    return res;
  }
  
  editHabitGoal(HabitGoal habitGoal) async {
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
          'UPDATE habit_goal ' 
          'SET timeFrame=?, goalValue=?, active =?,   handicap = ?  '
          'WHERE id = ?', [habitGoal.timeFrame, habitGoal.goalValue, habitGoal.active,  habitGoal.handicap, habitGoal.id]);
    print('edit returned ');
    print(res);
    return res;
  }

  
  editHabitHistory(HabitHistory habitHistory) async {
    var dbClient = await db;
    //id INTEGER PRIMARY KEY, habitId INTEGER,  date TEXT, value INTEGER, notes TEXT
    var res = await dbClient.rawUpdate(
          'UPDATE habit_history ' 
          'SET date = ?,  value=?, notes = ? '
          'WHERE id = ?', [habitHistory.date.toString(), habitHistory.value, habitHistory.notes, habitHistory.id]);
    print('edit returned ');
    print(res);
    return res;
  }

}