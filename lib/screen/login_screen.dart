import 'package:flutter/gestures.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import '../methods/helper.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass_phone.dart';
import 'register/register_phone_screen.dart';
import '../widget/input/pass_input.dart';
import '../widget/default_button.dart';
import '../widget/text/main_text.dart';
import '../widget/input/phone_input.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-page";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final MaskedTextController phoneController = MaskedTextController(
      mask: '00 000 00 00', translator: {"0": RegExp(r'[0-9]')});
  final passController = TextEditingController();
  FocusNode phoneNode = FocusNode();
  FocusNode passNode = FocusNode();
  bool isLogin = false;
  Helper helper = new Helper();

  @override
  @override
  void initState() {
    super.initState();
    phoneController.afterChange = (previous, next) {
      if (previous.length < next.length) {
        phoneController.moveCursorToEnd();
      }
    };
  }

  void getLogin() async {
    // print(globals.deviceToken);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', null);
    String phone = "+998${phoneController.text}";
    phone = phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String pass = passController.text;
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/signin';
    Map map = {
      "phone": phone,
      "password": pass,
      "fcm_token": globals.deviceToken,
      "device_type": globals.device,
      "lang": globals.lang.tr().toString()
    };
    var response = await Requests.post(
      url,
      body: map,
    );
    // request.methodPost(map, url);
    if (response.statusCode == 200) {
      // Map<String,dynamic> reply = response.json();

      Map<String, dynamic> responseBody = response.json();
      addStringToSF(responseBody["token"]);
      globals.token = responseBody["token"];
      await getUser();
      isLogin = true;
    } else {
      Map<String, dynamic> responseBody = response.json();
      helper.getToast(responseBody['message'], context);
    }

    if (isLogin)
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          HomePage.routeName, (Route<dynamic> route) => false);
  }

  getUser() async {
    var url = '${globals.api_link}/users/profile';
    Map<String, String> headers = {"Authorization": "token ${globals.token}"};

    var response = await Requests.get(url, headers: headers);
    if (response.statusCode == 200) {
      // dynamic json = response.json();

      globals.userData = response.json();
      print(globals.userData);
    } else {
      globals.token = null;
      dynamic json = response.json();
      helper.getToast(json['detail'], context);
    }
    // String reply = await response.transform(utf8.decoder).join();
    // print(response.statusCode);
    // globals.userData = json.decode(reply);
  }

  double logoScale = 0.35;
  double contentScale = 0.65;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      // keyboardSeparatorColor: Colors.grey,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: phoneNode, toolbarButtons: [
          (node) {
            logoScale = 0.27;
            contentScale = 0.73;
            return GestureDetector(
              onTap: () {
                node.unfocus();
                logoScale = 0.35;
                contentScale = 0.65;
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(focusNode: passNode, toolbarButtons: [
          (node) {
            logoScale = 0.27;
            contentScale = 0.73;
            return GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              onTap: () {
                node.unfocus();
                logoScale = 0.35;
                contentScale = 0.65;
              },
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

  addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
    final dHeight = mediaQuery.size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff12B79B),
            Color(0xff00AC8A),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            logoScale = 0.35;
            contentScale = 0.65;
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return HomePage();
                    }), (Route<dynamic> route) => false);
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: dHeight * logoScale, //mediaQuery.size.height,
                    width: double.infinity,
                    child: Center(
                      child: SvgPicture.asset("assets/img/FrameW.svg"),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: dHeight * contentScale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Stack(
                      children: [
                        KeyboardActions(
                          enable: true,
                          overscroll: 500.0,
                          autoScroll: true,
                          config: _buildConfig(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText("tel_number_title".tr().toString()),
                              PhoneInput(
                                myController: phoneController,
                                textFocusNode: phoneNode,
                              ),
                              MainText("pass_title".tr().toString()),
                              PassInput(
                                hint: "pass_hint".tr().toString(),
                                passController: passController,
                                notifyParent: null,
                                textFocusNode: passNode,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ForgotPassPhone.routeName);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    "forgot_pass".tr().toString(),
                                    style: TextStyle(
                                        fontFamily: globals.font,
                                        fontSize: 16,
                                        color: Color(0xff858589)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DefaultButton("log_in".tr().toString(), () {
                                    getLogin();
                                  }, Theme.of(context).primaryColor),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "accaunt_question".tr().toString(),
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWith * globals.fontSize14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              RegisterPhoneScreen.routeName);
                                        },
                                        child: Text(
                                          "sign_ups".tr().toString(),
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize:
                                                dWith * globals.fontSize14,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
