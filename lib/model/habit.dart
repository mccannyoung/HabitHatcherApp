class Habit {
  
  final String description;
  final String notes;

  Habit( this.description, this.notes);
  
  Map<String, dynamic> toMap() {
    return {
      'description' : description,
      'notes': notes,
    };
  }
}