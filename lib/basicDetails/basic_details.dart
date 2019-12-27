import 'dart:io';
import 'package:Rely/models/enum.dart';
import 'package:Rely/models/location_result.dart';
import 'package:Rely/services/email_validator.dart';
import 'package:Rely/services/keys.dart';
import 'package:Rely/services/name_validator.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/alert/confirm_dialog.dart';
import 'package:Rely/widgets/circular_image_view.dart';
import 'package:Rely/widgets/location_picker/location_picker.dart';
import 'package:device_id/device_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class BasicDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BasicDetailsState();
  }
}

class BasicDetailsState extends State<BasicDetails> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  LocationResult result;

  var screenChanged = false, loading = false;

  String name, email, address, imageFileURL;
  double latitude, longitude;
  File imageFile;
  String deviceId;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  _goToLastStep() async {
    if (screenChanged == false) {
      name = nameController.text;
      email = emailController.text;
      address = addressController.text;
      if (EmailValidator.validate(email) &&
          NameValidator.validate(name) &&
          address.isNotEmpty) {
        if (latitude == null || longitude == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Basic Details',
                        message:
                            'Please select your location in Map by pressing the Location Icon!',
                      ))));
        } else {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomConfirmDialog(
                        title: 'Rely - Confirm Information',
                        message: 'Are you sure that your details are correct?',
                      ))));
          print(result);
          if (result == ConfirmAction.YES) {
            setState(() {
              screenChanged = true;
            });
          }
        }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'Rely - Basic Details',
                      message: 'Please enter valid details!',
                    ))));
      }
    } else {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomConfirmDialog(
                    title: 'Rely - Confirm Profile Picture',
                    message: imageFile == null
                        ? 'Nevermind with the Profile Picture. Shall we proceed to the Home Screen?'
                        : 'Nice Profile Picture there... Shall we proceed to the Home Screen then?',
                  ))));
      if (result == ConfirmAction.YES) {
        setState(() {
          loading = true;
        });
        deviceId = await DeviceId.getID;
        FirebaseUser userInstance = Provider.of<FirebaseUser>(context);
        try {
          if (imageFile != null) {
            final StorageReference storageReference = FirebaseStorage()
                .ref()
                .child('Users')
                .child(userInstance.uid)
                .child('ProfilePicture');
            StorageUploadTask uploadTask = storageReference.putFile(imageFile);
            await uploadTask.onComplete;
            await storageReference.getDownloadURL().then((fileURL) {
              imageFileURL = fileURL;
            });
          } else {
            imageFileURL = 'default';
          }
          print('ImageFileURL Line 126:- ' + imageFileURL);

          userInstance.updateEmail(email).then((value) {
            userInstance.sendEmailVerification();
          }).whenComplete(() {
            FirebaseDatabase.instance
                .reference()
                .child('Users')
                .child(userInstance.uid)
                .set({
              'Name': name,
              'Email': email,
              'Phone': userInstance.phoneNumber,
              'Address': {
                'Primary': {
                  'Value': address,
                  'Latitude': latitude,
                  'Longitude': longitude
                }
              },
              'DeviceID': deviceId,
              'ProfilePicture': imageFileURL,
            }).whenComplete(() {
              setState(() {
                loading = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new Scaffold(
                          backgroundColor: Color(0x30000000),
                          body: CustomAlertDialog(
                            title: 'Rely - Home',
                            message:
                                'Welcome to Rely!\nWe have sent a Verification mail to your email address.\nPlease verify your email address first!',
                          ))));
            }).catchError((onError) {
              setState(() {
                loading = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new Scaffold(
                          backgroundColor: Color(0x30000000),
                          body: CustomAlertDialog(
                            title: 'Rely - Basic Details',
                            message:
                                'Failed to upload details! Please try again after some time.',
                          ))));
            });
          }).catchError((onError) {
            setState(() {
              loading = false;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new Scaffold(
                        backgroundColor: Color(0x30000000),
                        body: CustomAlertDialog(
                          title: 'Rely - Basic Details',
                          message:
                              'Failed to upload details! Please try again after some time.',
                        ))));
          });
        } catch (error) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new Scaffold(
                      backgroundColor: Color(0x30000000),
                      body: CustomAlertDialog(
                        title: 'Rely - Basic Details',
                        message:
                            'Failed to upload details! Please try again after some time.',
                      ))));
        }
      }
    }
  }

  Future _pickImage() async {
    File imageTemp;
    File croppedImage;
    try {
      imageTemp = await ImagePicker.pickImage(source: ImageSource.gallery);
      croppedImage = await ImageCropper.cropImage(
        sourcePath: imageTemp.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            statusBarColor: Color(0xff4564e5),
            toolbarTitle: 'Rely - Choose Image',
            toolbarWidgetColor: Color(0xffff3f5ff),
            activeWidgetColor: Color(0xff4edbf2),
            toolbarColor: Color(0xff4564e5),
            activeControlsWidgetColor: Color(0xff4edbf2)),
      );
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Profile Picture',
                    message: 'Failed to load Profile Picture! Try again.',
                  ))));
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      imageFile = croppedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pickLocation() async {
      result = await LocationPicker.pickLocation(context, apiKey);
      latitude = result.latLng.latitude;
      longitude = result.latLng.longitude;
    }

    return Scaffold(
        body: Stack(
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
                  child: screenChanged
                      ? Text('Final Step...',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Standard',
                            color: Color(0xff4564e5),
                          ),
                          textAlign: TextAlign.center)
                      : Text('Just few more Steps...',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Standard',
                            color: Color(0xff4564e5),
                          ),
                          textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: screenChanged
                      ? Text('Set up your Profile Picture...',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Standard',
                            color: Color(0xff4564e5),
                          ),
                          textAlign: TextAlign.left)
                      : Text('Fill in these details while we set you up...',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Standard',
                            color: Color(0xff4564e5),
                          ),
                          textAlign: TextAlign.left),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: screenChanged
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              imageFile != null
                                  ? CircularImageView(
                                      w: 250.0,
                                      h: 250.0,
                                      imageLink: imageFile,
                                      imgSrc: ImageSourceENUM.File,
                                    )
                                  : CircularImageView(
                                      w: 250.0,
                                      h: 250.0,
                                      imageLink:
                                          'assets/images/ProfilePicture/default.png',
                                      imgSrc: ImageSourceENUM.Asset,
                                    ),
                              Padding(
                                  padding: EdgeInsets.all(10),
                                  child: FloatingActionButton(
                                      elevation: 0,
                                      onPressed: _pickImage,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff4edbf2),
                                        ),
                                        child: Icon(MdiIcons.camera,
                                            color: Color(0xfff3f5ff), size: 34),
                                      )))
                            ])
                      : Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            style: screenChanged
                                ? null
                                : TextStyle(
                                    color: Color(0xff4564e5),
                                    fontFamily: 'Standard'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                                prefixIcon: Icon(
                                  MdiIcons.account,
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
                  padding: screenChanged
                      ? EdgeInsets.all(0)
                      : EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: screenChanged
                      ? null
                      : Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(
                                color: Color(0xff4564e5),
                                fontFamily: 'Standard'),
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
                  padding: screenChanged
                      ? EdgeInsets.all(0)
                      : EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: screenChanged
                      ? null
                      : Container(
                          color: Color(0xfff5f5f5),
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
                  padding: screenChanged
                      ? EdgeInsets.all(0)
                      : EdgeInsets.only(top: 5),
                  child: screenChanged
                      ? null
                      : Text(
                          'You may modify the above Address to make it more accurate.',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Standard',
                            color: Color(0xff4564e5),
                          ),
                          textAlign: TextAlign.left),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: MaterialButton(
                      onPressed: loading ? null : _goToLastStep,
                      child: screenChanged
                          ? new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: loading
                                  ? <Widget>[
                                      Text(
                                        'TAKING YOU HOME...',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Standard',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff4564e5)),
                                      ),
                                      CircularProgressIndicator()
                                    ]
                                  : <Widget>[
                                      Text(
                                        'TAKE ME HOME',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Standard',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(MdiIcons.chevronRight),
                                    ],
                            )
                          : new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'I\'M DONE',
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
            ),
          ),
        )
      ],
    ));
  }
}
