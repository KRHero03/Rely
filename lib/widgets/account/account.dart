import 'package:Rely/models/enum.dart';
import 'package:Rely/services/keys.dart';
import 'package:Rely/widgets/FAQ/faq.dart';
import 'package:Rely/widgets/address.dart/address.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/circular_image_view.dart';
import 'package:Rely/widgets/customer_support/customer_support.dart';
import 'package:Rely/widgets/edit_profile/edit_profile.dart';
import 'package:Rely/widgets/transcation_details/transaction_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:true_time/true_time.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  final ScrollController scrollController;
  Account({this.scrollController});
  @override
  State<StatefulWidget> createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  bool load = false;
  bool isVerified = false;
  int sendingVerification = 0;
  FirebaseUser user;
  DateTime curDate;

  String imageURL = 'default';
  String name = 'Your Name...',
      email = 'Your Email...',
      phone = 'Your Phone...';
  double walletAmount = 0.0;

  FirebaseDatabase database = FirebaseDatabase.instance;

  _sendFeedback() async {
    var url = 'mailto:' +
        adminEmail +
        '?subject=Rely Feedback&body=Please write your message here.';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Send Feedback',
                    message:
                        'Oops. Rely encountered a problem!\nTry again after some time.',
                  ))));
    }
  }

  @override
  initState() {
    super.initState();
    _initPlatformState();
  }

  _initPlatformState() async {
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    TrueTime.init(ntpServer: 'pool.ntp.org').whenComplete(() {
      TrueTime.now().then((val) {
        setState(() {
          curDate = val;
        });
      });
    });

    FirebaseAuth.instance.currentUser().then((onValue) {
      user = onValue;
      setState(() {
        isVerified = user.isEmailVerified;
        email = user.email;
        phone = user.phoneNumber;
        DatabaseReference dbRef = database.reference();
        dbRef.keepSynced(true);
        dbRef
            .child('Users')
            .child(user.uid)
            .once()
            .then((DataSnapshot snapshot) {
          setState(() {
            imageURL = snapshot.value['ProfilePicture'].toString();
            name = snapshot.value['Name'].toString();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _customerSupport() {
      user.reload();
      if (user.isEmailVerified)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerSupport(uid: user.uid)));
      else
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'Rely - Customer Support',
                      message:
                          'Please verify your Email before using Customer Support!',
                    ))));
    }

    _sendVerification() {
      setState(() {
        sendingVerification = 1;
      });
      user.sendEmailVerification().then((val) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'Rely - Email Verification',
                      message:
                          'Rely has sent you an Email for Verification!\nPlease check your email!',
                    ))));
        setState(() {
          sendingVerification = 2;
        });
      }).catchError((onError) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'Rely - Email Verification',
                      message:
                          'Rely failed to send Email Verification!\nTry again after some time.',
                    ))));
        setState(() {
          sendingVerification = 0;
        });
      });
    }

    _goToAddress() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Address(uid: user.uid)));
    }

    _goToFAQ() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FAQ()));
    }

    _goToTransactionDetails() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransactionDetails(uid: user.uid)));
    }

    _goToEditProfile() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditProfile(uid: user.uid, imageURL: imageURL)));
    }

    return ListView(shrinkWrap: true, children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Color(0xff4564e5),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: CircularImageView(
                h: 150,
                w: 150,
                imgSrc: imageURL == 'default'
                    ? ImageSourceENUM.Asset
                    : ImageSourceENUM.Network,
                imageLink: imageURL == 'default'
                    ? 'assets/images/ProfilePicture/default.png'
                    : imageURL,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Standard',
                    color: Color(0xfff3f5ff),
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Standard',
                            color: Color(0xfff3f5ff),
                          ),
                        ),
                      ),
                      MaterialButton(
                          onPressed: sendingVerification >= 1
                              ? null
                              : (isVerified ? null : _sendVerification),
                          color: Color(0xff4edbf2),
                          child: sendingVerification == 1
                              ? CircularProgressIndicator()
                              : Row(
                                  children: <Widget>[
                                    Text(
                                      isVerified
                                          ? 'Verified'
                                          : (sendingVerification == 2
                                              ? 'Verification Sent'
                                              : 'Verify Email'),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Standard',
                                        color: Color(0xfff3f5ff),
                                      ),
                                    ),
                                    sendingVerification >= 1
                                        ? !isVerified
                                            ? Icon(
                                                MdiIcons.alertCircle,
                                                color: Color(0xfff3f5ff),
                                              )
                                            : Icon(
                                                MdiIcons.checkCircle,
                                                color: Color(0xfff3f5ff),
                                              )
                                        : isVerified
                                            ? Icon(
                                                MdiIcons.checkCircle,
                                                color: Color(0xfff3f5ff),
                                              )
                                            : Text(''),
                                  ],
                                )),
                    ])),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  phone,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Standard',
                    color: Color(0xfff3f5ff),
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  '₹ ' + walletAmount.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Standard',
                    color: Color(0xfff3f5ff),
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Padding(
        padding: EdgeInsets.all(0),
        child: MaterialButton(
          onPressed: _goToEditProfile,
          elevation: 0.5,
          height: 60,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'EDIT PROFILE',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Standard',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4564e5),
                ),
              ),
              Icon(
                MdiIcons.chevronRight,
                color: Color(0xff4564e5),
                size: 25,
              )
            ],
          ),
          color: Color(0xfff3f5ff),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(0),
        child: MaterialButton(
          onPressed: _goToAddress,
          elevation: 0.5,
          height: 60,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'MANAGE ADDRESSES',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Standard',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4564e5),
                ),
              ),
              Icon(
                MdiIcons.chevronRight,
                color: Color(0xff4564e5),
                size: 25,
              )
            ],
          ),
          color: Color(0xfff3f5ff),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(0),
        child: MaterialButton(
          onPressed: _goToTransactionDetails,
          elevation: 0.5,
          height: 60,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'TRANSACTION DETAILS',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Standard',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4564e5),
                ),
              ),
              Icon(
                MdiIcons.chevronRight,
                color: Color(0xff4564e5),
                size: 25,
              )
            ],
          ),
          color: Color(0xfff3f5ff),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
      ),
      Padding(
        padding: EdgeInsets.all(0),
        child: MaterialButton(
          onPressed: _goToFAQ,
          elevation: 0.5,
          height: 60,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Standard',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4564e5),
                ),
              ),
              Icon(
                MdiIcons.chevronRight,
                color: Color(0xff4564e5),
                size: 25,
              )
            ],
          ),
          color: Color(0xfff3f5ff),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(0),
        child: MaterialButton(
          onPressed: _customerSupport,
          elevation: 0.5,
          height: 60,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'CUSTOMER SUPPORT',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Standard',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4564e5),
                ),
              ),
              Icon(
                MdiIcons.chevronRight,
                color: Color(0xff4564e5),
                size: 25,
              )
            ],
          ),
          color: Color(0xfff3f5ff),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(0),
        child: MaterialButton(
          onPressed: _sendFeedback,
          elevation: 0.5,
          height: 60,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'SEND FEEDBACK',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Standard',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4564e5),
                ),
              ),
              Icon(
                MdiIcons.chevronRight,
                color: Color(0xff4564e5),
                size: 25,
              )
            ],
          ),
          color: Color(0xfff3f5ff),
        ),
      )
    ]);
  }
}
