import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/register/android_camera.dart';
import 'package:xalq_nazorati/screen/register/camera_page.dart';
import 'package:xalq_nazorati/screen/register/pas_recognize_notify.dart';
import '../../widget/app_bar/custom_appBar.dart';
import './pas_recognized_screen.dart';
import '../../widget/default_button.dart';
import '../../widget/input/default_input.dart';
import '../../widget/text/main_text.dart';

class PassRecognizeScreen extends StatefulWidget {
  static const routeName = "/register-pass-recognize";

  @override
  _PassRecognizeScreenState createState() => _PassRecognizeScreenState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _PassRecognizeScreenState extends State<PassRecognizeScreen> {
  final pnflController = TextEditingController();
  final seriesController = TextEditingController();
  final seriesNumController = TextEditingController();

  FocusNode passSeriesNode = FocusNode();
  FocusNode passNumNode = FocusNode();
  FocusNode passpnflNode = FocusNode();

  bool _value = false;
  bool isError = false;
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: passSeriesNode, toolbarButtons: [
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
        KeyboardActionsItem(focusNode: passNumNode, toolbarButtons: [
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
        KeyboardActionsItem(focusNode: passpnflNode, toolbarButtons: [
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

  Future sendData() async {
    String pnfl = pnflController.text;
    String series = seriesController.text;
    String seriesNum = seriesNumController.text;
    if (_value && pnfl != "" && series != "" && seriesNum != "") {
      String url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/data-from-cep';
      Map map = {"pinpp": pnfl, 'document': "$seriesNum$series"};
      // String url = '${globals.api_link}/users/get-phone';
      var r1 = await Requests.post(url,
          body: map, verify: false, persistCookies: true);
      // print(json.encode(utf8.decode(r1.bytes())));

      if (r1.statusCode == 200) {
        r1.raiseForStatus();

        dynamic json = r1.json();
        // print(json["detail"]);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          settings: const RouteSettings(name: PasRecognizedScreen.routeName),
          builder: (context) => PasRecognizedScreen(
            data: json,
          ),
        ));
      } else {
        var json = r1.json();
        print(json);
        Fluttertoast.showToast(
            msg: json['data']['detail'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    }
  }

  validate() {
    if (seriesController.text != "" && pnflController.text != "") {
      print("true");
      setState(() {
        _value = true;
      });
    } else {
      setState(() {
        _value = false;
      });
    }
  }

  customDialog(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              width: dWidth,
              height: dHeight * 0.6,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: dHeight * 0.02),
                    child: Text(
                      "pass_warning_head".tr().toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: globals.font,
                          fontSize: dWidth * globals.fontSize18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Container(
                    child: SvgPicture.asset(
                      "assets/img/Passport.svg",
                      height: dHeight * 0.28,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "pass_warning_bottom".tr().toString(),
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: dWidth * globals.fontSize10,
                            color: Color(0xff313B6C),
                            fontWeight: FontWeight.w700,
                            fontFeatures: [
                              FontFeature.enable("pnum"),
                              FontFeature.enable("lnum")
                            ],
                          ),
                        ),
                        TextSpan(
                          text: "pass_warning_number".tr().toString(),
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: dWidth * globals.fontSize10,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontFeatures: [
                              FontFeature.enable("pnum"),
                              FontFeature.enable("lnum")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "close".tr().toString(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
    final dHeight = mediaQuery.size.height;
    final PreferredSizeWidget appBar =
        CustomAppBar(title: "identity_user".tr().toString());
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appBar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              isError
                  ? Container(
                      height: 58,
                      color: Color(0xffFF5555),
                      child: Center(
                        child: Text(
                          "camera_error".tr().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: globals.font,
                            fontSize: dWith * globals.fontSize16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                height: mediaQuery.size.height -
                    mediaQuery.size.height * (isError ? 0.2 : 0.12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 270,
                      margin: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: KeyboardActions(
                        disableScroll: true,
                        // isDialog: true,
                        config: _buildConfig(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("pas_series_title".tr().toString()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: (dWith <= 360)
                                      ? dWith * 0.14
                                      : dWith * 0.16,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF5F6F9),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(22.5),
                                        bottomLeft: Radius.circular(22.5)),
                                    border: Border.all(
                                      color: Color.fromRGBO(178, 183, 208, 0.5),
                                      style: BorderStyle.solid,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3),
                                        width: (mediaQuery.size.width -
                                                mediaQuery.padding.left -
                                                mediaQuery.padding.right) *
                                            ((dWith <= 360) ? 0.08 : 0.08),
                                        child: TextField(
                                          inputFormatters: [
                                            UpperCaseTextFormatter(),
                                          ],
                                          focusNode: passSeriesNode,
                                          onChanged: (value) {
                                            validate();
                                          },
                                          controller: seriesNumController,
                                          maxLines: 1,
                                          maxLength: 2,
                                          buildCounter: (BuildContext context,
                                                  {int currentLength,
                                                  int maxLength,
                                                  bool isFocused}) =>
                                              null,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                top: 0, bottom: 10),
                                            border: InputBorder.none,
                                            hintText: "AA",
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .display1
                                                .copyWith(
                                                    fontSize: dWith *
                                                        globals.fontSize16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: (dWith <= 360)
                                      ? dWith * 0.50
                                      : dWith * 0.53,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF5F6F9),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(22.5),
                                        bottomRight: Radius.circular(22.5)),
                                    border: Border.all(
                                      color: Color.fromRGBO(178, 183, 208, 0.5),
                                      style: BorderStyle.solid,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3),
                                        width: (mediaQuery.size.width -
                                                mediaQuery.padding.left -
                                                mediaQuery.padding.right) *
                                            ((dWith <= 360) ? 0.42 : 0.42),
                                        child: TextField(
                                          focusNode: passNumNode,
                                          onChanged: (value) {
                                            validate();
                                          },
                                          controller: seriesController,
                                          maxLines: 1,
                                          maxLength: 7,
                                          buildCounter: (BuildContext context,
                                                  {int currentLength,
                                                  int maxLength,
                                                  bool isFocused}) =>
                                              null,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                top: 0, bottom: 10),
                                            border: InputBorder.none,
                                            hintText: "1234567",
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .display1
                                                .copyWith(
                                                    fontSize: dWith *
                                                        globals.fontSize16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PasRecognizeNotify()));
                                    if (res != null) {
                                      if (res is String) {
                                        print(
                                            "result of scan ==============> ${res.runtimeType}");
                                        setState(() {
                                          isError = true;
                                        });
                                      } else {
                                        setState(() {
                                          pnflController.text =
                                              res.personalNumber;
                                          seriesNumController.text = res
                                              .documentNumber
                                              .substring(0, 2);
                                          seriesController.text =
                                              res.documentNumber.substring(2);
                                        });
                                        validate();
                                      }
                                    }
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      width: 45,
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(22.5),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/img/qr-code-scan.svg",
                                        width: 15,
                                      )),
                                ),
                              ],
                            ),
                            MainText("pnfl".tr().toString()),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    width: (dWith <= 360)
                                        ? dWith * 0.80
                                        : dWith * 0.89,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 3),
                                          width: (mediaQuery.size.width -
                                                  mediaQuery.padding.left -
                                                  mediaQuery.padding.right) *
                                              ((dWith <= 360) ? 0.5 : 0.4),
                                          child: TextField(
                                            focusNode: passpnflNode,
                                            onChanged: (value) {
                                              validate();
                                            },
                                            controller: pnflController,
                                            maxLines: 1,
                                            maxLength: 14,
                                            buildCounter: (BuildContext context,
                                                    {int currentLength,
                                                    int maxLength,
                                                    bool isFocused}) =>
                                                null,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, bottom: 10),
                                              border: InputBorder.none,
                                              hintText:
                                                  "enter_pnfl".tr().toString(),
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .display1
                                                  .copyWith(
                                                      fontSize: dWith *
                                                          globals.fontSize16),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            customDialog(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xffE5E7EC),
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(22.5),
                                                  bottomRight:
                                                      Radius.circular(22.5)),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    178, 183, 208, 1),
                                                style: BorderStyle.solid,
                                                width: 0.5,
                                              ),
                                            ),
                                            width: 45,
                                            height: 45,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  "assets/img/ques.svg"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                          ],
                        ),
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
                                        "continue".tr().toString(),
                                        () {},
                                        Color(0xffB2B7D0),
                                      )
                                    : DefaultButton("continue".tr().toString(),
                                        () {
                                        sendData().then((value) {
                                          setState(() {
                                            _value = !_value;
                                          });
                                        });
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
            ],
          ),
        ),
      ),
    );
  }
}
