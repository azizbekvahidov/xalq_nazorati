import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:requests/requests.dart';
import 'package:sms_autofill/sms_autofill.dart';
// import 'package:sms/sms.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/helper.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass_recover.dart';
import '../../widget/default_button.dart';
import '../../widget/text/main_text.dart';

class ForgotPass extends StatefulWidget {
  static const routeName = "/forgot-pass";
  final phoneView;
  final phone;
  ForgotPass({this.phoneView, this.phone});

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  bool _value = false;
  String _showTime = "03:00";
  Timer _timer;
  final codeController = TextEditingController();
  int _start = 180;
  Helper helper = new Helper();

  // void getSMS() async {
  //   // Create SMS Receiver Listener
  //   SmsReceiver receiver = new SmsReceiver();
  //   // msg has New Incoming Message
  //   receiver.onSmsReceived.listen((SmsMessage msg) {
  //     print(msg.address);
  //     print(msg.body);
  //     print(msg.date);
  //     print(msg.isRead);
  //     print(msg.sender);
  //     print(msg.threadId);
  //     print(msg.state);
  //     final intValue = int.parse(msg.body.replaceAll(RegExp('[^0-9]'), ''));

  //     codeController.text = intValue.toString();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    startTimer();
    _listenForCode();

    // getSMS();
  }

  void _listenForCode() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
            // _showTime = "$_start";
            int min = (_start / 60).toInt();
            int sec = _start - (min * 60);
            String secs = "$sec";
            if (sec < 10) secs = "0$sec";
            _showTime = "0$min:$secs";
          }
        },
      ),
    );
  }

  void resendCode() async {
    if (_start == 0) {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/retry-signup-code';
      var r1 = await Requests.post(url, verify: false, persistCookies: true);
      r1.raiseForStatus();

      _start = 180;
      startTimer();
      // _startListening();
      // print(responseBody["detail"]);
    }
  }

  bool isSend = false;
  void verify() async {
    String code = codeController.text;

    if (!isSend && code != "") {
      try {
        String url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/recover-code-validation';
        Map map = {"code": int.parse(code)};
        // String url = '${globals.api_link}/users/get-phone';
        var r1 = await Requests.post(url,
            body: map, verify: false, persistCookies: true);

        if (r1.statusCode == 200) isSend = true;
        if (isSend) {
          globals.tempPhone = widget.phone;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              settings: const RouteSettings(name: ForgotPassRecover.routeName),
              builder: (context) => ForgotPassRecover()));
        } else {
          dynamic json = r1.json();
          helper.getToast(json["detail"], context);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  FocusNode codeNode = FocusNode();
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: codeNode, toolbarButtons: [
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
                            // isDialog: true,
                            config: _buildConfig(context),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 30, left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "check".tr().toString(),
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
                                    "${"sended_code_desc_start".tr().toString()}${widget.phoneView}${"sended_code_desc_end".tr().toString()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      fontFamily: globals.font,
                                      fontFeatures: [
                                        FontFeature.enable("pnum"),
                                        FontFeature.enable("lnum")
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
                            MainText("check_code_title".tr().toString()),
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
                                        0.71,
                                    child: Platform.isIOS
                                        ? TextField(
                                            autofocus: true,
                                            focusNode: codeNode,
                                            controller: codeController,
                                            // onCodeChanged: (val) {
                                            //   print(val);
                                            //   codeController.text = val;
                                            //   // _listenForCode();
                                            // },
                                            decoration: InputDecoration(
                                                counterText: "",
                                                disabledBorder:
                                                    InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusColor: Colors.black,
                                                focusedBorder: InputBorder.none,
                                                counterStyle: TextStyle(
                                                    color: Colors.black)),
                                            // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
                                            maxLength: 6,
                                            // codeLength: 6,
                                            //code length, default 6
                                          )
                                        : TextFieldPinAutoFill(
                                            focusNode: codeNode,
                                            currentCode: codeController.text,
                                            onCodeChanged: (val) {
                                              print(val);
                                              codeController.text = val;
                                              // _listenForCode();
                                            },
                                            decoration: InputDecoration(
                                                counterText: "",
                                                disabledBorder:
                                                    InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusColor: Colors.black,
                                                focusedBorder: InputBorder.none,
                                                counterStyle: TextStyle(
                                                    color: Colors.black)),
                                            // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,

                                            codeLength: 6,
                                            //code length, default 6
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: mediaQuery.size.width * 0.83,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _showTime,
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
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
                                    "continue".tr().toString(),
                                    () {
                                      verify();
                                    },
                                    Theme.of(context).primaryColor,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "dont_get_code".tr().toString(),
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWith < 400 ? 13 : 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          resendCode();
                                        },
                                        child: Text(
                                          "resend".tr().toString(),
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize: dWith < 400 ? 13 : 14,
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
