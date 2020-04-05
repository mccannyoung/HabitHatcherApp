import 'package:flutter/material.dart';
import 'package:habithatcher/screens/home/MyHomePage.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisSize:  MainAxisSize.min,
          children: <Widget>[
            Text('This is the intro page'),
            MaterialButton( 
              child: Text('Go to home page'),
               onPressed: () {
                   Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => new MyHomePage()));
                }
              ),
          ],
        ),
      )
    );
  }
}