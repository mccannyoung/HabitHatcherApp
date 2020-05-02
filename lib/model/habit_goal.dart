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

  prettyPrint() {
    return 'id: '+id.toString() + ', habitId: '+ habitId.toString() +  ', timeFrame: '+ timeFrame + ', goalValue :'+ goalValue.toString() +', handicap: '+ handicap;
  }
}