import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/methods/helper.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass.dart';
import '../../widget/default_button.dart';
import '../../widget/text/main_text.dart';
import '../../widget/input/phone_input.dart';

_ForgotPassPhoneState forgotPassPhoneState;

class ForgotPassPhone extends StatefulWidget {
  static const routeName = "/forgot-pass-phone";

  @override
  _ForgotPassPhoneState createState() {
    forgotPassPhoneState = _ForgotPassPhoneState();
    return forgotPassPhoneState;
  }
}

class _ForgotPassPhoneState extends State<ForgotPassPhone> {
  final MaskedTextController phoneController = MaskedTextController(
      mask: '00 000 00 00', translator: {"0": RegExp(r'[0-9]')});
  bool _value = false;
  String phoneWiew = "";
  bool isRegister = false;
  Helper helper = new Helper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.afterChange = (previous, next) {
      if (previous.length < next.length) {
        phoneController.moveCursorToEnd();
      }
    };
  }

  void getCode() async {
    String signature = await SmsRetrieved.getAppSignature();
    print(signature);
    String phone = "+998${phoneController.text}";
    phone = phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if (phoneController.text == "") phone = "";

    if (phone != "") {
      try {
        Map map = {"phone": phone};
        if (signature != null) map.addAll({"passcode": signature});

        var connect = new DioConnection();

        Map<String, String> headers = {};
        var response = await connect.postCoockieHttp(
            '/users/recover-code', forgotPassPhoneState, headers, map);

        if (response["statusCode"] == 200) {
          dynamic json = response["result"];
          isRegister = true;
          phoneWiew = json["phone_view"];
          if (isRegister) {
            setState(() {
              phoneController.text = "";
            });
            isRegister = false;
            Navigator.of(context).push(MaterialPageRoute(
                settings: const RouteSettings(name: ForgotPass.routeName),
                builder: (context) => ForgotPass(
                      phoneView: phoneWiew,
                      phone: phone,
                    )));
          }
        } else {
          dynamic json = response["result"];
          print(json['detail']);
          helper.getToast(json['detail'], context);
          print(json);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  FocusNode phoneNode = FocusNode();
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: phoneNode, toolbarButtons: [
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
                              child: KeyboardActions(
                                disableScroll: true,
                                // isDialog: true,
                                config: _buildConfig(context),
                                child: Container(
                                  padding:
                                      EdgeInsets.only(bottom: 30, left: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainText("tel_number_title".tr().toString()),
                                PhoneInput(
                                  myController: phoneController,
                                  textFocusNode: phoneNode,
                                ),
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
                                                fontSize: dWith < 400 ? 13 : 14,
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
