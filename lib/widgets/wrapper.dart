import 'package:Rely/basicDetails/basic_details.dart';
import 'package:Rely/widgets/splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Rely/widgets/home/home.dart';
import 'package:Rely/widgets/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WrapperState();
  }
}

class WrapperState extends State<Wrapper> {
  bool exists;
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user == null)
      return Authenticate();
    else {
      if (exists == null) {
        FirebaseDatabase.instance
            .reference()
            .child('Users')
            .child(user.uid)
            .once()
            .then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            setState(() {
              exists = true;
            });
          } else {
            exists = false;
          }
        });
      }
      if (exists == null)
        return Splashscreen();
      else {
        if (!exists) {
          return BasicDetails();
        } else {
          return Home();
        }
      }
    }
  }
}
