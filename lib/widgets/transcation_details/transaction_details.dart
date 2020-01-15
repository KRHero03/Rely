import 'package:Rely/models/enum.dart';
import 'package:Rely/models/transaction.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../circular_image_view.dart';

class TransactionDetails extends StatefulWidget {
  final String uid;
  TransactionDetails({this.uid});
  @override
  State<StatefulWidget> createState() {
    return TransactionDetailsState(uid: uid);
  }
}

class TransactionDetailsState extends State<TransactionDetails> {
  final String uid;
  TransactionDetailsState({this.uid});
  List<Transaction> transactions;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(1000000);
    DatabaseReference transactionRef =
        database.reference().child('Transactions').child(uid);

    transactionRef.keepSynced(true);
    transactions = new List();

    transactionRef.onChildAdded.listen(_onTransactionAdded);
    transactionRef.onChildChanged.listen(onTransactionChanged);
  }

  void _onTransactionAdded(Event event) {
    setState(() {
      transactions.add(new Transaction(
        id: event.snapshot.key.toString(),
        description: event.snapshot.value['Description'].toString(),
        status: event.snapshot.value['Status'].toString(),
        timestamp: event.snapshot.value['TimeStamp'].toString(),
        type: event.snapshot.value['Type'].toString(),
        amount: event.snapshot.value['Amount'].toString(),
      ));
    });
  }

  void onTransactionChanged(Event event) {
    var oldItemVal =
        transactions.singleWhere((item) => item.id == event.snapshot.key);
    setState(() {
      transactions[transactions.indexOf(oldItemVal)] = new Transaction(
        id: event.snapshot.key.toString(),
        description: event.snapshot.value['Description'].toString(),
        status: event.snapshot.value['Status'].toString(),
        timestamp: event.snapshot.value['TimeStamp'].toString(),
        type: event.snapshot.value['Type'].toString(),
        amount: event.snapshot.value['Amount'].toString(),
      );
    });
  }

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
                'Rely - Transactions',
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
        padding: EdgeInsets.only(bottom: 1, left: 5, right: 5),
        alignment:
            transactions.length == 0 ? Alignment.center : Alignment.topCenter,
        color: Color(0xff4564e5),
        child: transactions.length == 0
            ? Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'No Transactions...',
                  style: TextStyle(
                    color: Color(0xfff3f5ff),
                    fontFamily: 'Standard',
                    fontSize: 50,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: transactions.length,
                padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            new ClipboardData(text: transactions[index].id));
                        Fluttertoast.showToast(
                            msg: "Transaction ID Copied!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: transactions.length <= 3
                                ? Color(0xfff3f5ff)
                                : Color(0xff4564e5),
                            textColor: transactions.length <= 3
                                ? Color(0xff4564e5)
                                : Color(0xfff3f5ff),
                            fontSize: 16.0);
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          elevation: 3.0,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xfff3f5ff),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'ID: ' + transactions[index].id,
                                        style: TextStyle(
                                          color: Color(0xff4564e5),
                                          fontFamily: 'Standard',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Type: ' + transactions[index].type,
                                        style: TextStyle(
                                          color: Color(0xff4564e5),
                                          fontFamily: 'Standard',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'Description: ' +
                                              transactions[index].description,
                                          style: TextStyle(
                                            color: Color(0xff4564e5),
                                            fontFamily: 'Standard',
                                            fontSize: 15,
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'Date: ' +
                                              DateTime.fromMillisecondsSinceEpoch(
                                                      int.parse(
                                                          transactions[index]
                                                              .timestamp))
                                                  .toLocal()
                                                  .toString(),
                                          style: TextStyle(
                                            color: Color(0xff4564e5),
                                            fontFamily: 'Standard',
                                            fontSize: 15,
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'Amount: ₹ ' +
                                              transactions[index].amount,
                                          style: TextStyle(
                                            color: Color(0xff4564e5),
                                            fontFamily: 'Standard',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'Status: ' +
                                              transactions[index].status,
                                          style: TextStyle(
                                            color: Color(0xff4564e5),
                                            fontFamily: 'Standard',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ))
                                  ]))));
                },
              ),
      ),
    );
  }
}
