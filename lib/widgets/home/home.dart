import 'package:Rely/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    _signOut() {
      _auth.signOut(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff3f5ff),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/logo/round.png',
              width: 50,
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child:  Text(
              'Rely',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Standard',
                color: Color(0xff4564e5),
              ),
              textAlign: TextAlign.center,
            ),
            )
           
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
          color: Color(0xff4564e5),
          child: new Column(
            children: <Widget>[
              Text('Home'),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: _signOut, //since this is only a UI app
                    child: Text(
                      'SIGN IN WITH ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Color(0xff4edbf2),
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
            ],
          )),
    );
  }
}
