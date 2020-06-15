import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:habithatcher/screens/home/Introduction.dart';
import 'package:habithatcher/screens/home/MyHomePage.dart';

void main() => runApp(new MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override 
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @mustCallSuper
  @override 
  void initState() {
    super.initState();
    // flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    // var iOs = new IOSInitializationSettings();
    // var initSettings = new InitializationSettings(android, iOs);
    // flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

  }

//  Future 
onSelectNotification(String payload){
      debugPrint("payload: $payload");
      showDialog(context: context, builder: (_)=> new AlertDialog(title: new Text('Payload'), content: new Text('$payload')));
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    MaterialApp(
      title: 'Hatch a New Habit',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        
    ),
          home: new Splash(), 
      //body: new Column (

//        children:[ EggAnimation(),
  //      new RaisedButton(onPressed: showNotification, 
    //  child: new Text('Demo', style: Theme.of(context).textTheme.headline3),),
      //  ]
     // ),
// Not realy home, but it's the first spot we're going. 
    );
    }
    showNotification() async {
      var android = new AndroidNotificationDetails('channel id', 'channel name', 'CHANNEL DESCRIPTION');
      var iOS = new IOSNotificationDetails();
      var platform = new NotificationDetails(android, iOS);
      await  flutterLocalNotificationsPlugin.show(0, 'NewVideo is out', 'Flutter local notification', platform, payload: 'remember to do your habit for your goal');
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
      body:  new Center(

        child: new Text('Loading Habits...'),

      ),
    );

  }
  

}

