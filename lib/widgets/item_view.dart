import 'package:Rely/models/enum.dart';
import 'package:Rely/models/item.dart';
import 'package:Rely/widgets/alert/alert_dialog.dart';
import 'package:Rely/widgets/circular_image_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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

  bool isPrimary = false;
  String dateType = 'Discrete';

  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    FirebaseUser userInstance = Provider.of<FirebaseUser>(context);
    _addToCart() {
      if (!userInstance.isEmailVerified) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Scaffold(
                    backgroundColor: Color(0x30000000),
                    body: CustomAlertDialog(
                      title: 'Rely - Add to Cart',
                      message:
                          'Please verify your email before adding any Product to cart!\nCheck Accounts Tab.',
                    ))));
      } else {
        isPrimary = false;
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
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
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
                                'ADD TO ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Standard',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(MdiIcons.cart),
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
      return Container(
          color: Color(0xfff3f5ff),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Padding(
                  padding:
                      EdgeInsets.only(top: 25, bottom: 5, left: 5, right: 5),
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
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
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
                          value.toString() + ' ' + item.packagingType,
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
                      });
                    },
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
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
                    items: <String>['Discrete', 'Month', 'Year']
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
                        dateType = val;
                      });
                    },
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 5, right: 5),
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
                      Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(MdiIcons.frequentlyAskedQuestions,
                              color: Color(0xff4564e5), size: 30))
                    ],
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
                  child: dateType == 'Discrete'
                      ? null
                      : CupertinoDatePicker(
                          onDateTimeChanged: (DateTime value) {
                            print(value);
                          },
                        ))
            ],
          ));
    }

    return Scaffold(
      body: isPrimary ? buildBodyPrimary() : buildBodySecondary(),
    );
  }
}
