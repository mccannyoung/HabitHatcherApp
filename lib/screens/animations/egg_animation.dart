import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class EggAnimation extends StatefulWidget {
  _EggAnimationState createState() => _EggAnimationState();
}

class _EggAnimationState extends State<EggAnimation>
    with SingleTickerProviderStateMixin {
  List<String> assetNames = <String>[
    'assets/egg1.svg',
  ];

  Animation<double> animation;

  AnimationController aCtlr;

  @override
  void initState() {
    super.initState();
    aCtlr = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    final cAnime = CurvedAnimation(curve: Curves.bounceIn, parent: aCtlr, reverseCurve: Curves.bounceIn,);
    
    animation = Tween<double>(
      begin: 0,
      end: 0.6 * math.pi,
    ).animate(cAnime)
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status){
        if (status == AnimationStatus.completed) {
          aCtlr.reverse();
        } else if (status == AnimationStatus.dismissed) {
          aCtlr.forward();
        }
      });

    aCtlr.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: animation.value,
      child: Container(
        alignment: Alignment.center,
        child: SvgPicture.asset(assetNames[0]),
      ),
    );
  }

  @override
  void dispose() {
    aCtlr.dispose();
    super.dispose();
  }
}
