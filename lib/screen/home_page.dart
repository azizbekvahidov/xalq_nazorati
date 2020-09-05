import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat/main_chat.dart';
import 'package:xalq_nazorati/screen/main_page/navigator.dart';
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
  Widget _page = MainPage();
  int _currentIndex = 0;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
            icon: SvgPicture.asset(
              "assets/img/home.svg",
            ),
          ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Чат',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/chat.svg"),
          ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Помощь',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/support.svg"),
          ),
          BottomNavyBarItem(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Профиль',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/profile.svg"),
          ),
        ],
        onItemSelected: (index) {
          navigatorKey.currentState.maybePop();
          setState(() => _page = _children[index]);
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
