import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat/main_chat.dart';
import 'profile/main_profile.dart';
import 'support/main_support.dart';
import 'main_page/main_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home-page";
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _children = [
    MainPage(),
    MainChat(),
    MainSupport(),
    MainProfile(),
  ];
  List<Color> _colors = [
    Color(0xff1abc9c),
    Color(0xff66676C),
    Color(0xff66676C),
    Color(0xff66676C),
  ];
  Widget _page = MainPage();
  int _currentIndex = 0;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    globals.navKey = navigatorKey;
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            inactiveColor: Color(0xffFF8F27),
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Главная',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/home.svg", color: _colors[0]),
          ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Чат',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/chat.svg", color: _colors[1]),
          ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Помощь',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset(
              "assets/img/support.svg",
              color: _colors[2],
            ),
          ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Профиль',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/profile.svg", color: _colors[3]),
          ),
        ],
        onItemSelected: (index) {
          setState(() {
            _colors[0] = Color(0xff66676C);
            _colors[1] = Color(0xff66676C);
            _colors[2] = Color(0xff66676C);
            _colors[3] = Color(0xff66676C);
            _page = _children[index];
            _colors[index] = Theme.of(context).primaryColor;
          });
          navigatorKey.currentState.popUntil((route) => route.isFirst);
          _currentIndex = index;
        },
        selectedIndex: _currentIndex,
      ),
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _page,
        pageRoute: PageRoutes.materialPageRoute,
      ),
    );
  }
}
