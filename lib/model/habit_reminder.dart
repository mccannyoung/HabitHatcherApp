class HabitReminder {
  final int id;
  final int habitId;
  final String timeOfDay;
  final int dayOfWeek;
  final int dayOfMonth;
  final int weekOfMonth;
  final int monthOfYear;

  HabitReminder(
      {this.id,
      this.habitId,
      this.timeOfDay,
      this.dayOfWeek,
      this.dayOfMonth,
      this.weekOfMonth,
      this.monthOfYear});

  prettyPrint() {
    return 'id: ' +
        id.toString() +
        ', habitId: ' +
        habitId.toString() +
        ', timeOfDay: ' +
        timeOfDay.toString() +
        ', dayOfWeek: ' +
        dayOfWeek.toString() +
        ', dayOfMonth: ' +
        dayOfMonth.toString() +
        ', weekOfMonth: ' +
        weekOfMonth.toString() +
        ', monthOfYear: ' +
        monthOfYear.toString();
  }
}
