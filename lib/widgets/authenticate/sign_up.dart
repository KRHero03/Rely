import 'package:Rely/widgets/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUp extends StatefulWidget {

  

  

  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return SignUpScreen();
  }
}

class SignUpScreen extends StatelessWidget {
  @override


  Widget build(BuildContext context) {
    void _pushSignIn() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(body: SignIn())));
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
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              children: <Widget>[
                Text('Let\'s get started!',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Standard',
                      color: Color(0xff4564e5),
                    ),
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('First of all, tell us your Email ID...',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                      ),
                      textAlign: TextAlign.left),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
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
                    ),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text(
                      'SIGN UP',
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
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontFamily: 'Standard',
                              color: Color(0xff4564e5),
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          new GestureDetector(
                              onTap: _pushSignIn,
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontFamily: 'Standard',
                                    color: Color(0xff4edbf2),
                                    fontSize: 15,
                                    decoration: TextDecoration.underline),
                                textAlign: TextAlign.center,
                              ))
                        ],
                      )),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

}
