class Habit {
  
  final int id;
  final String description;
  final String notes;

  Habit( this.id, this.description, this.notes);
  
  Map<String, dynamic> toMap() {
    return {
      'description' : description,
      'notes': notes,
    };
  }
}