import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/main_page/news/news_breaking_screen.dart';
import 'package:xalq_nazorati/screen/main_page/news/news_planned_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _index = 0;
  Color _bg1;
  Color _txt1;
  Color _bg2;
  Color _txt2;
  final List<Widget> _children = [
    NewsBreakingScreen(),
    NewsPlannedScreen(),
  ];

  void _selectTab(index) {
    setState(() {
      _index = index;
      if (index == 0) {
        _bg1 = Theme.of(context).primaryColor;
        _bg2 = Color.fromRGBO(49, 59, 108, 0.05);
        _txt1 = Colors.white;
        _txt2 = Color(0xff66676C);
      } else {
        _bg1 = Color.fromRGBO(49, 59, 108, 0.05);
        _bg2 = Theme.of(context).primaryColor;
        _txt1 = Color(0xff66676C);
        _txt2 = Colors.white;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectTab(_index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "news".tr().toString(),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _selectTab(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: _bg1,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "today".tr().toString(),
                      style: TextStyle(
                        color: _txt1,
                        fontFamily: globals.font,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                GestureDetector(
                  onTap: () {
                    _selectTab(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: _bg2,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "planning".tr().toString(),
                      style: TextStyle(
                        color: _txt2,
                        fontFamily: globals.font,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: _children[_index],
            ),
          ],
        ),
      ),
    );
  }
}
