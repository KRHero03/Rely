import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Authentication Firebase Object

  String verificationIdS;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Create User object from FirebaseUser object
  FirebaseUser _getUser(FirebaseUser user) {
    return user == null
        ? null
        : user; //Function is used to instantiate User object from FirebaseUser instance.
  }

  //When Authentication is Done, Stream is used to notify wrapper.
  Stream<FirebaseUser> get user {
    
    return _auth.onAuthStateChanged.map(
        _getUser); //Maps FirebaseUser Instance to custom User instance using _getUser function.
    //It is the same process as Pipelining. The Auth instance provides a FirebaseUser Object
    //that is passed into _getUser which returns User object.
  }


  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

 


  Future<FirebaseUser> signInWithPhoneCredential(AuthCredential credential) async{
   AuthResult result = await _auth.signInWithCredential(credential);
   return result.user;
  }
  signOut(BuildContext context) {
    try {
      _auth.signOut();
      Fluttertoast.showToast(
          msg: "You have successfully signed out!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Color(0xfff3f5ff),
          fontSize: 16.0);
    } catch (error) {
      print(error);
    }
  }
}
