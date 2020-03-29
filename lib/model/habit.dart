class Habit {
  final int id;
  final String description;
  final int streak;
  final double grade;
  final String notes;

  Habit({this.id, this.description, this.streak, this.grade, this.notes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description' : description,
      'streak': streak,
      'grade': grade,
      'notes': notes,
    };
  }
}