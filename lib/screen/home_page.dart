import 'dart:async';
import 'dart:convert';

import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:custom_navigator/custom_navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/screen/profile/problem/main_problem_page.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_screen.dart';
import 'package:xalq_nazorati/widget/get_login_dialog.dart';
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
  bool isProblemNotify = false;
  Timer timer;
  @override
  void initState() {
    super.initState();
    // getUser();
    refreshBells();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      refreshBells();
    });
    if (globals.routeProblemId != null) {
      Timer(Duration(milliseconds: 500), () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext ctx) {
          return ProblemContentScreen(id: globals.routeProblemId);
        }));
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      var url = '${globals.api_link}/users/profile';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);

      String reply = await response.transform(utf8.decoder).join();

      globals.userData = json.decode(reply);
      return globals.userData;
    } catch (e) {
      print(e);
    }
  }

  void refreshBells() async {
    try {
      if (globals.userData != null || globals.isConnection == true) {
        var url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/notifications-by-state';
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}"
        };
        var response = await Requests.get(url, headers: headers);
        if (response.statusCode == 200) {
          var cnt = 0;
          var res = response.json();

          cnt += res["processing"];
          cnt += res["denied"];
          cnt += res["confirmed"];
          cnt += res["planned"];
          if (cnt != 0)
            isProblemNotify = true;
          else
            isProblemNotify = false;
        }
        setState(() {});
        // String reply = await response.transform(utf8.decoder).join();

        // var temp = parseProblems(reply);
      }
    } catch (e) {
      print(e);
    }
  }

  final List<Widget> _children = [
    MainPage(),
    MainProblemPage(),
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

  customDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: GetLoginDialog(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          if (index == 1) {
            if (globals.userData == null) {
              customDialog(context);
            } else {
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
            }
          } else {
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
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize:
            MediaQuery.of(context).size.width * globals.fontSize12,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // inactiveColor: Color(0xffFF8F27),
            // activeColor: Theme.of(context).primaryColor,
            title: Text(
              'main'.tr().toString(),
              style: TextStyle(fontFamily: globals.font),
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/home.svg", color: _colors[0]),
          ),
          BottomNavigationBarItem(
              // activeColor: Theme.of(context).primaryColor,
              title: Text(
                'problems'.tr().toString(),
                style: TextStyle(fontFamily: globals.font),
                textAlign: TextAlign.center,
              ),
              icon: Stack(
                children: [
                  SvgPicture.asset("assets/img/problem.svg", color: _colors[1]),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: isProblemNotify
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4)),
                          )
                        : Container(),
                  ),
                ],
              )),
          BottomNavigationBarItem(
            // activeColor: Theme.of(context).primaryColor,
            title: Text(
              'help'.tr().toString(),
              style: TextStyle(fontFamily: globals.font),
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/support.svg", color: _colors[2]),
          ),
          BottomNavigationBarItem(
            // activeColor: Theme.of(context).primaryColor,
            title: Text(
              'profile'.tr().toString(),
              style: TextStyle(fontFamily: globals.font),
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset("assets/img/profile.svg", color: _colors[3]),
          ),
        ],
        // selectedIndex: _currentIndex,
        currentIndex: _currentIndex,
      ),
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _page,
        pageRoute: PageRoutes.materialPageRoute,
      ),
    );
  }
}
