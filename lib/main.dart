import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math';

import 'model/habit.dart';
import 'database/database.dart' as db;

import 'screens//habits/AddHabit.dart';

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
'"Quailty is not an act, it is a habit."\n\n\t ― Aristotle ',
'"Make a habit of two things: to help; or at least to do no harm."\n\n\t ― Hippocrates',
'"Repetition of the same thought or physical action develops into a habit which, repeated frequently enough, becomes an automatic reflex."\n\n\t ― Norman Vincent Peale',
'"And once you understand that habits can change, you have the freedom and the responsibility to remake them."\n\n\t ― Charles Duhigg',
'"Drop by drop is the water pot filled."\n\n\t ― Buddha',
'"Feeling sorry for yourself, and your present condition is not only a waste of energy but the worst habit you could possibly have."\n\n\t ― Dale Carnegie',
'"First forget inspiration. Habit is more dependable. Habit will sustain you whether you’re inspired or not."\n\n\t ― Octavia Butler',
'"Let today be the day you give up who you\'ve been for who you can become."\n\n\t ― Hal Elrod',
];

String habitList = "fetching habits";

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

  Future loadHabitData() async {
      var dbHelper = db.DBHelper();
      List<Habit> habits = await dbHelper.getHabits();
      if (habits.length == 0 ){
        habitList = "You have no habits. Please add some to start growing.";
      } else  if (habits.length == 1) {
        habitList = "Your habit is: \n";
        habitList = habitList +  habits[0].description ;
      } else{
        habitList = "Your habits are: ";
        for (Habit habit in habits) {
          habitList = habitList + "\n  "+ habit.description;
        }
      }
  }
  @override 
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 2000), () {
      loadHabitData();
      checkFirstSeen();
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
              quotes[random.nextInt(quotes.length)].toString(),
            ),
            SvgPicture.asset(
                assetNames[0]
              ),
              Text(
                habitList,
              ),
              MaterialButton( 
              child: Text('Add a new habit to track'),
               onPressed: () {
                   Navigator.push(
                     context,
                      MaterialPageRoute(builder: (context) => new AddHabit()));
           }
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
                      new MaterialPageRoute(builder: (context) => new MyHomePage()));
           }
      ),
      ]
      ,),));
  }
}