import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/screen/login_screen.dart';

class LangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 80),
            child: SvgPicture.asset("assets/img/Frame.svg"),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      "Русский",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: FlatButton(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      "O`zbekcha",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                child: FlatButton(
                  onPressed: null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff66676C),
                        ),
                        child: Text(
                          "?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text("О приложении"),
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
