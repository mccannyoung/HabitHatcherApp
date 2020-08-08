import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitColors extends StatelessWidget {

  List<String> habitColors;
  var selectedColors = new Map();
  final  Function(List<String>) updateColors;

  HabitColors({Key key, this.habitColors, this.updateColors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (habitColors == null )
      habitColors = new List<String>();
      
    if (selectedColors.isEmpty){
      if(habitColors!=null)
        selectedColors = {
          'blue': habitColors.contains('blue'),
          'red': habitColors.contains('red'), 
          'green': habitColors.contains('green'),
          'orange': habitColors.contains('orange'),
          'yellow': habitColors.contains('yellow'),
        };

      else{
        selectedColors = {
          'blue': false,
          'red': false, 
          'green': false,
          'orange': false,
          'yellow': false,
        };
      }
    }
    return Container(
      child: new Column(
        children: <Widget>[
          new Text('Select any colors you want this habit associated with'),
          new LabeledCheckbox(
              label: 'blue',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: selectedColors['blue'],
              color: Colors.blueAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors['blue']=val;
                if (val)
                  habitColors.add('blue');
                else
                  habitColors.remove('blue');
                this.updateColors(habitColors);
              }),
          new LabeledCheckbox(
              label: 'red',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: selectedColors['red'],
              color: Colors.redAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors['red'] = val;
                if (val)
                  habitColors.add('red');
                else
                  habitColors.remove('red');
                this.updateColors(selectedColors.keys);
              }),
          new LabeledCheckbox(
              label: 'green',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: selectedColors['green'],
              color: Colors.greenAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors['green'] = val;
                if (val)
                  habitColors.add('green');
                else
                  habitColors.remove('green');
                this.updateColors(selectedColors.keys);
              }),
          new LabeledCheckbox(
              label: 'orange',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: selectedColors['orange'],
              color: Colors.orangeAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors['orange'] = val;
                if (val)
                  habitColors.add('orange');
                else
                  habitColors.remove('orange');
                this.updateColors(selectedColors.keys);
              }),
          new LabeledCheckbox(
              label: 'yellow',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: selectedColors['yellow'] ,
              color: Colors.yellow,
              onChanged: (val) {
                print("this happened");
                selectedColors['yellow'] = val;
                if (val)
                  habitColors.add('yellow');
                else
                  habitColors.remove('yellow');
                this.updateColors(selectedColors.keys);
              }),
        ],
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
    this.color,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            new Container(
              decoration: ColorCircle(color: color, radius: 6.0),
              width: 20,
            ),
            Expanded(
              child: new Text(label),
            ),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ColorCircle extends Decoration {
  final BoxPainter _painter;

  ColorCircle({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
