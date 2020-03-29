import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math';

void main() => runApp(MyApp());

const List<String> assetNames = <String>[
  'assets/egg1.svg',
];

var random = new Random.secure();

const List<String> quotes = [
' "We become what we repeatedly do."\n\n\t - Sean Covey',
 '“The chains of habit are too weak to be felt until they are too strong to be broken.”\n\n\t― Samuel Johnson',
'“A nail is driven out by another nail; habit is overcome by habit.”\n\n\t ― Erasmus',
'“Nothing so needs reforming as other people\'s habits.”\n\n\t ― Mark Twain',
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hatch a New Habit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  Future loadHabitData() async {


  }
  @override 
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 2000), () {
      checkFirstSeen();
      loadHabitData();
    });
  }
  @override 
  Widget build(BuildContext context) {
    return new Scaffold(
      body:  Center(
        child:  SvgPicture.asset(assetNames[0]), //Text('Loading...'),
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Hatcher App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              quotes[random.nextInt(3)].toString(),//'"We become what we repeatedly do." - Sean Covey',
            ),
            SvgPicture.asset(
                assetNames[0]
              ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(assetNames[0]),
            Text(
              '"We become what we repeatedly do."\n\n\t - Sean Covey',
            ),
          ],
        ),
      ),
    );
  }
}

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
                      new MaterialPageRoute(builder: (context) => new Home()));
           }
      ),
      ]
      ,),));
  }
}