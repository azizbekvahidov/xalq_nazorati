import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/profile/main_profile.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/input/textarea_input.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';

class ProblemSolvedDeclineScreen extends StatefulWidget {
  final int id;
  final String executorName;
  final String executorAvatar;
  final int executorId;
  final String position;
  ProblemSolvedDeclineScreen(this.id, this.executorName, this.executorAvatar,
      this.executorId, this.position);
  @override
  _ProblemSolvedDeclineScreenState createState() =>
      _ProblemSolvedDeclineScreenState();
}

class _ProblemSolvedDeclineScreenState
    extends State<ProblemSolvedDeclineScreen> {
  var descController = TextEditingController();
  var rating = 0.0;
  var rated = 0;
  var dataSended = false;
  bool _value = false;

  Future sendData() async {
    String desc = descController.text;

    if (desc != "") {
      try {
        var url = '${globals.api_link}/problems/deny';
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}"
        };
        Map<String, dynamic> data = {
          "problem_id": widget.id,
          "reason": "$desc",
        };
        var response = await Requests.post(url, body: data, headers: headers);
        print("sended");
        // String reply = await response.transform(utf8.decoder).join();
        // var temp = response.json();
        if (response.statusCode == 201) {
          print("sended2");
          // var res = response.json(); //parseProblems(response.content());

          setState(() {
            dataSended = true;
          });
          Timer(Duration(seconds: 1), () {
            Navigator.of(
              context,
            ).pop();
            // .pushNamedAndRemoveUntil(
            //     HomePage.routeName, (Route<dynamic> route) => false);
          });
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15.0);
      }
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
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: "decline_result".tr().toString(),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: !dataSended
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: dHeight < 560 ? dHeight : dHeight * 0.8,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MainText(
                                        "problem_describe".tr().toString()),
                                    TextareaInput(
                                      hint: "problem_describe_hint"
                                          .tr()
                                          .toString(),
                                      textareaController: descController,
                                      notifyParent: checkChange,
                                      maxCnt: 100,
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
                                  child:
                                      /*!_value
                                ? DefaultButton(
                                    "Продолжить",
                                    () {},
                                    Color(0xffB2B7D0),
                                  )
                                : */
                                      Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 19),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: _value
                                          ? FlatButton(
                                              color: globals.activeButtonColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(34),
                                              ),
                                              onPressed: () {
                                                sendData();
                                              },
                                              child: Text(
                                                "send".tr().toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button
                                                    .copyWith(
                                                        fontSize: dWidth *
                                                            globals.fontSize18),
                                              ),
                                            )
                                          : FlatButton(
                                              onPressed: () {},
                                              color:
                                                  globals.deactiveButtonColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(34),
                                              ),
                                              child: Text(
                                                "send".tr().toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button
                                                    .copyWith(
                                                        fontSize: dWidth *
                                                            globals.fontSize18),
                                              ),
                                            ),
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
              )
            // SingleChildScrollView(
            //   child: ShadowBox(
            //     child: Container(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Container(
            //                   padding: EdgeInsets.symmetric(horizontal: 19),
            //                   child: MainText(
            //                       "${"problem_describe".tr().toString()}*")),
            //               Container(
            //                   padding: EdgeInsets.only(
            //                       left: 19, right: 19, bottom: 20),
            //                   child: TextareaInput(
            //                     hint: "problem_describe_hint".tr().toString(),
            //                     textareaController: descController,
            //                     notifyParent: checkChange,
            //                     maxCnt: 100,
            //                   )),

            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // )
            : Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "your_message_sended".tr().toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: globals.font,
                      fontWeight: FontWeight.w700,
                      fontSize: dWidth * globals.fontSize22,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
