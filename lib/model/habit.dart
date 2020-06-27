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

  prettyPrint() {
    String historyStr =  'none';
    String colorsStr = 'not set';
    String remindersStr = 'not set';
    String goalStr = 'not set';
    String idPrt = 'not set'; 
    String sortOrderStr = 'not set';
    String descriptionStr = 'not set';
    String notesStr = 'not set';

    
    if (sortOrder != null)
      sortOrderStr = sortOrder.toString();
    if (id != null)
      idPrt = id.toString();
    if (goal != null)
      goalStr = goal.prettyPrint();
    if (colors != null && colors.length > 0)
      colorsStr = colors.join(' ,');
    if (history != null && history.length > 0)
      history.forEach((log) => historyStr = historyStr + log.prettyPrint());
    if (reminders != null && reminders.length > 0)
      reminders.forEach((reminder)=> remindersStr = reminder.prettyPrint());
    if (notes != null)
      notesStr = notes;
    if (description !=null)
      descriptionStr = description;
    return 'id: '+ idPrt + 
    ', description: ' + descriptionStr + 
    ', notes: ' + notesStr + 
    ', goal: ' + goalStr + 
    ', history: ' + historyStr + 
    ', sortOrder: ' + sortOrderStr + 
    ', color: ' + colorsStr + 
    ',  reminders: ' + remindersStr;  
  }
}