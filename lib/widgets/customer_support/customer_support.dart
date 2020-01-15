import 'package:Rely/models/complaint.dart';
import 'package:Rely/models/enum.dart';
import 'package:Rely/services/keys.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/alert/complaint_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../circular_image_view.dart';

class CustomerSupport extends StatefulWidget {
  final String uid;
  CustomerSupport({this.uid});
  @override
  State<StatefulWidget> createState() {
    return CustomerSupportState(uid: uid);
  }
}

class CustomerSupportState extends State<CustomerSupport> {
  final String uid;
  CustomerSupportState({this.uid});
  List<Complaint> complaints;

  @override
  void initState() {
    super.initState();
    FirebaseDatabase database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(1000000);
    DatabaseReference complaintRef =
        database.reference().child('Complaints').child(uid);

    complaintRef.keepSynced(true);
    complaints = new List();

    complaintRef.onChildAdded.listen(_onComplaintAdded);
    complaintRef.onChildChanged.listen(_onComplaintChanged);
  }

  void _onComplaintAdded(Event event) {
    setState(() {
      complaints.add(new Complaint(
        complaintID: event.snapshot.key.toString(),
        complaintDesc: event.snapshot.value['ComplaintDescription'].toString(),
        complaintStatus: event.snapshot.value['ComplaintStatus'].toString(),
        complaintTime: event.snapshot.value['ComplaintTimeStamp'].toString(),
        complaintType: event.snapshot.value['ComplaintType'].toString(),
      ));
    });
  }

  void _onComplaintChanged(Event event) {
    var oldItemVal = complaints
        .singleWhere((item) => item.complaintID == event.snapshot.key);
    setState(() {
      complaints[complaints.indexOf(oldItemVal)] = new Complaint(
        complaintID: event.snapshot.key.toString(),
        complaintDesc: event.snapshot.value['ComplaintDescription'].toString(),
        complaintStatus: event.snapshot.value['ComplaintStatus'].toString(),
        complaintTime: event.snapshot.value['ComplaintTimeStamp'].toString(),
        complaintType: event.snapshot.value['ComplaintType'].toString(),
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
                'Rely - Customer Support',
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
            complaints.length == 0 ? Alignment.center : Alignment.topCenter,
        color: Color(0xff4564e5),
        child: complaints.length == 0
            ? Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'No Complaints...\nPhew.',
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
                itemCount: complaints.length,
                padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
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
                                    'ID: ' + complaints[index].complaintID,
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
                                    'Type: ' + complaints[index].complaintType,
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
                                      'Date: ' +
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  int.parse(complaints[index]
                                                      .complaintTime))
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
                                      'Description: ' +
                                          complaints[index].complaintDesc,
                                      style: TextStyle(
                                        color: Color(0xff4564e5),
                                        fontFamily: 'Standard',
                                        fontSize: 15,
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Status: ' +
                                          complaints[index].complaintStatus,
                                      style: TextStyle(
                                        color: Color(0xff4564e5),
                                        fontFamily: 'Standard',
                                        fontSize: 15,
                                      ),
                                    ))
                              ])));
                },
              ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 1, bottom: 1),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ComplaintDialog()));
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'REGISTER COMPLAINT',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                color: Color(0xfff3f5ff),
                textColor: Color(0xff4564e5),
                elevation: 1,
                minWidth: 400,
                height: 50,
              )),
          Padding(
              padding: EdgeInsets.only(top: 1, bottom: 1),
              child: MaterialButton(
                onPressed: () async {
                  if (await canLaunch('tel:' + adminPhone)) {
                    await launch('tel:' + adminPhone);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Scaffold(
                                backgroundColor: Color(0x30000000),
                                body: CustomAlertDialog(
                                  title: 'Rely - Customer Support',
                                  message:
                                      'Oops. Rely encountered a problem!\nTry again after some time.',
                                ))));
                  }
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'CALL US ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(MdiIcons.phone),
                  ],
                ),
                color: Color(0xfff3f5ff),
                textColor: Color(0xff4564e5),
                elevation: 1,
                minWidth: 400,
                height: 50,
              )),
        ],
      ),
    );
  }
}
