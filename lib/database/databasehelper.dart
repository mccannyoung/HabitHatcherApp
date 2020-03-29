/* this is the database section, it's where all the "magic" happens re:persistant

final Future<Database> database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.
   join(await getDatabasesPath(), 'habits_database.db'),

  onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE habits(id INTEGER PRIMARY KEY, description TEXT, streak INTEGER, grade REAL, notes TEXT)",
    );
  },
  version: 1,
);
Future<void> insertHabit(Habit habit) async {
  final Database db = await database;
  await db.insert(
    'habits',  habit.toMap(),
    conflictAlgorithm:  ConflictAlgorithm.replace,
    );
}

Future<List<Habit>> habits() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('habits');

  return List.generate(maps.length, (i) {
    return Habit(
      id: maps[i]['id'],
      description: maps[i]['description'],
      streak: maps[i]['streak'],
      grade: maps[i]['grade'],
      notes: maps[i]['notes'],
    );
  });
}
*/