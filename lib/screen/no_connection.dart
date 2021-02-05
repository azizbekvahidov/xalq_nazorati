import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/tetris/gamer/gamer.dart';
import 'package:xalq_nazorati/tetris/gamer/keyboard.dart';
import 'package:xalq_nazorati/tetris/material/audios.dart';
import 'package:xalq_nazorati/tetris/panel/page_portrait.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/tetris/tetris.dart';
import 'package:xalq_nazorati/widget/default_button.dart';

class NoConnection extends StatefulWidget {
  static const routeName = "/no_internet-page";
  NoConnection({Key key}) : super(key: key);

  @override
  _NoConnectionState createState() => _NoConnectionState();
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
                  Image.asset("assets/img/offline.png"),
                  Text(
                    "Нет интернета .(",
                    style: TextStyle(
                      color: Color(0xff66676C),
                      fontFamily: globals.font,
                      fontSize: dWidth * globals.fontSize24,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 35),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Чтобы скрасить \nожидание поиграйте",
                          style: TextStyle(
                            color: Color(0xff66676C),
                            fontFamily: globals.font,
                            fontSize: dWidth * globals.fontSize16,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext ctx) {
                                return Tetris();
                              }));
                            },
                            child: SvgPicture.asset("assets/img/play.svg"))
                      ],
                    ),
                  ),
                ],
              ),
              DefaultButton("Повторить", () {
                if (globals.isConnection) {
                  Navigator.of(context).pop();
                }
              }, Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
