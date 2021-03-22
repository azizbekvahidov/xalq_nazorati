import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/login_screen.dart';
import 'package:xalq_nazorati/screen/register/register_phone_screen.dart';

class QuitDialog extends StatelessWidget {
  final String routeName;
  const QuitDialog({this.routeName, Key key}) : super(key: key);

  Future quitProfile() async {
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/logout';
    Map map = {
      "fcm_token": globals.deviceToken,
    };
    Map<String, String> headers = {"Authorization": "token ${globals.token}"};
    var response = await Requests.post(
      url,
      headers: headers,
      body: map,
    );
    // request.methodPost(map, url);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', null);
      globals.userData = null;
      globals.token = null;
    } else {
      var responseBody = response.json();
      print(responseBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            "assets/img/info.svg",
            height: height * 0.12,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "are_you_sure_quit".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: width * globals.fontSize16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 35),
                child: FlatButton(
                  child: Container(
                      width: width,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "quit".tr().toString(),
                          style: TextStyle(
                              fontSize: width * globals.fontSize16,
                              color: Colors.white),
                        ),
                      )),
                  onPressed: () {
                    quitProfile().then((value) {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamedAndRemoveUntil(HomePage.routeName,
                              (Route<dynamic> route) => false);
                    });
                    // Navigator.pop(context, true);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 35),
                child: FlatButton(
                  child: Container(
                      width: width,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "cancel".tr().toString(),
                          style: TextStyle(
                              fontSize: width * globals.fontSize16,
                              color: Theme.of(context).primaryColor),
                        ),
                      )),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
