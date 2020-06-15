import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/model/habit_history.dart';
import 'package:habithatcher/model/habit_reminder.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
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

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE habits (id INTEGER PRIMARY KEY, description TEXT, notes TEXT, colors TEXT, sortOrder INTEGER)');
    await db.execute(
        'CREATE TABLE habit_goals (id INTEGER PRIMARY KEY, habitId INTEGER NOT NULL ,  goalStart TEXT NOT NULL, goalEnd TEXT, timeFrame TEXT, goalValue INTEGER, handicap TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE habit_history (id INTEGER PRIMARY KEY, habitId INTEGER NOT NULL,  date TEXT NOT NULL, value INTEGER NOT NULL, notes TEXT)');
    await db.execute(
        'CREATE TABLE habit_reminders (id INTEGER PRIMARY KEY, habitId INTEGER NOT NULL, timeOfDay TEXT, dayOfWeek INTEGER, weekOfMonth INTEGER, dayOfMonth INTEGER, monthOfYear INTEGER) ');
    print("Created habit table");
  }

  _date2String(DateTime from) {
    if (from == null) return null;
    return from.toIso8601String();
  }

  _string2DateTime(String from) {
    if (from == null) return null;
    return DateTime.parse(from);
  }

  _getTodaysDate() {
    return new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  _getRemindersByHabitId(int habitId) async {
    var dbClient = await db;

    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM habit_reminders WHERE habitId = ?', [habitId.toString()]);
    List<HabitReminder> reminders;
    if (list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        reminders.add(new HabitReminder(
            id: list[i]["id"],
            habitId: habitId,
            timeOfDay: list[i]["timeOfDay"],
            dayOfWeek: list[i]["dayOfWeek"],
            dayOfMonth: list[i]["dayOfMonth"],
            weekOfMonth: list[i]["weekOfMonth"],
            monthOfYear: list[i]["monthOfYear"]));
      }
    }
  }

  //Get a list of habits in order of the sort order
  Future<List<Habit>> getHabits() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM habits ORDER BY sortOrder ASC');

    List<Habit> habits = new List();
    if (list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        int habitId = list[i]["id"];
        List<Map> habitGoal = await dbClient.rawQuery(
            'SELECT * FROM habit_goals where goalEnd IS NULL and  habitId =?',
            [habitId.toString()]);
        HabitGoal goal = new HabitGoal();
        if (habitGoal.length > 0) {
          goal = new HabitGoal(
              id: habitGoal[0]["id"],
              habitId: list[i]["id"],
              goalStart: _string2DateTime(habitGoal[0]["goalStart"]),
              goalEnd: _string2DateTime(habitGoal[0]["goalEnd"]),
              timeFrame: habitGoal[0]["timeFrame"],
              goalValue: habitGoal[0]["goalValue"],
              handicap: habitGoal[0]["handicap"]);
        }
        List<Map> habitHistories = await dbClient.rawQuery(
            'SELECT * FROM habit_history WHERE  habitId =?',
            [habitId.toString()]);
        List<HabitHistory> history = new List();
        print('A history was found of length ' +
            habitHistories.length.toString());

        if (habitHistories.length > 0) {
          for (int j = 0; j < habitHistories.length; j++) {
            HabitHistory newHistory = new HabitHistory(
                id: habitHistories[j]["id"],
                habitId: habitHistories[j]["habitId"],
                date: DateTime.parse(habitHistories[j]["date"]),
                value: habitHistories[j]["value"],
                notes: habitHistories[j]["notes"]);
            print(newHistory.prettyPrint());
            history.add(newHistory);
          }
        }
        List<HabitReminder> reminders = await _getRemindersByHabitId(habitId);
        habits.add(new Habit(
            id: list[i]["id"],
            description: list[i]["description"],
            notes: list[i]["notes"],
            goal: goal,
            history: history,
            reminders:  reminders,
            ));
      }
      print(habits.length);
    }
    return habits;
  }

  Future<HabitGoal> getHabitGoalById(int id) async {
    var dbClient = await db;
    print('getting goal for id ' + id.toString());

    List<Map> habitGoal = await dbClient.rawQuery(
        'SELECT * FROM habit_goals where habitId = ?', [id.toString()]);
    HabitGoal goal = new HabitGoal(
        id: habitGoal[0]["id"],
        habitId: id,
        goalStart: habitGoal[0]["goalStart"],
        goalEnd: habitGoal[0]["goalEnd"],
        timeFrame: habitGoal[0]["timeFrame"],
        goalValue: habitGoal[0]["goalValue"],
        handicap: habitGoal[0]["handicap"]);

    print('retrieved habit goal ' + goal.prettyPrint());
    return goal;
  }

  Future<int> getIdforNewHabit() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('Select max(id)+1 as id from habits');
    print('id is ');
    int id = res[0]["id"];
    print(id.toString());
    if (id == null) id = 1;
    print(id.toString());
    return id;
  }

  newHabit(Habit habit) async {
    print('going to create a new habit: ' + habit.prettyPrint());

    var dbClient = await db;
    var res = await dbClient.rawInsert(
        'INSERT INTO habits(description, notes, sortOrder) '
        'VALUES(?,?, (SELECT MAX(sortOrder) + 1 FROM habits))',
        [habit.description, habit.notes]);
    print('insert returned ');
    print(res);
    newHabitGoal(habit.goal);
    return res;
  }

  newHabitReminder(HabitReminder reminder) async {
    if (reminder != null)
      print('going to create new reminder for habit '+ reminder.habitId.toString());
    else {
      print('was passed null reminder, fix this');
      return;
    }
    var dbClient = await db;
    // timeOfDay TEXT, dayOfWeek INTEGER, weekOfMonth INTEGER, dayOfMonth INTEGER, monthOfYear INTEGER
    var res = await dbClient.rawInsert('INSERT INTO habit_reminders (habitId, timeOfDay, dayOfWeek, weekOfMonth, dayOfMonth, monthOfYear) '
    ' Values(?,?,?, ?, ?, ?) ', [reminder.habitId, reminder.timeOfDay, reminder.dayOfWeek, reminder.weekOfMonth, reminder.dayOfMonth, reminder.monthOfYear]);
    print('insert returned ');
    print(res);
    return res;

  }

  newHabitGoal(HabitGoal habitGoal) async {
    if (habitGoal.goalValue != null){
      var dbClient = await db;
      DateTime startDateTime = _getTodaysDate();
      var res = await dbClient.rawInsert(
          'INSERT INTO habit_goals(habitId, goalStart, goalEnd, timeFrame, goalValue, handicap) '
          'VALUES(?, ?, null, ?, ?, ?) ',
          [
            habitGoal.habitId,
            _date2String(startDateTime),
            habitGoal.timeFrame,
            habitGoal.goalValue,
            habitGoal.handicap
          ]);
      print('insert habit goal returned ');
      print(res);
      return res;
    }
    return 0;
  }

  addHabitHistory(HabitHistory history) async {
    var dbClient = await db;
    print('Adding habit history: ' + history.prettyPrint());
    var res = await dbClient.rawInsert(
        'INSERT INTO  habit_history (habitId, date, value, notes) '
        'VALUES(?, ?, ?, ?)',
        [
          history.habitId,
          history.date.toIso8601String(),
          history.value,
          history.notes
        ]);
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
        'WHERE id = ?',
        [habit.id]);
    print('delete from habits returned ');
    print(res);
    res = await dbClient.rawDelete(
        'DELETE FROM habit_goals '
        'WHERE habitId = ?',
        [habit.id]);
    print('delete from habit goals returned ');
    print(res);
    res = await dbClient.rawDelete(
        'DELETE FROM habit_history '
        'WHERE habitId = ?',
        [habit.id]);
    print('delete habit hisotry returned ');
    print(res);
    return res;
  }

  editHabit(Habit habit) async {
    var dbClient = await db;
    print('--------');
    print('going to edit a habit: ' + habit.prettyPrint());
    print('--------');

    var res = await dbClient.rawUpdate(
        'UPDATE habits '
        'SET description = ?, notes = ?, sortOrder = ? '
        'WHERE id = ?',
        [habit.description, habit.notes, habit.sortOrder, habit.id]);

    print('edit returned ');
    print(res);
    var currentHabitGoal = await getHabitGoalById(habit.id);
    print('goal before change, if needed: ' + currentHabitGoal.toString());
    // if there was a change to the goal, update the goal, otherwise, we're done
    if (currentHabitGoal.goalValue != habit.goal.goalValue ||
        currentHabitGoal.timeFrame != habit.goal.timeFrame ||
        currentHabitGoal.handicap != habit.goal.handicap) {
      editHabitGoal(habit.goal);
    }

    return res;
  }

  // To edit we're going to mark the old goal as ended, and create a new goal
  // This will allow the history to only be graded against what goal was active
  // at that time.
  editHabitGoal(HabitGoal habitGoal) async {
    var dbClient = await db;
    print('new goal ' + habitGoal.prettyPrint());

    DateTime endNow = _getTodaysDate();
    var res = await dbClient.rawUpdate(
        'UPDATE habit_goals '
        'SET goalEnd=? '
        'WHERE id = ?',
        [_date2String(endNow), habitGoal.id]);
    newHabitGoal(habitGoal);
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
        'WHERE id = ?',
        [
          habitHistory.date.toIso8601String(),
          habitHistory.value,
          habitHistory.notes,
          habitHistory.id
        ]);
    print('edit returned ');
    print(res);
    return res;
  }

  deleteHabitHistoryById(int id) async {
    var dbClient = await db;

    var res = await dbClient.rawDelete(
        'DELETE FROM habit_history '
        'WHERE id = ?',
        [id.toString()]);
    print('delete habit history returned ');
    print(res);
    return res;
  }

  calculateHatchValueForHabit(int id) {
    return 0;
  }
}
