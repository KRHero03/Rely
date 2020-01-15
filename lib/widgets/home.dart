import 'package:Rely/models/enum.dart';
import 'package:Rely/widgets/account/account.dart';
import 'package:Rely/widgets/circular_image_view.dart';
import 'package:Rely/widgets/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  int _tabSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   
    double _lastFeedScrollOffset = 0;
    ScrollController _scrollController;

    void _disposeScrollController() {
      if (_scrollController != null) {
        _lastFeedScrollOffset = _scrollController.offset;
        _scrollController.dispose();
        _scrollController = null;
      }
    }

    @override
    void dispose() {
      _disposeScrollController();
      super.dispose();
    }

    void _scrollToTop() {
      if (_scrollController == null) {
        return;
      }
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 250),
        curve: Curves.decelerate,
      );
    }
    const tabIndexToNameMap = {
            0: 'Home',
            1: 'Subscription',
            2: 'Account'
          };

    Widget _buildPlaceHolderTab(String tabName) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: Column(
            children: <Widget>[
              Text(
                'Oops, the $tabName tab is\n under construction!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.0),
              ),
              Image.asset('assets/images/building.gif'),
            ],
          ),
        ),
      );
    }

    void _onTabTapped(BuildContext context, int index) {
      setState(() => _tabSelectedIndex = index);
      print(_tabSelectedIndex);
    }

    Widget _buildBottomNavigation() {
      const unselectedIcons = <IconData>[
        MdiIcons.homeOutline,
        MdiIcons.cartOutline,
        MdiIcons.accountOutline
      ];
      const selecteedIcons = <IconData>[
        MdiIcons.home,
        MdiIcons.cart,
        MdiIcons.account,
      ];
      final bottomNaivgationItems = List.generate(3, (int i) {
        final iconData =
            _tabSelectedIndex == i ? selecteedIcons[i] : unselectedIcons[i];
        return BottomNavigationBarItem(
            icon: Icon(iconData), title: Container());
      }).toList();

      return Builder(builder: (BuildContext context) {
        return BottomNavigationBar(
          backgroundColor: Color(0xfff3f5ff),
          iconSize: 30.0,
          type: BottomNavigationBarType.fixed,
          items: bottomNaivgationItems,
          currentIndex: _tabSelectedIndex,
          onTap: (int i) => _onTabTapped(context, i),
        );
      });
    }

    Widget _buildBody() {
      switch (_tabSelectedIndex) {
        case 0:
          _scrollController =
              ScrollController(initialScrollOffset: _lastFeedScrollOffset);
          return HomePage(scrollController: _scrollController);
          case 2:
          _scrollController =
              ScrollController(initialScrollOffset: _lastFeedScrollOffset);
          return Account(scrollController: _scrollController);
        default:
          
          _disposeScrollController();
          return _buildPlaceHolderTab(tabIndexToNameMap[_tabSelectedIndex]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff3f5ff),
        elevation: 1.0,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[CircularImageView(
                    w: 50,
                    h: 50,
                    imageLink: 'assets/images/logo/round.png',
                    imgSrc: ImageSourceENUM.Asset,
                  ),
                
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                'Rely - '+tabIndexToNameMap[_tabSelectedIndex].toString(),
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
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
