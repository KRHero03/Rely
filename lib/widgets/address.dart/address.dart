import 'package:Rely/models/enum.dart';
import 'package:Rely/models/location_result.dart';
import 'package:Rely/services/keys.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/location_picker/location_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../circular_image_view.dart';

class Address extends StatefulWidget {
  final String uid;

  Address({this.uid});
  @override
  State<StatefulWidget> createState() {
    return AddressState(uid: uid);
  }
}

class AddressState extends State<Address> {
  TextEditingController addressController = TextEditingController();
  FirebaseDatabase database;
  final String uid;

  AddressState({this.uid});

  LocationResult result;
  double latitude, longitude;
  String address;

  bool changing = false;
  
  _changeAddress(){
    setState(() {
      changing = true;
    });
    if(latitude==null || longitude == null || addressController.text.isEmpty || addressController.text==null){
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Change Address',
                        message:
                            'Please select your Location from the Map by pressing the Location Marker button and enter valid Address!',
                      ))));
                      setState(() {
                        changing = false;
                      });
    }else{
      address = addressController.text;
      DatabaseReference dbRef = database.reference().child('Users').child(uid).child('Address').child('Primary');
    dbRef.set({
      'Value':address,
      'Latitude':latitude.toString(),
      'Longtitude':longitude.toString()
    }).then((onValue){
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Change Address',
                        message:
                            'Your Primary Address has been successfully changed!',
                      ))));
      setState(() {
        changing = false;
      });
    }).catchError((onError){
      print(onError);
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Change Address',
                        message:
                            'Oops..Rely failed to change your Primary Address!\nPlease try again after some time.',
                      ))));
      setState(() {
        changing = false;
      });
    });

    }
  }

  @override
  void initState() {
    super.initState();
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(1000000);
    DatabaseReference dbRef = database.reference().child('Users').child(uid).child('Address').child('Primary');
    dbRef.once().then((snapshot){
        address = snapshot.value['Value'].toString();
        addressController.text = address;
        latitude =double.parse(snapshot.value['Latitude'].toString());
        longitude =double.parse(snapshot.value['Longitude'].toString());
      
    });
    
  }

  @override
  Widget build(BuildContext context) {
    
    _pickLocation() async {
      result = await LocationPicker.pickLocation(context, apiKey);
      latitude = result.latLng.latitude;
      longitude = result.latLng.longitude;
      print(latitude);
      print(longitude);
    }

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
                  'Rely - Addresses',
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
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Currently, we only allow Users to use one address, that is, their Primary Address. In the future, we may allow upto 3 Addresses.',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                      ),
                      textAlign: TextAlign.start,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 30,left: 5,right: 5),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        new Flexible(
                          child: TextFormField(
                            
                            maxLines: 3,
                            controller: addressController,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                                color: Color(0xff4564e5),
                                fontFamily: 'Standard'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address',
                                prefixIcon: Icon(
                                  MdiIcons.map,
                                  color: Color(0xff4564e5),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  color: Color(0xff4564e5),
                                )),
                          ),
                        ),
                        FlatButton(
                            onPressed: _pickLocation,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff4edbf2),
                              ),
                              child: Icon(MdiIcons.mapMarker,
                                  color: Color(0xfff3f5ff), size: 34),
                            ))
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20,left:5,right: 5),
                    child: MaterialButton(
                      onPressed:changing?null: _changeAddress,
                      child:changing? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'CHANGING ADDRESS...  ',
                                  style: TextStyle(
                                    color: Color(0xff4564e5),
                                    fontSize: 15,
                                    fontFamily: 'Standard',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CircularProgressIndicator()
                              ],
                            ):new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'CHANGE ADDRESS',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Standard',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(MdiIcons.chevronRight),
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
            )),
            bottomNavigationBar:  Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 1, bottom: 1),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Manage Addresses',
                    message:
                        'We currently allow users to have only one Address.\nIn future,we may allow upto 3 addresses.\nSorry for the inconvinience.',
                  ))));
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(MdiIcons.plusCircle),
                    Text(
                      ' ADD ADDRESS',
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
          ]),);
  }
}
