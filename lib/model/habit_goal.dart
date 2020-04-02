  enum Time{
    day,
    week,
    biweek,
    month,
    bimonth,
    biannual, 
    annual
  }

  class TimeHelper{
    static String getValue(Time time){
      switch(time){
        case Time.annual:
          return 'Annual';
        case Time.biannual:
          return 'Biannual';
        case Time.bimonth:
          return 'Bimonth';
        case Time.biweek:
          return 'Biweek';
        case Time.day:
          return 'Day';
        case Time.month:
          return 'Month';
        case Time.week:
          return 'Week';  
        default:
          return '';
      }
    }

  }
class HabitGoal {
  final int id;
  final int habitId;
  final String timeFrame;
  final int goalValue;
  final bool active;
  final String notes;

  HabitGoal(this.id, this.habitId, this.timeFrame, this.goalValue, this.active, this.notes);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId' : habitId,
      'timeFrame': timeFrame,
      'goalValue': goalValue,
      'active': active,
      'notes': notes,
    };
  }
}