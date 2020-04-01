class HabitHistory {
  final int id;
  final int habitId;
  final DateTime date;
  final int value;
  final String notes;

  HabitHistory({this.id, this.habitId, this.date, this.value, this.notes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId' : habitId,
      'date': date,
      'value': value,
      'notes': notes,
    };
  }
}