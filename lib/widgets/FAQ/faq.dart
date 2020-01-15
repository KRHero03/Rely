import 'package:Rely/models/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../circular_image_view.dart';

class FAQ extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FAQState();
  }
}

class FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff4564e5)),
          backgroundColor: Color(0xfff3f5ff),
          elevation: 1.0,
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircularImageView(
                w: 50,
                h: 50,
                imageLink: 'assets/images/logo/round.png',
                imgSrc: ImageSourceENUM.Asset,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Rely - FAQ',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Standard',
                    color: Color(0xff4564e5),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
        body: new Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
            alignment: Alignment.topCenter,
            color: Color(0xff4564e5),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'What is Rely?',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Rely is a Government Platform made available to the citizens for their daily Dairy Solutions. It is free to use and will always remain free. Rely is used to order fresh Dairy products based on Customized Subscriptions.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      'How to use Rely?',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Rely uses your Phone Number for Authentication.\nAfter you log in to Rely, you are welcomed at the Rely Home Screen where you can see a variety' +
                          ' of Products that can be subscribed.' +
                          '\n\nYou can Subscribe to the Products and their details are visible under the Subscriptions Tab.' +
                          '\n\nYou can also modify your Profile and manage Addresses via the Accounts Tab.' +
                          '\n\nFor any Customer Related Query or Feedbacks, you can drop us a mail from the Accounts Tab.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      'How do I subscribe a Product?',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Products can be subscribed from the Home Screen.\n\nSimply tap on the Product you wish to subscribe to and you will be directed' +
                          ' to the Product Details.\n\nFrom there on, you can subscribe the product, but before that be sure to\n\nVerify your Email Address!\n\nYou can customise your Subscription from thereon.' +
                          '\n\nChoose your Payment Mode and pay the Amount.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      'How do I manage my Subscriptions?',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Subscriptions can be managed from the Subscriptions Tab.\n\nChoose your Product Subscription and Customise your Subscription easily.\n\n' +
                          'You can cancel your Subscription for any day.\n\nIf you want to cancel Subscriptions have already made Payments, don\'t worry. You will be accordingly credited balance in your Rely Wallet' +
                          'which reduces the Price for your next Subscriptions.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'My account was debited but my Subscription failed. What should I do?',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Please contact the Customer Support with your Transaction ID. Rest assured because we are a Customer First Service.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'I want to switch Devices with the same account. What should I do?',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Sorry for the inconvinience, but currently, we allow only one Account per device.\n\nYou can use your Rely account only with one device at a time.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'My order was not delivered today.',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'We are really sorry for your terrible experience with Rely.\n\nPlease contact us via Customer Support where you can clearly explain your situation.'
                      +'We will try our best to help you.\n\nRemember that we are a Customer First Service.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Rely keeps crashing for unknown reasons.',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'We are deeply sorry for the inconvience caused to you.\n\nRely is still in DEVELOPMENT stage and our Development team is trying hard to fix bugs and bring new updates.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                    
              ],
            )));
  }
}
