import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/login_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/widget/input/textarea_input.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class DeleteProfile extends StatefulWidget {
  @override
  _DeleteProfileState createState() => _DeleteProfileState();
}

class _DeleteProfileState extends State<DeleteProfile> {
  var descController = TextEditingController();
  bool _value = false;

  Future deleteProfile() async {
    String desc = descController.text;
    if (desc != "") {
      try {
        var url = '${globals.api_link}/users/profile';

        Map<String, String> map = {"reason": desc};
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}",
        };
        // var req = await http.put(Uri.parse(url), headers: headers, body: map);
        var r1 = await Requests.delete(url,
            body: map, headers: headers, verify: false);
        if (r1.statusCode == 204) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          r1.raiseForStatus();
          prefs.setString('userToken', null);
          globals.userData = null;
        } else {
          print(r1);
        }
      } catch (ex) {
        print(ex);
      }
    }
  }

  checkChange() {
    String descValue = descController.text;
    setState(() {
      if (descValue != "")
        _value = true;
      else
        _value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appbar = CustomAppBar(
      title: "Удалить учетную запись",
    );
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appbar,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: mediaQuery.size.height - mediaQuery.size.height * 0.17,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SvgPicture.asset("assets/img/warning.svg"),
                          ),
                          Expanded(
                            flex: 9,
                            child: Text(
                              "Внимание! Пожалуйста, удаляйте свою учетную запись, только если вы больше не хотите использовать Xalq Nazorati. Если вы удалите свою учетную запись сейчас, регистрация может быть невозможна в течение нескольких дней.",
                              style: TextStyle(
                                  color: Color(0xffFF8F27),
                                  fontSize: 12,
                                  fontFamily: "Gilroy"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ShadowBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("Почему вы удаляете аккаунт?"),
                            TextareaInput(
                              hint: "hint",
                              textareaController: descController,
                              notifyParent: checkChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(38),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child:
                              /*!_value
                              ? DefaultButton(
                                  "Продолжить",
                                  () {},
                                  Color(0xffB2B7D0),
                                )
                              : */
                              DefaultButton("Удалите мой аккаунт", () {
                            deleteProfile().then((value) {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamedAndRemoveUntil(
                                      LoginScreen.routeName,
                                      (Route<dynamic> route) => false);
                            });
                            // setState(() {
                            //   _value = !_value;
                            // });
                            // Navigator.of(context)
                            //     .pushNamed(PasRecognizedScreen.routeName);
                          }, Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
