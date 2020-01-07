import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title, message;
  CustomAlertDialog({this.title, this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Color(0xfff3f5ff),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title:new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/logo/round.png',
              width: 50,
              height: 50,
            ),
            Flexible(
              
              child:Text(
              this.title,
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Standard',
                color: Color(0xff4564e5),
              ),
              textAlign: TextAlign.left,
            ),
            )
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  this.message,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Standard',
                    color: Color(0xff4564e5),
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, //since this is only a UI app
                  child: Text(
                    'OKAY',
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
        ));
  }
}
