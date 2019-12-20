import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:Rely/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //Authentication Firebase Object

  String verificationIdS;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create User object from FirebaseUser object
  User _getUser(FirebaseUser user) {
    return user == null
        ? null
        : User(
            uid: user
                .uid); //Function is used to instantiate User object from FirebaseUser instance.
  }

  //When Authentication is Done, Stream is used to notify wrapper.
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(
        _getUser); //Maps FirebaseUser Instance to custom User instance using _getUser function.
    //It is the same process as Pipelining. The Auth instance provides a FirebaseUser Object
    //that is passed into _getUser which returns User object.
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      User userModel = _getUser(user);
      userModel.email = user.email;

      return userModel;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult result = await _auth.signInWithCredential(credential);

      FirebaseUser user = result.user;
      User userModel = _getUser(user);
      userModel.email = user.email;
      return userModel;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<User> signInWithFacebook() async {
    try {
      final facebookLogin = new FacebookLogin();
      final facebookLoginResult = await facebookLogin
          .logInWithReadPermissions(['email', 'public_profile']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          break;

        case FacebookLoginStatus.cancelledByUser:
          break;

        case FacebookLoginStatus.loggedIn:
          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');
          var profile = json.decode(graphResponse.body);
          List<String> signInMethods =
              await _auth.fetchSignInMethodsForEmail(email: profile['email']);
          print(signInMethods);
          if (signInMethods.isEmpty) {
            AuthCredential credential = FacebookAuthProvider.getCredential(
                accessToken: facebookLoginResult.accessToken.token);
            final AuthResult result =
                await _auth.signInWithCredential(credential);
            FirebaseUser user = result.user;
            User userModel = _getUser(user);
            userModel.email = profile['email'];
            userModel.username = profile['name'];
            userModel.online = '1';
          } else {
            return null;
          }

          return null;
      }

      return null;
    } catch (error) {
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
          backgroundColor: Color(0xff4564e5),
          textColor: Color(0xfff3f5ff),
          fontSize: 16.0);
    } catch (error) {
      print(error);
    }
  }
}