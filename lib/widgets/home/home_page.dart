import 'dart:async';

import 'package:Rely/models/enum.dart';
import 'package:Rely/models/item.dart';
import 'package:Rely/widgets/circular_image_view.dart';
import 'package:Rely/widgets/item_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  HomePage({this.scrollController});
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<Item> items;
  StreamSubscription<Event> _onItemAddedSub;
  StreamSubscription<Event> _onItemChangedSub;

  DatabaseReference productsRef =
      FirebaseDatabase.instance.reference().child('Products');

  @override
  void initState() {
    super.initState();

    productsRef.keepSynced(true);
    items = new List();

    _onItemAddedSub = productsRef.onChildAdded.listen(_onItemAdded);
    _onItemChangedSub = productsRef.onChildChanged.listen(_onItemChanged);
  }

  @override
  void dispose() {
    _onItemAddedSub.cancel();
    _onItemChangedSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff4564e5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(0),
                child:null),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                itemBuilder: (context, position) {
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      elevation: 3.0,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder:(context)=> ItemView(item:items[position])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xfff3f5ff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                CircularImageView(
                                  w: 100,
                                  h: 100,
                                  imageLink: items[position].image,
                                  imgSrc: ImageSourceENUM.Network,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                          child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          items[position].productName,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Standard',
                                            color: Color(0xff4564e5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                      Flexible(
                                          child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          items[position].description,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Standard',
                                            color: Color(0xff4564e5),
                                          ),
                                        ),
                                      )),
                                      Flexible(
                                          child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '₹ ' +
                                              items[position].price.toString() +
                                              ' per ' +
                                              items[position].packagingType,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Standard',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff4564e5),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )));
                },
              ),
            )
          ],
        ));
  }

  void _onItemAdded(Event event) {
    setState(() {
      items.add(new Item(
        id: event.snapshot.key.toString(),
        productName: event.snapshot.value['ProductName'].toString(),
        description: event.snapshot.value['Description'].toString(),
        price: double.parse(event.snapshot.value['Price'].toString()),
        packagingType: event.snapshot.value['PackagingType'].toString(),
        image: event.snapshot.value['Image'].toString(),
        tagBasic: event.snapshot.value['Tags'].toString(),
        stock: int.parse(event.snapshot.value['Stock'].toString()),
        validity: event.snapshot.value['Validity'].toString()
      ));
    });
  }

  void _onItemChanged(Event event) {
    var oldItemVal = items.singleWhere((item) => item.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldItemVal)] = new Item(
        id: event.snapshot.key.toString(),
        productName: event.snapshot.value['ProductName'].toString(),
        description: event.snapshot.value['Description'].toString(),
        price: double.parse(event.snapshot.value['Price'].toString()),
        packagingType: event.snapshot.value['PackagingType'].toString(),
        image: event.snapshot.value['Image'].toString(),
        tagBasic: event.snapshot.value['Tags'].toString(),
        stock: int.parse(event.snapshot.value['Stock'].toString()),
        validity: event.snapshot.value['Validity'].toString()
      );
    });
  }
}
