class HabitGoal {
  final int id;
  int habitId;
  final DateTime goalStart;
  final DateTime goalEnd;
  final String timeFrame;
  final int goalValue;
  final String handicap;

  HabitGoal({this.id, this.habitId, this.goalStart, this.goalEnd, this.timeFrame, this.goalValue, this.handicap});

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'habitId' : habitId,
  //     'goalStart': goalStart,
  //     'goalEnd':goalEnd,
  //     'timeFrame': timeFrame,
  //     'goalValue': goalValue,
  //     'handicap': handicap,
  //   };
  // }

  prettyPrint() {
    return 'id: '+id.toString() + ', habitId: '+ habitId.toString() +  ', timeFrame: '+ timeFrame.toString() + ', goalValue :'+ goalValue.toString() +', handicap: '+ handicap.toString();
  }
}