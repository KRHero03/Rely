import 'dart:io';

import 'package:Rely/models/user.dart';
import 'package:Rely/services/auth.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignIn extends StatefulWidget {
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String phoneNumber = "";
  bool _buttonPressed = false;
  final AuthService _auth = AuthService();
  String verificationID;
  final phoneController = TextEditingController();
  Country _selected = Country.IN;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            color: Color(0xfff3f5ff),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('Let\'s get Started...',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                      ),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('First of all, tell us your Phone number!',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                      ),
                      textAlign: TextAlign.left),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          alignment: Alignment.center,
                          width: 150,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xff4564e5)),
                          ),
                          child: CountryPicker(
                            dense: false,
                            showFlag: true,
                            showDialingCode: true,
                            showName: true,
                            showCurrency: false,
                            showCurrencyISO: false,
                            dialingCodeTextStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Standard',
                              color: Color(0xff4564e5),
                            ),
                            nameTextStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Standard',
                              color: Color(0xff4564e5),
                            ),
                            onChanged: (Country country) {
                              setState(() {
                                _selected = country;
                              });
                            },
                            selectedCountry: _selected,
                          ),
                        ),
                        TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Phone',
                                prefixIcon: Icon(
                                  MdiIcons.phone,
                                  color: Color(0xff4564e5),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  color: Color(0xff4564e5),
                                )))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: _buttonPressed
                          ? null
                          : _signInWithPhone, //since this is only a UI app
                      child: _buttonPressed
                          ? new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'SIGNING IN...',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Standard',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff4564e5),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                ),
                                CircularProgressIndicator(),
                              ],
                            )
                          : new Row(
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
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  _signInWithPhone() async {
    phoneNumber = '+' + _selected.dialingCode + phoneController.text;
    if (phoneNumber.length != 13) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Phone Sign In',
                    message:
                        ' Your Phone Sign In has failed! Please ensure you have entered correct Phone Number!',
                  ))));
    } else {
      setState(() {
        _buttonPressed = true;
      });
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          User userModel;
          final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
            print("Phone Code Auto Retrieval Timeout");
            verificationID = verId;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new Scaffold(
                        backgroundColor: Color(0x30000000),
                        body: CustomAlertDialog(
                          title: 'Rely - Phone Sign In',
                          message:
                              ' Your Phone Sign In has failed! Please ensure you have entered correct Phone Number!',
                        ))));
            setState(() {
              _buttonPressed = false;
            });
          };

          final PhoneCodeSent smsCodeSent =
              (String verId, [int forceCodeResend]) {
            print("Code Sent");
            verificationID = verId;
          };

          final PhoneVerificationCompleted verifiedSuccess =
              (AuthCredential phoneAuthCredential) async {
            FirebaseUser user =
                await _auth.signInWithPhoneCredential(phoneAuthCredential);

            userModel.uid = user.uid;
            Fluttertoast.showToast(
                msg: "You have successfully signed in!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 2,
                backgroundColor: Color(0xfff3f5ff),
                textColor: Color(0xff4564e5),
                fontSize: 16.0);
            setState(() {
              _buttonPressed = false;
            });
          };

          final PhoneVerificationFailed veriFailed = (AuthException exception) {
            print("Failed");
            print('${exception.message}');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new Scaffold(
                        backgroundColor: Color(0x30000000),
                        body: CustomAlertDialog(
                          title: 'Rely - Phone Sign In',
                          message: ' Your Phone Sign In has failed! Try again!',
                        ))));
            setState(() {
              _buttonPressed = false;
            });
          };
          await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              codeAutoRetrievalTimeout: autoRetrieve,
              codeSent: smsCodeSent,
              timeout: const Duration(seconds: 40),
              verificationCompleted: verifiedSuccess,
              verificationFailed: veriFailed);
        }
      } on SocketException catch (_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'Rely - Phone Sign In',
                      message:
                          ' Your Phone Sign In has failed! Please ensure Stable Internet Connection!',
                    ))));
        setState(() {
          _buttonPressed = true;
        });
      }
    }
  }
}
