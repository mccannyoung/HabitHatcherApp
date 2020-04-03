import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/habit.dart';

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
    "CREATE TABLE habits(id INTEGER PRIMARY KEY, description TEXT, notes TEXT)"
    );
    //"CREATE TABLE Employee(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, mobileno TEXT,emailId TEXT )"
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
  
  getIdforNewHabit() async{
    var dbClient = await db;
    var res = await dbClient.rawQuery('Select max(id)+1 as id from habits');
    return res[0]["id"];
  }

  newHabit(Habit habit) async {
    var dbClient = await db;
    var res = await dbClient.rawInsert(
          'INSERT INTO habits(description, notes )' 
          'VALUES(?,?)', [habit.description, habit.notes]);
    print('insert returned ');
    print(res);
    return res;
  }


}