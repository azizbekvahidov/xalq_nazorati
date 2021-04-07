import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/tetris/gamer/gamer.dart';
import 'package:xalq_nazorati/tetris/gamer/keyboard.dart';
import 'package:xalq_nazorati/tetris/material/audios.dart';
import 'package:xalq_nazorati/tetris/panel/page_portrait.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/tetris/tetris.dart';
import 'package:xalq_nazorati/widget/default_button.dart';

class NoConnection extends StatefulWidget {
  static const routeName = "/no_internet-page";
  NoConnection({Key key}) : super(key: key);

  @override
  _NoConnectionState createState() => _NoConnectionState();
}

ConnectivityResult connectivityResult = ConnectivityResult.none;
final Connectivity _connectivity = Connectivity();
initConnectivity(context) async {
  ConnectivityResult result;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    result = await _connectivity.checkConnectivity();
  } on PlatformException catch (e) {
    print(e.toString());
  }
  Future<ConnectivityResult> res = _connectivity.checkConnectivity();
  res.then((value) => _updateConnectionStatus(value, context));
}

Future<void> _updateConnectionStatus(ConnectivityResult result, context) async {
  print(result);
  switch (result) {
    case ConnectivityResult.wifi:
    case ConnectivityResult.mobile:
      globals.isConnection = true;
      print("connected");

      if (globals.isConnection) {
        Navigator.of(context).pop();
      }
      break;
    case ConnectivityResult.none:
      break;
  }
  print(globals.isConnection);
}

class _NoConnectionState extends State<NoConnection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xffF5F6F9),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    "no_internet".tr().toString(),
                    style: TextStyle(
                      color: Color(0xff415095),
                      fontFamily: globals.font,
                      fontWeight: FontWeight.w600,
                      fontSize: dWidth * globals.fontSize22,
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Image.asset(
                          "assets/img/offline_bg.png",
                          width: dWidth * 0.9,
                        ),
                      ),
                      Positioned(
                        child: SvgPicture.asset(
                          "assets/img/offline.svg",
                          width: dWidth,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 35),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "play_game_till".tr().toString(),
                          style: TextStyle(
                            color: Color(0xff66676C),
                            fontFamily: globals.font,
                            fontSize: dWidth * globals.fontSize16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext ctx) {
                          return Tetris();
                        }));
                      },
                      child: SvgPicture.asset(
                        "assets/img/play.svg",
                        height: 38,
                      ))
                ],
              ),
              DefaultButton("reload".tr().toString(), () {
                initConnectivity(context);
              }, Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
