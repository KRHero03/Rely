import 'package:Rely/models/enum.dart';
import 'package:flutter/cupertino.dart';

class CircularImageView extends StatelessWidget {
  final double h, w;
  final imageLink;
  final ImageSourceENUM imgSrc;
  CircularImageView({this.h, this.w, this.imageLink, this.imgSrc});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      width: w,
      height: h,
      
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imgSrc == ImageSourceENUM.Asset
              ? AssetImage(imageLink.toString())
              : (imgSrc == ImageSourceENUM.Network
                  ? NetworkImage(imageLink.toString())
                  : FileImage(imageLink)),
        ),
        shape: BoxShape.circle,
      ), duration: Duration(milliseconds: 500),
    );
  }
}
