import 'package:Rely/models/enum.dart';
import 'package:Rely/models/item.dart';
import 'package:Rely/services/keys.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/alert/confirm_dialog.dart';
import 'package:Rely/widgets/circular_image_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:true_time/true_time.dart';
import 'package:upi_india/upi_india.dart';
import 'package:calendarro/calendarro.dart';

class ItemView extends StatefulWidget {
  final Item item;
  ItemView({this.item});
  @override
  State<StatefulWidget> createState() {
    return ItemViewState(item: item);
  }
}

class ItemViewState extends State<ItemView> {
  final Item item;
  ItemViewState({this.item});

  final notesController = TextEditingController();

  FirebaseUser userInstance;
  bool isTransaction = false;

  DateTime curDate = DateTime.now();
  String dateType = 'Discrete';
  String startingDateTimeStamp = 'NA';
  String includedDateTimeStampString = 'NA';
  List<String> includedDateTimeStamp = new List<String>();
  int selectedQuantity = 1;
  String isOnTheGo = 'No';
  String paymentMode = 'Cash';
  String transactionID = 'NA';
  String approvalID = 'NA';
  String referenceID = 'NA';
  String selectedTime = 'Morning';
  double total = 0.0;
  String startingDate;
  String note;

  Future _transaction;

  _displayInfo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new Scaffold(
                backgroundColor: Color(0x30000000),
                body: CustomAlertDialog(
                  title: 'Rely - Subscription FAQ',
                  message: 'What are you doing?',
                ))));
  }

  Future<String> initiateTransaction(
      String app, String refID, String note) async {
    UpiIndia upi = new UpiIndia(
      app: app,
      receiverUpiId: receiverUPIID,
      receiverName: receiverName,
      transactionRefId: refID,
      transactionNote: note,
      amount: total,
    );

    String response = await upi.startTransaction();
    return response;
  }

  _processSubscription(String app) {
    _transaction = initiateTransaction(
            app,
            item.productName +
                total.toString() +
                curDate.millisecondsSinceEpoch.toString(),
            item.productName +
                total.toString() +
                curDate.millisecondsSinceEpoch.toString())
        .catchError((onError) {});
    _transaction.then((onValue) {
      switch (onValue) {
        case UpiIndiaResponseError.APP_NOT_INSTALLED:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Subscription Payment',
                        message:
                            'The application for Payment has not been installed on this device!',
                      ))));
          break;
        case UpiIndiaResponseError.INVALID_PARAMETERS:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Subscription Payment',
                        message:
                            'The payment failed due to Internal Service Error! Please try again after some time.',
                      ))));
          break;
        case UpiIndiaResponseError.USER_CANCELLED:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Subscription Payment',
                        message:
                            'Subscription Payment has failed due to cancellation by User!',
                      ))));
          break;
        case UpiIndiaResponseError.NULL_RESPONSE:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Subscription Payment',
                        message:
                            'The payment failed due to Internal Service Error! Please try again after some time.',
                      ))));
          break;
        default:
          print(onValue);
          UpiIndiaResponse _upiResponse = UpiIndiaResponse(onValue);
          if (_upiResponse.status == UpiIndiaResponseStatus.FAILURE) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new Scaffold(
                        backgroundColor: Color(0x30000000),
                        body: CustomAlertDialog(
                          title: 'Rely - Subscription Payment',
                          message:
                              'Oops! Rely couldn\'t process your Payment.\nIf the amount has been deducted from your Wallet/Bank, please contact Rely Customer Support from Account Tab!',
                        ))));
          } else {
            transactionID = _upiResponse.transactionId;
            approvalID = _upiResponse.approvalRefNo;
            referenceID = _upiResponse.transactionRefId;
            FirebaseDatabase.instance
                .reference()
                .child('Subscriptions')
                .child(userInstance.uid)
                .child(item.id)
                .set({
              'ExcludedDateTimeStamp': 'NA',
              'IncludedDateTimeStamp':
                  dateType == 'Discrete' ? includedDateTimeStampString : 'NA',
              'StartingDateTimeStamp':
                  dateType != 'Discrete' ? startingDateTimeStamp : 'NA',
              'PaymentMode': paymentMode,
              'OnTheGo': {
                'isOnTheGo': isOnTheGo,
                'TrainName': 'NA',
              },
              'QuantityPerDay': selectedQuantity,
              'QRCodeVerifiedTimeStamp': 'NA',
              'SubscriptionType': dateType,
              'Total': total.toString(),
              'TransactionID': transactionID,
              'ApprovalID': approvalID,
              'ReferenceID': referenceID,
              'Note': note
            }).whenComplete(() {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new Scaffold(
                          backgroundColor: Color(0x30000000),
                          body: CustomAlertDialog(
                            title: 'Rely - Subscription Complete',
                            message:
                                'There you go! Your Subscription for the Product has been done!\n Check Subscriptions Tab!',
                          ))));
              setState(() {
                isTransaction = false;
              });
            }).catchError((error) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new Scaffold(
                          backgroundColor: Color(0x30000000),
                          body: CustomAlertDialog(
                            title: 'Rely - Subscription Incomplete',
                            message:
                                'Oops! Rely failed to confirm your Subscription!\nMake sure your Internet is working!\nIf your Bank Account/Wallet is debited, please contact Rely Customer Support from Accounts Tab!',
                          ))));
              setState(() {
                isTransaction = false;
              });
            });
          }
      }
    });
  }

  _subscribe() async {
    if (((startingDateTimeStamp == null || startingDateTimeStamp == 'NA') &&
            dateType != 'Discrete') ||
        (includedDateTimeStamp.isEmpty && dateType == 'Discrete')) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Subscription',
                    message: 'Please select date(s) for Product Subscription!',
                  ))));
    } else {
      final reply = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomConfirmDialog(
                    title: 'Rely - Confirm Subscription',
                    message:
                        'Are you sure that you want to subscribe to the product with given Subscription details?',
                  ))));
      if (reply == ConfirmAction.YES) {
        note = notesController.text;
        includedDateTimeStampString = includedDateTimeStamp.join(';');
        setState(() {
          isTransaction = true;
        });
        switch (paymentMode) {
          case 'Cash':
            FirebaseDatabase.instance
                .reference()
                .child('Subscriptions')
                .child(userInstance.uid)
                .child(item.id)
                .set({
                  'ExcludedDateTimeStamp': 'NA',
                  'IncludedDateTimeStamp': dateType == 'Discrete'
                      ? includedDateTimeStampString
                      : 'NA',
                  'StartingDateTimeStamp':
                      dateType != 'Discrete' ? startingDateTimeStamp : 'NA',
                  'PaymentMode': paymentMode,
                  'OnTheGo': {
                    'isOnTheGo': isOnTheGo,
                    'TrainName': 'NA',
                  },
                  'QuantityPerDay': selectedQuantity,
                  'QRCodeVerifiedTimeStamp': 'NA',
                  'SubscriptionType': dateType,
                  'Total': total.toString(),
                  'TransactionID': 'NA',
                  'ApprovalID': 'NA',
                  'ReferenceID': 'NA',
                  'Note': note
                })
                .whenComplete(() {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new Scaffold(
                              backgroundColor: Color(0x30000000),
                              body: CustomAlertDialog(
                                title: 'Rely - Subscription Complete',
                                message:
                                    'There you go! Your Subscription for the Product has been done!\n Check Subscriptions Tab!',
                              ))));
                  setState(() {
                    isTransaction = false;
                  });
                })
                .catchError((error) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new Scaffold(
                              backgroundColor: Color(0x30000000),
                              body: CustomAlertDialog(
                                title: 'Rely - Subscription Incomplete',
                                message:
                                    'Oops! Rely failed to confirm your Subscription!\nMake sure your Internet is working!\nIf your Bank Account/Wallet is debited, please contact Rely Customer Support from Accounts Tab!',
                              ))));
                  setState(() {
                    isTransaction = false;
                  });
                })
                .timeout(Duration(seconds: 40))
                .catchError((error) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new Scaffold(
                              backgroundColor: Color(0x30000000),
                              body: CustomAlertDialog(
                                title: 'Rely - Subscription Incomplete',
                                message:
                                    'Oops! Rely failed to confirm your Subscription!\nMake sure your Internet is working!\nIf your Bank Account/Wallet is debited, please contact Rely Customer Support from Accounts Tab!',
                              ))));
                  setState(() {
                    isTransaction = false;
                  });
                });
            break;
          case 'PhonePe':
            _processSubscription(UpiIndiaApps.PhonePe);
            break;

          case 'Google Pay':
            _processSubscription(UpiIndiaApps.GooglePay);
            break;

          case 'BHIM':
            _processSubscription(UpiIndiaApps.BHIMUPI);
            break;
        }
      }
    }
  }

  Widget buildBodyPrimary() {
    return Stack(
      children: <Widget>[
        Container(
            color: Color(0xff4564e5),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      item.productName,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Standard',
                        color: Color(0xfff3f5ff),
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularImageView(
                      w: 200,
                      h: 200,
                      imageLink: item.image,
                      imgSrc: ImageSourceENUM.Network,
                    )),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        '₹ ' +
                            item.price.toString() +
                            ' per ' +
                            item.packagingType,
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Standard',
                          color: Color(0xfff3f5ff),
                        ),
                        textAlign: TextAlign.center)),
              ],
            )),
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 450),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Color(0xfff3f5ff),
            ),
            child: Padding(
                padding: EdgeInsets.all(5),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            color: Color(0xff4564e5),
                            fontFamily: 'Standard',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        item.description,
                        style: TextStyle(
                          color: Color(0xff4564e5),
                          fontFamily: 'Standard',
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, bottom: 5, top: 10),
                      child: Text(
                        'Validity',
                        style: TextStyle(
                            color: Color(0xff4564e5),
                            fontFamily: 'Standard',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        item.validity + ' days before it spoils...',
                        style: TextStyle(
                          color: Color(0xff4564e5),
                          fontFamily: 'Standard',
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, bottom: 5, top: 10),
                      child: Text(
                        'Product Tags',
                        style: TextStyle(
                            color: Color(0xff4564e5),
                            fontFamily: 'Standard',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: item.tag.length,
                          itemBuilder: (context, position) {
                            return Text(
                              item.tag[position],
                              style: TextStyle(
                                color: Color(0xff4564e5),
                                fontFamily: 'Standard',
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, bottom: 5, top: 10),
                      child: MaterialButton(
                        onPressed: _addToCart,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SUBSCRIBE TO PRODUCT',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Standard',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                  ],
                )))
      ],
    );
  }

  Widget buildBodySecondary() {
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
                  'Rely - Subscription',
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
      body:Container(
        color: Color(0xfff3f5ff),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 25, bottom: 5, left: 5, right: 5),
                child: Text(
                  'Customize your Order Subscription',
                  style: TextStyle(
                      color: Color(0xff4564e5),
                      fontFamily: 'Standard',
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Please fill in the required details regarding the subscription.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: Text(
                  'Select Quantity per Day',
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'This is the amount of Product delivered to you on a daily basis.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: new DropdownButton<String>(
                  icon: Icon(MdiIcons.chevronDown,
                      color: Color(0xff4564e5), size: 34),
                  isExpanded: true,
                  value: selectedQuantity.toString(),
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 20,
                  ),
                  items: <int>[1, 2, 3, 4, 5].map((int value) {
                    return new DropdownMenuItem<String>(
                      value: value.toString(),
                      child: new Text(
                        value.toString() +
                            ' ' +
                            item.packagingType +
                            ((value <= 1) ? '' : '(s)'),
                        style: TextStyle(
                          color: Color(0xff4564e5),
                          fontFamily: 'Standard',
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedQuantity = int.parse(val);
                      total = item.price *
                          selectedQuantity *
                          (dateType == 'Discrete'
                              ? 0.0
                              : (dateType == 'Month' ? 30 : 365));
                    });
                  },
                )),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: Text(
                  'Order Subscription Type',
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Select your Order Subscription Type based on whether you want the Subscription for certain specific days, a whole month(29 Days after starting date) or a whole year(364 Days after Starting Date)',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: new DropdownButton<String>(
                  icon: Icon(MdiIcons.chevronDown,
                      color: Color(0xff4564e5), size: 34),
                  isExpanded: true,
                  value: dateType.toString(),
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 20,
                  ),
                  items:
                      <String>['Discrete', 'Month', 'Year'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value.toString(),
                      child: new Text(
                        value.toString(),
                        style: TextStyle(
                          color: Color(0xff4564e5),
                          fontFamily: 'Standard',
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      includedDateTimeStamp.clear();
                      dateType = val;
                      total = item.price *
                          selectedQuantity *
                          (dateType == 'Discrete'
                              ? 0.0
                              : (dateType == 'Month' ? 30 : 365));
                    });
                  },
                )),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (dateType == 'Discrete'
                        ? Text(
                            'Select Dates for Subscription',
                            style: TextStyle(
                              color: Color(0xff4564e5),
                              fontFamily: 'Standard',
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Select Starting Date of ' + dateType,
                            style: TextStyle(
                              color: Color(0xff4564e5),
                              fontFamily: 'Standard',
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                          )),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
              child: dateType == 'Discrete'
                  ? Calendarro(
                      displayMode: DisplayMode.MONTHS,
                      selectionMode: SelectionMode.MULTI,
                      startDate: curDate.add(Duration(days: 1)),
                      endDate: curDate.add(Duration(days: 30)),
                      onTap: (dateTime) {
                        String dateTimeStamp =
                            dateTime.millisecondsSinceEpoch.toString();
                        if (includedDateTimeStamp.isEmpty) {
                          setState(() {
                            includedDateTimeStamp.add(dateTimeStamp);
                          });
                        } else {
                          if (includedDateTimeStamp.contains(dateTimeStamp)) {
                            setState(() {
                              includedDateTimeStamp.remove(dateTimeStamp);
                            });
                          } else {
                            setState(() {
                              includedDateTimeStamp.add(dateTimeStamp);
                            });
                          }
                        }
                        setState(() {
                          total = item.price *
                              selectedQuantity *
                              includedDateTimeStamp.length;
                        });
                      })
                  : GestureDetector(
                      onTap: () async {
                        DateTime result = await showDatePicker(
                          context: context,
                          firstDate: curDate.add(Duration(days: 1)),
                          initialDate: curDate.add(Duration(days: 1)),
                          lastDate: curDate.add(Duration(days: 90)),
                        );
                        setState(() {
                          startingDate = result == null
                              ? null
                              : result.day.toString() +
                                  " - " +
                                  result.month.toString() +
                                  " - " +
                                  result.year.toString();
                          startingDateTimeStamp = result == null
                              ? null
                              : result.millisecondsSinceEpoch.toString();
                        });
                      },
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Color(0xff4564e5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            startingDate == null ? 'Pick a Date' : startingDate,
                            style: TextStyle(
                                color: Color(0xfff3f5ff),
                                fontFamily: 'Standard',
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: Text(
                  'Preferred Delivery Time',
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Select the time during day at which you want your delivery.\nMorning:- 6 AM to 8 AM \nEvening:- 6 PM to 8 PM',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: new DropdownButton<String>(
                  icon: Icon(MdiIcons.chevronDown,
                      color: Color(0xff4564e5), size: 34),
                  isExpanded: true,
                  value: selectedTime,
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 20,
                  ),
                  items: <String>['Morning', 'Evening'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value.toString(),
                      child: new Text(
                        value.toString(),
                        style: TextStyle(
                          color: Color(0xff4564e5),
                          fontFamily: 'Standard',
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedTime = val;
                    });
                  },
                )),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: Text(
                  'Is this Subscription On The Go?',
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Please select \'Yes\' if you want the Subscription to be picked up by you daily during your morning Train Travel (Especially for Up-Down Shift Employees).',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: new DropdownButton<String>(
                  icon: Icon(MdiIcons.chevronDown,
                      color: Color(0xff4564e5), size: 34),
                  isExpanded: true,
                  value: isOnTheGo,
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 20,
                  ),
                  items: <String>['No', 'Yes'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value.toString(),
                      child: new Text(
                        value.toString(),
                        style: TextStyle(
                          color: Color(0xff4564e5),
                          fontFamily: 'Standard',
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      isOnTheGo = val;
                    });
                  },
                )),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: isOnTheGo == 'False'
                    ? null
                    : ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          /*TODO ADD INPUT WIDGETS FOR USER SO THAT HE CAN INSERT PNR NO., 
                        TRAIN NAME, PREFERRED ORDER PICK UP STATION. THE INFO MUST BE VALIDATED
                        AND ONLY THOSE STATIONS MUST BE DISPLAYED IN PREFERRED ORDER PICK UP STATION
                        THAT ARE REACHED BY TRAIN, AND ALSO AFTER THE STATION WHERE USER TAKES THE TRAIN AND BEFORE 
                        THE STATION WHERE USER LEAVES THE TRAIN.
                        */
                        ],
                      )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Any notes for us or thoughts regarding the Subscription?',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: TextFormField(
                  maxLines: 3,
                  controller: notesController,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                      color: Color(0xff4564e5), fontFamily: 'Standard'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Special Note',
                      prefixIcon: Icon(
                        MdiIcons.notebook,
                        color: Color(0xff4564e5),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                      )),
                )),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: Text(
                  'Total:- ₹' + total.toString(),
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'The above amount is calculated on the basis of your selected Options. The amount maybe reduced due to deductions from your Rely Wallet.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
                child: Text(
                  'Payment Mode',
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Select your Preferrable Payment Mode\n. For Prepaid Subscription , please refer Help by tapping the Question Mark before Payment.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Standard',
                  color: Color(0xff4564e5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: new DropdownButton<String>(
                  icon: Icon(MdiIcons.chevronDown,
                      color: Color(0xff4564e5), size: 34),
                  isExpanded: true,
                  value: paymentMode,
                  style: TextStyle(
                    color: Color(0xff4564e5),
                    fontFamily: 'Standard',
                    fontSize: 20,
                  ),
                  items: <String>['Cash', 'Google Pay', 'PhonePe', 'BHIM']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value.toString(),
                      child: new Text(
                        value.toString(),
                        style: TextStyle(
                          color: Color(0xff4564e5),
                          fontFamily: 'Standard',
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      paymentMode = val;
                    });
                  },
                )),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                child: isTransaction
                    ? MaterialButton(
                        onPressed: null,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SUBSCRIBING PRODUCT...',
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
                        ),
                        color: Color(0xff4edbf2),
                        elevation: 0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )
                    : (paymentMode == 'Cash'
                        ? MaterialButton(
                            onPressed: _subscribe,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'SUBSCRIBE TO PRODUCT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Standard',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                            onPressed: _subscribe,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage(paymentMode == 'Google Pay'
                                      ? 'assets/images/Payment/GooglePay.png'
                                      : (paymentMode == 'PhonePe'
                                          ? 'assets/images/Payment/PhonePe.png'
                                          : 'assets/images/Payment/BHIM.png')),
                                  width: 40,
                                  height: 40,
                                ),
                                Text(
                                  paymentMode.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Standard',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            color: Color(0xff4edbf2),
                            elevation: 0,
                            minWidth: 400,
                            height: 50,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          )))
          ],
        )));
  }

  _addToCart() {
    if (!userInstance.isEmailVerified) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Product Subscription',
                    message:
                        'Please verify your email before adding any Product to cart!\nCheck Accounts Tab.',
                  ))));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => buildBodySecondary()));
    }
  }

  @override
  initState() {
    super.initState();
    _initPlatformState();
  }

  _initPlatformState() async {
    TrueTime.init(ntpServer: 'pool.ntp.org').whenComplete(() {
      TrueTime.now().then((val) {
        setState(() {
          curDate = val;

          startingDateTimeStamp =
              curDate.add(Duration(days: 1)).millisecondsSinceEpoch.toString();

          if (includedDateTimeStamp.isNotEmpty) {
            includedDateTimeStamp.forEach((f) {
              if (curDate.millisecondsSinceEpoch > int.tryParse(f))
                includedDateTimeStamp.remove(f);
            });
          }
        });
      });
    }).catchError((onError) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Subscription',
                    message:
                        'Oops..Rely failed to load Subscription Customisation!\nPlease make sure you are connected to internet!',
                  ))));
    });
  }

  @override
  Widget build(BuildContext context) {
    userInstance = Provider.of<FirebaseUser>(context);

    return Scaffold(
      body: buildBodyPrimary() ,
      floatingActionButton: FloatingActionButton(
        onPressed: _displayInfo,
        child: Icon(MdiIcons.helpCircleOutline, size: 40, color: Colors.white),
      ),
    );
  }
}
