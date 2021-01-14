import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:requests/requests.dart';
import 'package:sms/sms.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/widget/input/default_input.dart';
import 'package:xalq_nazorati/widget/input/phone_input.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';

class ChangePhone extends StatefulWidget {
  ChangePhone({Key key}) : super(key: key);

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  String _showTime = "03:00";
  Timer _timer;
  int _start = 180;
  bool _isSend = false;
  bool _value = false;
  final phoneController = TextEditingController();

  final codeController = TextEditingController();
  void getSMS() async {
    // Create SMS Receiver Listener
    SmsReceiver receiver = new SmsReceiver();
    // msg has New Incoming Message
    receiver.onSmsReceived.listen((SmsMessage msg) {
      print(msg.address);
      print(msg.body);
      print(msg.date);
      print(msg.isRead);
      print(msg.sender);
      print(msg.threadId);
      print(msg.state);
      final intValue = int.parse(msg.body.replaceAll(RegExp('[^0-9]'), ''));

      codeController.text = intValue.toString();
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _isSend = false;
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

  // Future changeProfile() async {
  //   try {
  //     // String email = emailController.text;
  //     String code = "${codeController.text}";
  //     if (code != "") {
  //       changePhone(code);
  //     }
  //     if (address != "" || email != "") {
  //       var url =
  //           '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/profile';

  //       Map<String, String> map = {};
  //       if (address != '') map.addAll({"address_str": address});
  //       if (email != '') map.addAll({"email": email});
  //       Map<String, String> headers = {
  //         "Authorization": "token ${globals.token}",
  //       };
  //       // var req = await http.put(Uri.parse(url), headers: headers, body: map);
  //       var r1 =
  //           await Requests.put(url, body: map, headers: headers, verify: false);
  //       print(r1.json());
  //       if (r1.statusCode == 200) {
  //         r1.raiseForStatus();
  //         Map<String, dynamic> reply = await r1.json();

  //         globals.userData = reply;
  //         print(reply["address_str"]);
  //         Navigator.of(context).pop();
  //       } else {
  //         print(json);
  //       }
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "fill_personal_data".tr().toString(),
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 2,
  //           backgroundColor: Colors.grey,
  //           textColor: Colors.white,
  //           fontSize: 15.0);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String phone = "";

  Future sendMessage() async {
    if (_start == 0) {
      _start = 180;
      sendMessage();
    } else if (_start == 180) {
      try {
        phone = "+998${phoneController.text}";
        phone = phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        var url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/change-phone';

        Map map = {
          "phone": phone,
        };
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}",
        };
        var r1 = await Requests.post(url,
            body: map, headers: headers, verify: false);

        if (r1.statusCode == 200) {
          var responseBody = r1.json();
          r1.raiseForStatus();
          startTimer();
          _isSend = true;
          // Navigator.of(context).pop();
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
      } catch (e) {
        print(e);
      }
    }
  }

  Future changePhone() async {
    var code = codeController.text;
    try {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/code-validation';

      Map map = {
        "code": code,
      };
      Map<String, String> headers = {
        "Authorization": "token ${globals.token}",
      };
      var r1 =
          await Requests.post(url, body: map, headers: headers, verify: false);

      if (r1.statusCode == 200) {
        print(r1.content());
        r1.raiseForStatus();
        _timer.cancel();
        setState(() {
          globals.userData["phone"] = phone;
        });
        Navigator.pop(context, phone);
      } else {
        print(r1.content());
        Map<String, dynamic> responseBody = r1.json();
        Fluttertoast.showToast(
            msg: responseBody['detail'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } catch (e) {
      print(e);
    }
  }

  validate() {
    if (_isSend && codeController.text != "") {
      _value = true;
    }
  }

  FocusNode _phoneNode = FocusNode();
  FocusNode _codeNode = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: _phoneNode, toolbarButtons: [
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
        KeyboardActionsItem(focusNode: _codeNode, toolbarButtons: [
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
    var maskFormatter = new MaskTextInputFormatter(
        mask: '__ ___ __ __', filter: {"_": RegExp(r'[0-9]')});
    final mediaQuery = MediaQuery.of(context);
    final appbar = CustomAppBar(
      title: "change_phone".tr().toString(),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                child: KeyboardActions(
                                  disableScroll: true,
                                  isDialog: true,
                                  config: _buildConfig(context),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MainText(
                                            "tel_number_title".tr().toString()),
                                        PhoneInput(
                                          myController: phoneController,
                                          textFocusNode: _phoneNode,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            sendMessage();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            width: mediaQuery.size.width,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  26, 188, 156, 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1),
                                            ),
                                            child: Center(
                                                child: Text("get_code"
                                                    .tr()
                                                    .toString())),
                                          ),
                                        ),
                                        MainText(
                                            "check_code_title".tr().toString()),
                                        DefaultInput(
                                          inputType: TextInputType.number,
                                          hint:
                                              "check_code_hint".tr().toString(),
                                          textController: codeController,
                                          notifyParent: () {
                                            validate();
                                          },
                                          textFocusNode: _codeNode,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              width:
                                                  mediaQuery.size.width * 0.85,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    _showTime,
                                                    style: TextStyle(
                                                      fontFamily: globals.font,
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ]),
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
                                      changePhone();
                                      // changeProfile();
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
                ]),
          ),
        ),
      ),
    );
  }
}
