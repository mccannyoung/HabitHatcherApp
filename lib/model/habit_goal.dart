class HabitGoal {
  final int id;
  final int habitId;
  final String timeFrame;
  final int goalValue;
  final bool active;
  final String notes;

  HabitGoal({this.id, this.habitId, this.timeFrame, this.goalValue, this.active, this.notes});

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