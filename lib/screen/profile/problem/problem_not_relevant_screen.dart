import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:xalq_nazorati/screen/home_page.dart';
import '../../../widget/app_bar/custom_appBar.dart';
import '../../../widget/custom_dotted_circle_container.dart';
import '../../../widget/default_button.dart';
import '../../../widget/input/textarea_input.dart';
import '../../../widget/text/main_text.dart';
import '../../../widget/shadow_box.dart';

class ProblemNotRelevantScreen extends StatefulWidget {
  static const routeName = "/problem-desc";
  final int id;
  final String status;
  ProblemNotRelevantScreen(this.id, this.status);
  @override
  _ProblemNotRelevantScreenState createState() =>
      _ProblemNotRelevantScreenState();
}

class _ProblemNotRelevantScreenState extends State<ProblemNotRelevantScreen> {
  File image1;
  File image2;
  File image3;
  File image4;
  var descController = TextEditingController();
  bool _value = false;
  bool isSending = false;
  int _val = 0;
  Timer _timer;
  void timerCencel() {
    _timer?.cancel();
  }

  void timerStart() {
    _timer = Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      setState(() {
        _val += 1;
      });
      if (_val == 100) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }), (Route<dynamic> route) => false);
      }
    });
  }

  Future insertData() async {
    try {
      if (isSending == false) {
        setState(() {
          isSending = true;
          // _btn_message = "Loading".tr().toString();
        });
        timerStart();
        var url2 = '${globals.api_link}/problems/cancel';

        var req = http.MultipartRequest("POST", Uri.parse(url2));
        req.headers.addAll({"Authorization": "token ${globals.token}"});
        req.fields.addAll({"problem_id": "${widget.id}"});
        req.fields.addAll({"reason": "${descController.text}"});
        // if (globals.images['file1'] != null) {
        //   String _fileName = globals.images['file1'].path;
        //   req.files.add(http.MultipartFile(
        //       "file1",
        //       globals.images['file1'].readAsBytes().asStream(),
        //       globals.images['file1'].lengthSync(),
        //       filename: _fileName.split('/').last));
        // }
        // if (globals.images['file2'] != null) {
        //   String _fileName = globals.images['file2'].path;
        //   req.files.add(http.MultipartFile(
        //       "file2",
        //       globals.images['file2'].readAsBytes().asStream(),
        //       globals.images['file2'].lengthSync(),
        //       filename: _fileName.split('/').last));
        // }
        // if (globals.images['file3'] != null) {
        //   String _fileName = globals.images['file3'].path;
        //   req.files.add(http.MultipartFile(
        //       "file3",
        //       globals.images['file3'].readAsBytes().asStream(),
        //       globals.images['file3'].lengthSync(),
        //       filename: _fileName.split('/').last));
        // }
        // if (globals.images['file4'] != null) {
        //   String _fileName = globals.images['file4'].path;
        //   req.files.add(http.MultipartFile(
        //       "file4",
        //       globals.images['file4'].readAsBytes().asStream(),
        //       globals.images['file4'].lengthSync(),
        //       filename: _fileName.split('/').last));
        // }
        var res = await req.send();

        if (res.statusCode == 200) {
          // globals.images['file1'] = null;
          // globals.images['file2'] = null;
          // globals.images['file3'] = null;
          // globals.images['file4'] = null;
          isSending = false;
          setState(() {
            _val = 98;
          });
        } else {
          isSending = false;
          // _btn_message = "continue".tr().toString();
          _val = 0;
          _timer?.cancel();
          print(res);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void clearImages() {
    setState(() {
      globals.images.addAll({
        "file1": null,
        "file2": null,
        "file3": null,
        "file4": null,
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  FocusNode descNode = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: descNode, toolbarButtons: [
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
    var dWidth = mediaQuery.size.width;

    final size = (mediaQuery.size.width -
                mediaQuery.padding.left -
                mediaQuery.padding.right) /
            4 -
        25;
    print(widget.status);
    return Scaffold(
      appBar: CustomAppBar(
        title: "problem_not_actual".tr().toString(),
        centerTitle: true,
      ),
      body: widget.status == "completed"
          ? Center(
              child: Text(
                widget.status == "completed"
                    ? "to_result".tr().toString()
                    : "not_actual_decision".tr().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: globals.font,
                  fontWeight: FontWeight.w700,
                  fontSize: dWidth * globals.fontSize24,
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: mediaQuery.size.height < 560
                      ? mediaQuery.size.height
                      : mediaQuery.size.height * 0.8,
                  child: KeyboardActions(
                    // isDialog: true,
                    disableScroll: true,
                    config: _buildConfig(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShadowBox(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MainText(
                                          "problem_describe".tr().toString()),
                                      TextareaInput(
                                        descNode: descNode,
                                        hint: "problem_describe_hint"
                                            .tr()
                                            .toString(),
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
                            padding: EdgeInsets.all(15),
                            child: Stack(
                              children: [
                                Positioned(
                                  child: Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: isSending
                                        ? Center(
                                            child: Container(
                                              width: double.infinity,
                                              height: 50.0,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0),
                                              child:
                                                  LiquidLinearProgressIndicator(
                                                value: _val / 100,
                                                backgroundColor:
                                                    Color(0xffB2B7D0),
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Theme.of(context)
                                                            .primaryColor),
                                                borderRadius: 25.0,
                                                center: Text(
                                                  "${_val}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : _value != true
                                            ? DefaultButton(
                                                "send".tr().toString(),
                                                () {},
                                                Color(0xffB2B7D0),
                                              )
                                            : DefaultButton(
                                                "send".tr().toString(), () {
                                                insertData();
                                                // Navigator.of(context).push(MaterialPageRoute(
                                                //     builder: (BuildContext context) {
                                                //   return ProblemLocate(
                                                //       descController.text, widget.id);
                                                // }));
                                              },
                                                Theme.of(context).primaryColor),
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
    );
  }
}
