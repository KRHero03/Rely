import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Color(0xff4564e5),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/Splashscreen/Splashscreen.png'),
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text('Rely',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,)),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text('We\'ll be there for you...',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Handwritten',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,)),
            Padding(
                padding: EdgeInsets.only(top: 30, bottom: 5, left: 5, right: 5),
                child: Text('Please wait while we load Rely for you...',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    ),
                    textAlign: TextAlign.center,
                    )),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ))
    );
  }
}

