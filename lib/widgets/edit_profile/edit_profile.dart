import 'dart:io';

import 'package:Rely/models/enum.dart';
import 'package:Rely/services/email_validator.dart';
import 'package:Rely/services/name_validator.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/alert/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../circular_image_view.dart';

class EditProfile extends StatefulWidget {
  final String uid, imageURL;

  EditProfile({this.uid, this.imageURL});
  @override
  State<StatefulWidget> createState() {
    return EditProfileState(uid: uid, imageURLBefore: imageURL);
  }
}

class EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FirebaseDatabase database;

  final String uid, imageURLBefore;

  String name, email, emailBefore;
  File imageURLAfter;

  EditProfileState({this.uid, this.imageURLBefore});

  bool changing = false;

  @override
  void initState() {
    super.initState();
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(1000000);
    DatabaseReference dbRef = database.reference().child('Users').child(uid);
    dbRef.keepSynced(true);
    dbRef.once().then((snapshot) {
      name = snapshot.value['Name'].toString();
      nameController.text = name;
      email = snapshot.value['Email'].toString();
      emailBefore = email;
      emailController.text = email;
    });
  }

  Future _pickImage() async {
    File imageTemp;
    File croppedImage;
    try {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: AlertDialog(
                      backgroundColor: Color(0xfff3f5ff),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      title: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logo/round.png',
                            width: 50,
                            height: 50,
                          ),
                          Flexible(
                            child: Text(
                              'Rely - Profile Picture',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Standard',
                                color: Color(0xff4564e5),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'Choose your Profile Picture Source.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  color: Color(0xff4564e5),
                                ),
                                textAlign: TextAlign.center,
                              )),
                          new Row(
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 5, right: 5),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(ImageSource.gallery);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(MdiIcons.imageFrame),
                                          Text(
                                            'GALLERY',
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )),
                              ),
                              Flexible(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 5, right: 5),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(ImageSource.camera);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(MdiIcons.camera),
                                          Text(
                                            'CAMERA',
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )),
                              )
                            ],
                          )
                        ],
                      )))));
      if (result != null) {
        imageTemp = await ImagePicker.pickImage(source: ImageSource.gallery);
        print(imageTemp);
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
      }
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
      imageURLAfter = croppedImage;
    });
  }

  _changeDetails() async {
    email = emailController.text;
    name = nameController.text;
    if (!EmailValidator.validate(email) || !NameValidator.validate(name)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomAlertDialog(
                    title: 'Rely - Basic Details',
                    message: 'Please enter valid details!',
                  ))));
    } else {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Scaffold(
                  backgroundColor: Color(0x30000000),
                  body: CustomConfirmDialog(
                    title: 'Rely - Confirm Profile Picture',
                    message: 'Are you sure you want to save these details?',
                  ))));
      if (result == ConfirmAction.YES) {
        setState(() {
          changing = true;
        });
        String imageURL;

        if (imageURLAfter == null) {
          imageURL = imageURLBefore;
          database
              .reference()
              .child('Users')
              .child(uid)
              .child('ProfilePicture')
              .set(imageURL)
              .then((onVal) {
            database
                .reference()
                .child('Users')
                .child(uid)
                .child('Name')
                .set(name)
                .then((then) {
              database
                  .reference()
                  .child('Users')
                  .child(uid)
                  .child('Email')
                  .set(email)
                  .then((onVal) {
                if (email != emailBefore) {
                  FirebaseUser user = Provider.of<FirebaseUser>(context);
                  user.updateEmail(email);
                  user.sendEmailVerification();
                  user.reload();
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new Scaffold(
                            backgroundColor: Color(0x30000000),
                            body: CustomAlertDialog(
                              title: 'Rely - Basic Details',
                              message:
                                  'Your new details have been saved successfully!',
                            ))));
                setState(() {
                  changing = false;
                });
              });
            }).catchError((onError) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new Scaffold(
                          backgroundColor: Color(0x30000000),
                          body: CustomAlertDialog(
                            title: 'Rely - Basic Details',
                            message:
                                'Oops..Rely failed to save your new details!\nTry again after some time.',
                          ))));
              setState(() {
                changing = false;
              });
            });
          }).catchError((onError) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new Scaffold(
                        backgroundColor: Color(0x30000000),
                        body: CustomAlertDialog(
                          title: 'Rely - Basic Details',
                          message:
                              'Oops..Rely failed to save your new details!\nTry again after some time.',
                        ))));
            setState(() {
              changing = false;
            });
          });
        } else {
          final StorageReference storageReference = FirebaseStorage()
              .ref()
              .child('Users')
              .child(uid)
              .child('ProfilePicture');
          StorageUploadTask uploadTask =
              storageReference.putFile(imageURLAfter);
          await uploadTask.onComplete;
          await storageReference.getDownloadURL().then((fileURL) {
            imageURL = fileURL;
            database
                .reference()
                .child('Users')
                .child(uid)
                .child('ProfilePicture')
                .set(fileURL.toString())
                .then((onVal) {
              database
                  .reference()
                  .child('Users')
                  .child(uid)
                  .child('Name')
                  .set(name)
                  .then((then) {
                database
                    .reference()
                    .child('Users')
                    .child(uid)
                    .child('Email')
                    .set(email)
                    .then((onVal) {
                  if (email != emailBefore) {
                    FirebaseUser user = Provider.of<FirebaseUser>(context);
                    user.updateEmail(email);
                    user.sendEmailVerification();
                    user.reload();
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new Scaffold(
                              backgroundColor: Color(0x30000000),
                              body: CustomAlertDialog(
                                title: 'Rely - Basic Details',
                                message:
                                    'Your new details have been saved successfully!',
                              ))));
                });
              }).catchError((onError) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new Scaffold(
                            backgroundColor: Color(0x30000000),
                            body: CustomAlertDialog(
                              title: 'Rely - Basic Details',
                              message:
                                  'Oops..Rely failed to save your new details!\nTry again after some time.',
                            ))));
                setState(() {
                  changing = false;
                });
              });
            }).catchError((onError) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new Scaffold(
                          backgroundColor: Color(0x30000000),
                          body: CustomAlertDialog(
                            title: 'Rely - Basic Details',
                            message:
                                'Oops..Rely failed to save your new details!\nTry again after some time.',
                          ))));
              setState(() {
                changing = false;
              });
            });
          });
        }
      }
    }
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
                'Rely - Profile',
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
                    'You can edit your Profile here.\nRemember, Phone number is not allowed for editing as they are unique for Signing In.\nAlso, if you update your Email, a verification mail will be sent to the new Email. Until complete verification of new Email, you will not be able to use Rely completely.',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Standard',
                      color: Color(0xff4564e5),
                    ),
                    textAlign: TextAlign.start,
                  )),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 5, right: 5),
                    child: CircularImageView(
                      h: 150,
                      w: 150,
                      imgSrc: imageURLAfter == null
                          ? (imageURLBefore == 'default'
                              ? ImageSourceENUM.Asset
                              : ImageSourceENUM.Network)
                          : ImageSourceENUM.File,
                      imageLink: imageURLAfter == null
                          ? (imageURLBefore == 'default'
                              ? 'assets/images/ProfilePicture/default.png'
                              : imageURLBefore)
                          : imageURLAfter,
                    ),
                  ),
                ],
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
                      ))),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 5, right: 5),
                child: TextFormField(
                  maxLines: 1,
                  controller: nameController,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                      color: Color(0xff4564e5), fontFamily: 'Standard'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      prefixIcon: Icon(
                        MdiIcons.accountCircle,
                        color: Color(0xff4564e5),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Standard',
                        color: Color(0xff4564e5),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: TextFormField(
                  controller: emailController,
                  style: TextStyle(
                      color: Color(0xff4564e5), fontFamily: 'Standard'),
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
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                  child: MaterialButton(
                    onPressed: changing ? null : _changeDetails,
                    child: changing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'CHANGING DETAILS...  ',
                                style: TextStyle(
                                  color: Color(0xff4564e5),
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CircularProgressIndicator()
                            ],
                          )
                        : new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'CHANGE DETAILS',
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
    );
  }
}
