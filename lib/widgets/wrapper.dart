
import 'package:Rely/widgets/home.dart';
import 'package:Rely/widgets/splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Rely/widgets/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'basic_details/basic_details.dart';

class Wrapper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WrapperState();
  }
}

class WrapperState extends State<Wrapper> {
  bool exists;
  bool reloaded = false;
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (reloaded == false) {
      if(user!=null)
        user.reload();
      reloaded = true;
    }
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
            setState(() {              
              exists = false;
            });
          }
        });
      }
      if (exists == null) {
        return Splashscreen();
      } else {
        if (exists == true) {
          return Home();
        } else {
          return BasicDetails();
        }
      }
    }
  }
}
