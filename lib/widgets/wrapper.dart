import 'package:Rely/models/user.dart';
import 'package:flutter/material.dart';
import 'package:Rely/widgets/home/home.dart';
import 'package:Rely/widgets/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    if(user  == null)
      return Authenticate();
    else
      return Home();
  }
  
}