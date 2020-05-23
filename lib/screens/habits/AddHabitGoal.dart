import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//import 'package:habithatcher/model/habit.dart';
import 'package:habithatcher/model/habit_goal.dart';

 class AddHabitGoal extends StatefulWidget {
   AddHabitGoal({Key key, this.habitGoal, this.updateGoal}) : super(key: key);
   final HabitGoal habitGoal;
   final  Function(HabitGoal) updateGoal;
   @override
   _AddHabitGoalState createState() => new _AddHabitGoalState();
 }

class _AddHabitGoalState extends State<AddHabitGoal> {
  //class AddHabitGoal extends StatelessWidget{
  final List<String> timeLengths = ['Day', 'Week', 'Month', 'Year'];
  final List<String> noValues = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'];
  final List<String> levels = ['Easy', 'Medium', 'Hard', 'Impossible'];
  int goalValue;
  String timeFrame;
  String handicap;
  HabitGoal goal;

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    goal = this.widget.habitGoal;    
  }

  @override
  Widget build(BuildContext context) {
   
    return new Container(
      child: Column(children: [
        new Text('Goal'),
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                new DropdownButton(
                  hint: Text('XX'), 
                  value: goalValue, 
                  items: this.noValues.map((String value){
                    return new DropdownMenuItem(child: new Text(value), value: int.parse(value));
                  }).toList(),
                  onChanged: (val) {
                    print('updating goal value');
                    print("old goal: ");
                    print(goal.prettyPrint());
                    setState(() {
                      this.goalValue = int.parse(val.toString());
                      this.goal = new HabitGoal(id: this.goal.id, habitId: this.goal.habitId, timeFrame: this.goal.timeFrame, goalValue: this.goalValue, handicap: this.goal.handicap);
                    });
                    print("new goal: ");
                    print(goal.prettyPrint());
                    this.widget.updateGoal(goal);
                  }
                ),
              //),
              new Text('per'),
              new DropdownButton(
                hint: Text('Day/Week/Month/Year'),
                value: timeFrame,
                items: this.timeLengths.map((String value) {
                  return new DropdownMenuItem(
                    child: new Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    timeFrame = val;
                  });
                  print('updating timeFrame');
                  print("old goal: ");
                  print(goal.prettyPrint());
                  goal = new HabitGoal(id:  goal.id, habitId: goal.habitId, timeFrame: val, goalValue: goal.goalValue, handicap: goal.handicap);
                  print("new goal: ");
                  print(goal.prettyPrint());
                  this.widget.updateGoal(goal);
                },
              ),
            ]),
             SizedBox(height: 15),
        new Text('How hard is it?'),
        new DropdownButton(
            //hint:  Text('pick a difficulty level, this will impact how forgiving the app is'),
            value: handicap,
            items: this.levels.map((String value) {
              return new DropdownMenuItem(
                child: new Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                handicap = val;
              });
              print('updating difficulty');
              print("old goal: ");
              print(goal.prettyPrint());
              goal = new HabitGoal(id: goal.id, habitId: goal.habitId, timeFrame: goal.timeFrame, goalValue: goal.goalValue, handicap: val);
              print("new goal: ");
              print(goal.prettyPrint());
              this.widget.updateGoal(goal);
            }),
      ]),
    );
  }
}
