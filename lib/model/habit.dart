import 'package:habithatcher/model/habit_goal.dart';
import 'package:habithatcher/model/habit_history.dart';
import 'package:habithatcher/model/habit_reminder.dart';

class Habit {
  
  int id;
  String description;
  String notes;
  HabitGoal goal;
  List<HabitHistory> history;
  int sortOrder;
  List<String> colors;
  List<HabitReminder> reminders;

  Habit({this.id, this.description, this.notes, this.goal, this.history, this.sortOrder, this.colors, this.reminders});
  
  // Map<String, dynamic> toMap() {
  //   return {
  //     'description' : description,
  //     'notes': notes,
  //     'goal': goal.toMap(),
  //     'history': history,
  //     'sortOrder': sortOrder,
  //   };
  // }

  prettyPrint() {
    String historyStr =  '';
    String colorsStr = '';
    String remindersStr ='';
    if (colors != null && colors.length > 0)
      colorsStr = colors.join(' ,');
    if (history != null && history.length > 0)
      history.forEach((log) => historyStr = historyStr + log.prettyPrint());
    if (reminders != null && reminders.length > 0)
      reminders.forEach((reminder)=> remindersStr = reminder.prettyPrint());

    return 'id: '+ id.toString() + ', description: '+ description + ', notes: '+ notes + ', goal: '+ goal.prettyPrint() + ', history: ' + historyStr + ', sortOrder: '+ sortOrder.toString() +', color: '+ colorsStr + ',  reminders: '+ remindersStr;  
  }
}