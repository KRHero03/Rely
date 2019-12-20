
import 'package:Rely/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => new _IntroState();
}

class _IntroState extends State<Intro> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Rely",
        styleTitle: TextStyle(
          fontSize: 50,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        styleDescription: TextStyle(
          fontSize: 25,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        description: "Your one stop App for all your dairy products. Let's go!",
        pathImage: 'assets/images/Intro/Slide1.png',
        backgroundColor: Color(0xff4564e5),
      ),
    );
    slides.add(
      new Slide(
        title: "On your Tips!",
        styleTitle: TextStyle(
          fontSize: 50,
          fontFamily: 'Standard',
          color: Color(0xff4564e5),
        ),
        styleDescription: TextStyle(
          fontSize: 25,
          fontFamily: 'Standard',
          color: Color(0xff4564e5),
        ),
        description:
            "All products on your fingertips. Order anything...from Milk to Bread to Samosa to any other breakfast item based on daily, monthly or even yearly Subsciptions!",
        pathImage: "assets/images/Intro/Slide2.png",
        backgroundColor: Color(0xfff3f5ff),
      ),
    );
    slides.add(
      new Slide(
        title: "Customizable Delivery Options",
        maxLineTitle: 2,
        styleTitle: TextStyle(
          fontSize: 50,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        styleDescription: TextStyle(
          fontSize: 25,
          fontFamily: 'Standard',
          color: Color(0xfff3f5ff),
        ),
        description:
            "Already got plans? We understand. Cancel your subsciptions anytime, for any day, but, before they are delivered!",
        pathImage: "assets/images/Intro/Slide3.png",
        backgroundColor: Color(0xff4564e5),
      ),
    );
  }

  void onDonePress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  void onSkipPress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  Widget renderNextBtn() {
    return Icon(
      MdiIcons.chevronRight,
      color: Color(0xff4edbf2),
      size: 40
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      MdiIcons.check,
      color: Color(0xff4edbf2),
      size: 40
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      MdiIcons.chevronDoubleRight,
      color: Color(0xff4edbf2),
      size: 40
    );
  }


  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
      renderDoneBtn: renderDoneBtn(),
      renderNextBtn: renderNextBtn(),
      renderSkipBtn: renderSkipBtn(),
      colorDot: Color(0xff000000),
      colorActiveDot: Color(0xff4edbf2),
      sizeDot: 10.0,
    );
  }
}
