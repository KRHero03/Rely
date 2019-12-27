import 'dart:async';
import 'package:Rely/services/auth.dart';
import 'package:Rely/widgets/intro/intro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Rely/widgets/wrapper.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
    runApp(new MyApp());
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
     value: AuthService().user,
     child: MaterialApp(
       theme: ThemeData(
         primaryColor: Color(0xff4564e5),
         accentColor: Color(0xff4edbf2),
       ),
       home: Splash()
     )
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

    if (_seen) {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new Wrapper())); //Change Intro to Wrapper
    } else {
    prefs.setBool('seen', true);
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new Intro()));
    }
}

@override
void initState() {
    super.initState();
    checkFirstSeen();    
}

@override
Widget build(BuildContext context) {
    return new Scaffold(
    body: new Container(
      width: MediaQuery.of(context).size.width,
      height:MediaQuery.of(context).size.height,
      color: Color(0xff4564e5)
    )
    );
}
}

