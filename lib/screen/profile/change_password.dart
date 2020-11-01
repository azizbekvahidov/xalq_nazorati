import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final rePassController = TextEditingController();
  bool _value = false;
  bool _passShow = false;

  void validation() {
    if (oldPassController.text != "" &&
        newPassController.text != "" &&
        rePassController.text != "") {
      setState(() {
        _value = true;
      });
    } else {
      setState(() {
        _value = false;
      });
    }
  }

  Future changePass() async {
    String oldPass = oldPassController.text;
    String newPass = newPassController.text;
    String rePass = rePassController.text;
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/change-password';

    Map map = {
      "old_password": oldPass,
      "new_password1": newPass,
      "new_password2": rePass
    };
    Map<String, String> headers = {
      "Authorization": "token ${globals.token}",
    };

    var r1 = await Requests.post(url,
        body: map, headers: headers, verify: false, persistCookies: true);

    dynamic json = r1.json();
    if (r1.statusCode == 200) {
      r1.raiseForStatus();
      Navigator.of(context).pop();
      // addStringToSF(responseBody["token"]);
      // globals.token = responseBody["token"];
    } else {
      var json = r1.json();
      Map<String, dynamic> res = json['detail'];
      print(json);
      res.forEach((key, value) {
        Fluttertoast.showToast(
            msg: res[key][0],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15.0);
      });
    }
  }

  addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appbar = CustomAppBar(
      title: "change_pass".tr().toString(),
      centerTitle: true,
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
                    ShadowBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("old_pass".tr().toString()),
                            // PassInput("Введите пароль", oldPassController),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xffF5F6F9),
                                borderRadius: BorderRadius.circular(22.5),
                                border: Border.all(
                                  color: Color.fromRGBO(178, 183, 208, 0.5),
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: (mediaQuery.size.width -
                                            mediaQuery.padding.left -
                                            mediaQuery.padding.right) *
                                        0.7,
                                    child: TextField(
                                      onChanged: (text) {
                                        validation();
                                      },
                                      controller: oldPassController,
                                      obscureText: !_passShow,
                                      maxLines: 1,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "pass_hint".tr().toString(),
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MainText("pass_title".tr().toString()),
                            // PassInput("Придумайте пароль", newPassController),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xffF5F6F9),
                                borderRadius: BorderRadius.circular(22.5),
                                border: Border.all(
                                  color: Color.fromRGBO(178, 183, 208, 0.5),
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: (mediaQuery.size.width -
                                            mediaQuery.padding.left -
                                            mediaQuery.padding.right) *
                                        0.7,
                                    child: TextField(
                                      onChanged: (text) {
                                        validation();
                                      },
                                      controller: newPassController,
                                      obscureText: !_passShow,
                                      maxLines: 1,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "come_up_pass_hint"
                                              .tr()
                                              .toString(),
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MainText("confirm_pass_title".tr().toString()),
                            // PassInput("Подтвердите пароль", rePassController),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xffF5F6F9),
                                borderRadius: BorderRadius.circular(22.5),
                                border: Border.all(
                                  color: Color.fromRGBO(178, 183, 208, 0.5),
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: (mediaQuery.size.width -
                                            mediaQuery.padding.left -
                                            mediaQuery.padding.right) *
                                        0.7,
                                    child: TextField(
                                      onChanged: (text) {
                                        validation();
                                      },
                                      controller: rePassController,
                                      obscureText: !_passShow,
                                      maxLines: 1,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "confirm_pass_hint"
                                              .tr()
                                              .toString(),
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ),
                                  ),
                                ],
                              ),
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
                          child: !_value
                              ? DefaultButton(
                                  "change_pass".tr().toString(),
                                  () {},
                                  Color(0xffB2B7D0),
                                )
                              : DefaultButton("change_pass".tr().toString(),
                                  () {
                                  changePass();
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
