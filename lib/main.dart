import 'package:Rely/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:Rely/widgets/wrapper.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
     value: AuthService().user,
     child: MaterialApp(
       theme: ThemeData(
         primaryColor: Color(0xff4564e5),
         accentColor: Color(0xff4edbf2),
       ),
       home: Wrapper()
     )
   );
  }
}

