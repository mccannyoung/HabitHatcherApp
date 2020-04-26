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

  enum Handicap{
    easy,
    normal,
    hard,
    impossible
  }
  class HanicapHelper{
      static String getValue(Handicap handicap) {
        switch(handicap){
          case Handicap.easy:
            return 'Easy';
          case Handicap.hard:
            return 'Hard';
          case Handicap.impossible:
            return 'Impossible';
          default:
            return 'Normal';
        }
      }
  }
class HabitGoal {
  final int id;
  final int habitId;
  final String goalStart;
  final String goalEnd;
  final String timeFrame;
  final int goalValue;
  final String handicap;

  HabitGoal({this.id, this.habitId, this.goalStart, this.goalEnd, this.timeFrame, this.goalValue, this.handicap});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId' : habitId,
      'goalStart': goalStart,
      'goalEnd':goalEnd,
      'timeFrame': timeFrame,
      'goalValue': goalValue,
      'handicap': handicap,
    };
  }
}