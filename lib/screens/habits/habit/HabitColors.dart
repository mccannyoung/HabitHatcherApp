import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitColors extends StatefulWidget {
  HabitColors({Key key}) : super(key: key);

  @override
  _HabitColorsState createState() => _HabitColorsState();
}

class _HabitColorsState extends State<HabitColors> {
  List<String> selectedColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        children: <Widget>[
          new Text('Select any colors you want this habit associated with'),
          new LabeledCheckbox(
              label: 'blue',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: false,
              color: Colors.blueAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors.add("blue");
              }),
          new LabeledCheckbox(
              label: 'red',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: false,
              color: Colors.redAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors.add("red");
              }),
          new LabeledCheckbox(
              label: 'green',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: false,
              color: Colors.greenAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors.add('green');
              }),
          new LabeledCheckbox(
              label: 'orange',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: false,
              color: Colors.orangeAccent,
              onChanged: (val) {
                print("this happened");
                selectedColors.add('orange');
              }),
          new LabeledCheckbox(
              label: 'yellow',
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: false,
              color: Colors.yellow,
              onChanged: (val) {
                print("this happened");
                selectedColors.add('yellow');
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
