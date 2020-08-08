import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';

 class HabitGoalScreen extends StatelessWidget{ //StatefulWidget {
   HabitGoalScreen({Key key, this.habitGoal, this.updateGoal}) : super(key: key);
   final HabitGoal habitGoal;
   final  Function(HabitGoal) updateGoal;
 
    final List<String> timeLengths = ['Day', 'Week', 'Month', 'Year'];
    final List<String> noValues = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'];
    final List<String> levels = ['Easy', 'Medium', 'Hard', 'Impossible'];

  @override
  Widget build(BuildContext context) {
    //goalValue = habitGoal.goalValue;
    //timeFrame = habitGoal.timeFrame;

    return Container(
      width: MediaQuery. of(context). size. width-20,
      child: new Column(
        children: [
         Text('Goal'),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Container(
                  width: 45,
                  child: new DropdownButtonFormField(
                    hint: Text('XX'), 
                    value: habitGoal == null? null: habitGoal.goalValue, 
                    items: this.noValues.map((String value){
                      return new DropdownMenuItem(child: Text(value), value: int.parse(value));
                    }).toList(),
                    onChanged: (val) {
                      print('updating goal value');
                      print("old goal: ");
                      print(habitGoal.prettyPrint());
                      
                        habitGoal.goalValue = int.parse(val.toString());
                       // habitGoal = new HabitGoal(id: this.habitGoal.id, habitId: this.goal.habitId, timeFrame: this.goal.timeFrame, goalValue: this.goalValue, handicap: this.goal.handicap);
                      print(habitGoal.prettyPrint());
                      this.updateGoal(habitGoal);

                      }, 
                    validator: (int value) {
                      print('or here?');
                        if (value == null && this.habitGoal.timeFrame != null) {
                          return 'Please pick a value';
                        }
                        return null;
                      },
                  ),
                ),
              //),
              new Text('per'),
              Container(
                width: 200,
                child:  DropdownButtonFormField(
                  hint: Text('Day/Week/Month/Year'),
                  value: habitGoal == null ? null : habitGoal.timeFrame,
                  items: this.timeLengths.map((String value) {
                    return new DropdownMenuItem(
                      child: new Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (val) {

                    print('updating timeFrame');
                    print("old goal: ");
                    print(habitGoal.prettyPrint());
                    habitGoal.timeFrame = val;
                    print("new goal: ");
                    print(habitGoal.prettyPrint());
                    this.updateGoal(habitGoal);
                  },
                  validator: (String value) {
                        print('am I here?');
                        if (value?.isEmpty ?? true && this.habitGoal.goalValue != null) {
                          return 'Please pick a value';
                        }
                        return null;
                      },
                ),
              ),
            ]),
             SizedBox(height: 15),
        new Text('How hard is it?'),
        Container(
          width: 500,
          child: new DropdownButtonFormField(
              //hint:  Text('pick a difficulty level, this will impact how forgiving the app is'),
              value: habitGoal == null ? null: habitGoal.handicap,
              items: this.levels.map((String value) {
                return new DropdownMenuItem(
                  child: new Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (val) {
                print('updating difficulty');
                print("old goal: ");
                print(habitGoal.prettyPrint());
                habitGoal.handicap = val;
                print("new goal: ");
                print(habitGoal.prettyPrint());
                this.updateGoal(habitGoal);
              }),
        ),
      ]),      
    );
  }
}
