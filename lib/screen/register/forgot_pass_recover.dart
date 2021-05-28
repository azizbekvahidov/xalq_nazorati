import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/methods/helper.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass.dart';
import 'package:xalq_nazorati/widget/input/pass_input.dart';
import '../login_screen.dart';
import '../../widget/default_button.dart';
import '../../widget/text/main_text.dart';

_ForgotPassRecoverState forgotPassRecoverState;

class ForgotPassRecover extends StatefulWidget {
  static const routeName = "/forgot-pass-recover";

  @override
  _ForgotPassRecoverState createState() {
    forgotPassRecoverState = _ForgotPassRecoverState();
    return forgotPassRecoverState;
  }
}

class _ForgotPassRecoverState extends State<ForgotPassRecover> {
  final passController = TextEditingController();
  final pass2Controller = TextEditingController();
  bool _value = false;
  bool isRegister = false;
  Helper helper = new Helper();
  void getCode() async {
    if (passController.text != "" && pass2Controller.text != "") {
      try {
        Map map = {
          "new_password1": passController.text,
          "new_password2": pass2Controller.text
        };
        Map<String, String> headers = {};

        var connect = new DioConnection();
        var response = await connect.postHttp(
            '/users/recover-password', forgotPassRecoverState, headers, map);

        if (response["statusCode"] == 200) {
          isRegister = true;
          isRegister = false;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              settings: const RouteSettings(name: ForgotPass.routeName),
              builder: (context) => LoginScreen()));
        } else {
          dynamic json = response["result"];
          helper.getToast(json['detail'], context);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  FocusNode _passNode = FocusNode();
  FocusNode _repassNode = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
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
    final dWith = mediaQuery.size.width;
    final dHeight = mediaQuery.size.height;
    final PreferredSizeWidget appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
    );
    return Stack(
      children: [
        Container(
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
            appBar: appBar,
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: dHeight * 0.3 -
                          appBar.preferredSize.height, //mediaQuery.size.height,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 30, left: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "reset_txt".tr().toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontFamily: globals.font,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                    ),
                                    Text(
                                      "reset_desc".tr().toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        fontFamily: globals.font,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: mediaQuery.size.height - dHeight * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: KeyboardActions(
                        disableScroll: true,
                        // isDialog: true,
                        config: _buildConfig(context),
                        child: Padding(
                          padding: EdgeInsets.all(25),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MainText("pass_title".tr().toString()),
                                  PassInput(
                                      textFocusNode: _passNode,
                                      hint: "come_up_pass_hint".tr().toString(),
                                      passController: passController,
                                      notifyParent: null),
                                  MainText(
                                      "confirm_pass_title".tr().toString()),
                                  PassInput(
                                      textFocusNode: _repassNode,
                                      hint: "confirm_pass_hint".tr().toString(),
                                      passController: pass2Controller,
                                      notifyParent: null),
                                ],
                              ),
                              Positioned(
                                child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        DefaultButton(
                                          "send".tr().toString(),
                                          () {
                                            getCode();
                                            // Navigator.of(context).pushNamed(
                                            //     RegisterVerifyScreen.routeName);
                                          },
                                          Theme.of(context).primaryColor,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "",
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                fontSize: dWith < 400 ? 13 : 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: () => null,
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                  fontFamily: globals.font,
                                                  fontSize:
                                                      dWith < 400 ? 13 : 14,
                                                  color: Theme.of(context)
                                                      .primaryColor,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        CheckConnection(),
      ],
    );
  }
}
