import 'package:Rely/basicDetails/basic_details.dart';
import 'package:Rely/models/user.dart';
import 'package:flutter/material.dart';
import 'package:Rely/widgets/home/home.dart';
import 'package:Rely/widgets/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var exists = false;
    if (user == null)
      return Authenticate();
    else {
      print(user.uid);
      FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(user.uid)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) exists = true;
      });

      if (!exists) {
        return BasicDetails();
      } else {
        return Home();
      }
    }
  }
}
