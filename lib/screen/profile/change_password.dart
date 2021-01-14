import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
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
  bool _oldpassShow = false;
  bool _repassShow = false;

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

  FocusNode _oldpassNode = FocusNode();
  FocusNode _passNode = FocusNode();
  FocusNode _repassNode = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: _oldpassNode, toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(focusNode: _passNode, toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(focusNode: _repassNode, toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
      ],
    );
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                          child: Container(
                            child: KeyboardActions(
                              disableScroll: true,
                              isDialog: true,
                              config: _buildConfig(context),
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
                                        color:
                                            Color.fromRGBO(178, 183, 208, 0.5),
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
                                              (mediaQuery.size.width <= 360
                                                  ? 0.66
                                                  : 0.72),
                                          child: TextField(
                                            focusNode: _oldpassNode,
                                            onChanged: (text) {
                                              validation();
                                            },
                                            controller: oldPassController,
                                            obscureText: !_oldpassShow,
                                            maxLines: 1,
                                            decoration: InputDecoration.collapsed(
                                                hintText:
                                                    "pass_hint".tr().toString(),
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .display1
                                                    .copyWith(
                                                        fontSize: mediaQuery
                                                                .size.width *
                                                            globals
                                                                .fontSize18)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _oldpassShow = !_oldpassShow;
                                            });
                                          },
                                          child: _oldpassShow
                                              ? SvgPicture.asset(
                                                  "assets/img/eye_open.svg")
                                              : SvgPicture.asset(
                                                  "assets/img/eye_close.svg"),
                                        )
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
                                        color:
                                            Color.fromRGBO(178, 183, 208, 0.5),
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
                                              (mediaQuery.size.width <= 360
                                                  ? 0.66
                                                  : 0.72),
                                          child: TextField(
                                            focusNode: _passNode,
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
                                                    .display1
                                                    .copyWith(
                                                        fontSize: mediaQuery
                                                                .size.width *
                                                            globals
                                                                .fontSize18)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _passShow = !_passShow;
                                            });
                                          },
                                          child: _passShow
                                              ? SvgPicture.asset(
                                                  "assets/img/eye_open.svg")
                                              : SvgPicture.asset(
                                                  "assets/img/eye_close.svg"),
                                        )
                                      ],
                                    ),
                                  ),
                                  MainText(
                                      "confirm_pass_title".tr().toString()),
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
                                        color:
                                            Color.fromRGBO(178, 183, 208, 0.5),
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
                                              (mediaQuery.size.width <= 360
                                                  ? 0.66
                                                  : 0.72),
                                          child: TextField(
                                            focusNode: _repassNode,
                                            onChanged: (text) {
                                              validation();
                                            },
                                            controller: rePassController,
                                            obscureText: !_repassShow,
                                            maxLines: 1,
                                            decoration: InputDecoration.collapsed(
                                                hintText: "confirm_pass_hint"
                                                    .tr()
                                                    .toString(),
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .display1
                                                    .copyWith(
                                                        fontSize: mediaQuery
                                                                .size.width *
                                                            globals
                                                                .fontSize18)),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _repassShow = !_repassShow;
                                            });
                                          },
                                          child: _repassShow
                                              ? SvgPicture.asset(
                                                  "assets/img/eye_open.svg")
                                              : SvgPicture.asset(
                                                  "assets/img/eye_close.svg"),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                    "change".tr().toString(),
                                    () {},
                                    Color(0xffB2B7D0),
                                  )
                                : DefaultButton("change".tr().toString(), () {
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
      ),
    );
  }
}
