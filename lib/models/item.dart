import 'package:firebase_database/firebase_database.dart';

class Item {
  String productName, description, id, image, packagingType, tagBasic,validity;
  List<String> tag;
  double price;
  int stock;
  Item(
      {this.productName,
      this.description,
      this.id,
      this.packagingType,
      this.tagBasic,
      this.price,
      this.stock,
      this.image,
      this.validity}) {
    tag = tagBasic.split(';');
  }

  Item.fromSnapshot(DataSnapshot snapshot);
}


