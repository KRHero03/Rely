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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StreamProvider<FirebaseUser>.value(
        value: AuthService().user,
        child: MaterialApp(
            theme: ThemeData(
              primaryColor: Color(0xff4564e5),
              accentColor: Color(0xff4edbf2),
            ),
            home: Splash()));
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
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new Wrapper())); //Change Intro to Wrapper
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
    return Scaffold(
        body: Container(
            color: Color(0xff4564e5),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Image(
                  image:
                      AssetImage('assets/images/Splashscreen/Splashscreen.png'),
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Rely',
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'We\'ll be there for you...',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Handwritten',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(top: 30, bottom: 5, left: 5, right: 5),
                    child: Text(
                      'Please wait while we load Rely for you...',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )));
  }
}
