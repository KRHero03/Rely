import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget(this.title, this.message);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style: const TextStyle(fontSize: 32.0, color: Color(0xff4564e5), fontFamily: 'Standard'),
              textAlign: TextAlign.center),
          Text(message,
              style: const TextStyle(fontSize: 16.0, color: Color(0xff4564e5), fontFamily: 'Standard'),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}