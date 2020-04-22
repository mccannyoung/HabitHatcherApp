import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:habithatcher/screens/habits/AddHabit.dart';
import 'package:habithatcher/screens/habits/HabitList.dart';

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

const List<String> assetNames = <String>[
  'assets/egg1.svg',
];

var random = new Random.secure();

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
      body: Column(
        
         mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
                 quotes[random.nextInt(quotes.length)].toString(),
             ),
             SvgPicture.asset(
                 assetNames[0]
               ),
               MaterialButton(
                 child: Text('Go to Your Habits'),
                 onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => new HabitList())
                       );
                 }
               ),
             // HabitListWidget(),
              new Align(
                 alignment: FractionalOffset.bottomCenter,
                 child: 
                   MaterialButton( 
                     child: Text('Add a new habit to track'),
                     onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => new AddHabit())
                       );
                     }
                   ),
               ),
          ],
        ),
    );
  }
}
