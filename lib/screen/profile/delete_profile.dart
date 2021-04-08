import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/helper.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
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
  Helper helper = new Helper();

  Future deleteProfile() async {
    String desc = descController.text;
    if (desc != "") {
      try {
        var url = '${globals.site_link}/ru/api/users/profile';

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
          globals.token = null;
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              HomePage.routeName, (Route<dynamic> route) => false);
        } else {
          dynamic json = r1.json();
          print(json["detail"]);
          helper.getToast(json["detail"], context);
        }
      } catch (ex) {
        print(ex);
      }
    } else {
      helper.getToast("reason".tr().toString(), context);
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
      title: "delete_profile".tr().toString(),
      centerTitle: true,
    );
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appbar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: mediaQuery.size.height - mediaQuery.size.height * 0.2,
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
                                "delete_accaunt_warning".tr().toString(),
                                style: TextStyle(
                                    color: Color(0xffFF8F27),
                                    fontSize: 12,
                                    fontFamily: globals.font),
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
                              MainText("why_delete_accaunt".tr().toString()),
                              TextareaInput(
                                hint: "why_delete_accaunt_hint".tr().toString(),
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
                                DefaultButton("delete_accaunt".tr().toString(),
                                    () {
                              deleteProfile();
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
      ),
    );
  }
}
