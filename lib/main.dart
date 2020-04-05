import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:habithatcher/screens/home/Introduction.dart';
import 'package:habithatcher/screens/home/MyHomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hatch a New Habit',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new Splash(), // Not realy home, but it's the first spot we're going. 
    );
  }
}

class Splash extends StatefulWidget {
  @override 
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if(_seen) {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new MyHomePage())
      );
      
    }else{
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder:  (context) => new IntroScreen())
      );
    }
  }

  @override 
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 2000), () {
      checkFirstSeen();
    });
  }
  
  @override 
  Widget build(BuildContext context) {
    return new Scaffold(
      body:  Center(
        child:  Text('Loading Habits...'),
      ),
    );
  }
}

