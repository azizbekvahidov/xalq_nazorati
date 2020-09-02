import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/screen/main_page/navigator.dart';
import './main_page/main_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home-page";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color _selectColor = Color(0xff66676C);
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            MainPage(),
            Container(
              child: Center(
                child: Text("Чат"),
              ),
            ),
            Container(
              child: Center(
                child: Text("Помошь"),
              ),
            ),
            Container(
              child: Center(
                child: Text("Прифиль"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
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
              color: _selectColor,
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
      ),
    );
  }
}
