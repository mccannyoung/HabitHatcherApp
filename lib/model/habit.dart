import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/model/habit_history.dart';

class Habit {
  
  final int id;
  final String description;
  final String notes;
  final HabitGoal goal;
  final List<HabitHistory> history;

  Habit({this.id, this.description, this.notes, this.goal, this.history});
  
  Map<String, dynamic> toMap() {
    return {
      'description' : description,
      'notes': notes,
      'goal': goal.toMap(),
      'history': history,
    };
  }
}