import 'package:Rely/models/user.dart';
import 'package:Rely/services/auth.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/authenticate/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignIn extends StatefulWidget {
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isPhoneSignIn = false;
  bool error;
  String errorMessage;
  String email = '';
  String password = '';
  final AuthService _auth = AuthService();

  void _onSwitchSignInMode() {
    setState(() {
      _isPhoneSignIn = !_isPhoneSignIn;
    });
  }

  _signInWithEmailandPassword() async {
    User result = await _auth.signInWithEmailAndPassword(email, password);    
    if (result == null) {
      return showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
                title: 'Rely - Email Sign In',
                message:
                    'You have entered incorrect Email or Password! Try again.');
          });
    } else {
    print(result.email);
    }
  }

  _signInWithGoogle() async {
    User result = await _auth.signInWithGoogle();    
    print(result.email);
    if (result == null) {
      return showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
                title: 'Rely - Google Sign In',
                message: 'Your Google Sign In has failed! Try again.');
          });
    } else {
      print(result.email);
    }
  }

  _signInWithFacebook() async {
    User result = await _auth.signInWithFacebook();
    if (result == null) {
      return showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
                title: 'Rely - Facebook Sign In',
                message: 'Your Facebook Sign In has failed due to incorrect credentials or existing user with same Email.');
          });
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    void _pushSignUp() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(body: SignUp())));
    }

    return Stack(
      children: <Widget>[
        Container(
            color: Color(0xff4564e5),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/logo/round.png',
                  width: 100,
                  height: 100,
                ),
                Text('Rely',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    )),
                Text('We\'ll be there for you...',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Handwritten',
                      color: Color(0xfff3f5ff),
                    )),
                Text('One stop app for all your dairy products.',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Standard',
                      color: Color(0xfff3f5ff),
                    )),
              ],
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 270),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              children: <Widget>[
                Text('Sign In to your Rely Account',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Standard',
                      color: Color(0xff4564e5),
                    ),
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: _isPhoneSignIn
                        ? null
                        : TextFormField(
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Standard'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  MdiIcons.email,
                                  color: Color(0xff4564e5),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  color: Color(0xff4564e5),
                                )),
                            onChanged: (val) {
                              email = val;
                            },
                          ),
                  ),
                ),
                Container(
                  color: Color(0xfff3f5ff),
                  child: _isPhoneSignIn
                      ? null
                      : TextFormField(
                          obscureText: true,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Standard'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              prefixIcon: Icon(
                                MdiIcons.lock,
                                color: Color(0xff4564e5),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Standard',
                                color: Color(0xff4564e5),
                              )),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _isPhoneSignIn
                      ? MaterialButton(
                          onPressed: () {}, //since this is only a UI app
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'SIGN IN WITH ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(MdiIcons.phone),
                            ],
                          ),
                          color: Color(0xff4edbf2),
                          elevation: 0,
                          minWidth: 400,
                          height: 50,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : MaterialButton(
                          onPressed: _signInWithEmailandPassword,
                          child: Text(
                            'SIGN IN',
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
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _isPhoneSignIn
                      ? null
                      : Text(
                          'Forgot Your Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Standard',
                              color: Color(0xff4edbf2),
                              fontSize: 15,
                              decoration: TextDecoration.underline),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontFamily: 'Standard',
                              color: Color(0xff4564e5),
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          new GestureDetector(
                              onTap: _pushSignUp,
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontFamily: 'Standard',
                                    color: Color(0xff4edbf2),
                                    fontSize: 15,
                                    decoration: TextDecoration.underline),
                                textAlign: TextAlign.center,
                              ))
                        ],
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _isPhoneSignIn
                      ? MaterialButton(
                          onPressed: _onSwitchSignInMode,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'SIGN IN WITH ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(MdiIcons.email),
                            ],
                          ),
                          color: Color(0xff4edbf2),
                          elevation: 0,
                          minWidth: 400,
                          height: 50,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : MaterialButton(
                          onPressed: _onSwitchSignInMode,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'SIGN IN WITH ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(MdiIcons.phone),
                            ],
                          ),
                          color: Color(0xff4edbf2),
                          elevation: 0,
                          minWidth: 400,
                          height: 50,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed:
                        _signInWithFacebook, //since this is only a UI app
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'SIGN IN WITH ',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Standard',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(MdiIcons.facebookBox),
                      ],
                    ),
                    color: Color(0xff3b5998),
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: MaterialButton(
                    onPressed: _signInWithGoogle, //since this is only a UI app
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'SIGN IN WITH ',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Standard',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(MdiIcons.google),
                      ],
                    ),
                    color: Color(0xff4285F4),
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

}
