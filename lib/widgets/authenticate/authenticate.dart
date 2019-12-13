import 'package:flutter/material.dart';
import 'package:Rely/widgets/authenticate/sign_in.dart';
class Authenticate extends StatefulWidget{
  @override
    _AuthenticateState createState() => _AuthenticateState();
  

}

class _AuthenticateState extends State<Authenticate>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(      
      body: SignIn(), //Used to call SignIn Widget. Check out sign_in.dart 
    );
  }

}