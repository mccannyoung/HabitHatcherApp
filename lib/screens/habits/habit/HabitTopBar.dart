import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddHabitTopBar extends StatefulWidget {
  final Function(int) updateFn;
  AddHabitTopBar({Key key, this.updateFn}) : super(key: key);

  @override
  _AddHabitTopBarState createState() => _AddHabitTopBarState();
}

class _AddHabitTopBarState extends State<AddHabitTopBar> {
  var isSelected = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return new ToggleButtons(
      disabledBorderColor: Colors.transparent,
      fillColor: Colors.lightBlueAccent,

      children: <Widget>[
        new Container(
          width: (MediaQuery.of(context).size.width - 40) / 4,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            new Icon(Icons.info_outline, size: 24.0),
            new Text('Info'),
          ]),
        ),
        new Container(
          width: (MediaQuery.of(context).size.width - 40) / 4,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            new Icon(Icons.sentiment_very_satisfied, size: 24.0),
            new Text('Goal'),
          ]),
        ),
        new Container(
          width: (MediaQuery.of(context).size.width - 40) / 4,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            new Icon(Icons.palette, size: 24.0),
            new Text('Colors'),
          ]),
        ),
        new Container(
          width: (MediaQuery.of(context).size.width - 40) / 4,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            new Icon(Icons.alarm, size: 24.0),
            new Text('Reminder', textAlign: TextAlign.center,),
          ]),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
            }
          }
        });
        this.widget.updateFn(index);
      },
      isSelected: isSelected,
    );
  }
}
