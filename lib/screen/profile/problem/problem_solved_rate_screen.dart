import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:requests/requests.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/profile/main_profile.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/input/textarea_input.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemSolvedRateScreen extends StatefulWidget {
  final int id;
  final String executorName;
  final String executorAvatar;
  final int executorId;
  final String position;
  final String choose;
  ProblemSolvedRateScreen(this.id, this.executorName, this.executorAvatar,
      this.executorId, this.position, this.choose);
  @override
  _ProblemSolvedRateScreenState createState() =>
      _ProblemSolvedRateScreenState();
}

class _ProblemSolvedRateScreenState extends State<ProblemSolvedRateScreen> {
  var descController = TextEditingController();
  var rating = 0.0;
  var rated = 0;
  var dataSended = false;
  bool _value = false;

  Future sendData() async {
    String desc = descController.text;
    if (widget.choose != "deny") {
      if (desc != "" && rated != 0) {
        var url = '${globals.api_link}/problems/confirm';
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}"
        };
        Map<String, dynamic> data = {
          "problem_id": widget.id,
          "executor_id": widget.executorId,
          "message": "$desc",
          "rating": rated,
        };
        var response = await Requests.post(url, body: data, headers: headers);

        // String reply = await response.transform(utf8.decoder).join();
        // var temp = response.json();
        if (response.statusCode == 200) {
          setState(() {
            dataSended = true;
          });
          Timer(Duration(seconds: 3), () {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                HomePage.routeName, (Route<dynamic> route) => false);
          });
        }
      }
    } else {
      if (desc != "") {
        var url = '${globals.api_link}/problems/deny';
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}"
        };
        Map<String, dynamic> data = {
          "problem_id": widget.id,
          "executor_id": widget.executorId,
          "message": "$desc",
        };
        var response = await Requests.post(url, body: data, headers: headers);

        // String reply = await response.transform(utf8.decoder).join();
        // var temp = response.json();
        if (response.statusCode == 200) {
          print("sended");
          var res = response.json(); //parseProblems(response.content());

          setState(() {
            dataSended = true;
          });
          Timer(Duration(seconds: 3), () {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                HomePage.routeName, (Route<dynamic> route) => false);
          });
        }
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "problem_solved".tr().toString(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ShadowBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 15),
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: widget.executorAvatar != null
                        ? Image.asset("assets/img/newsPic.jpg")
                        : Container(
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
              Text(
                widget.executorName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: globals.font,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7),
              ),
              Text(
                widget.position,
                style: TextStyle(
                  fontFamily: globals.font,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              !dataSended
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "rate_executor".tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 18),
                        ),
                        (widget.choose == "accept")
                            ? SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                  setState(() {
                                    rated = v.toInt();
                                    print(rated);
                                  });
                                },
                                starCount: 5,
                                rating: rating,
                                size: 40.0,
                                color: Theme.of(context).primaryColor,
                                borderColor: Color(0xffEBEDF3),
                                spacing: 0.0,
                              )
                            : Container(),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 19),
                            child: TextareaInput(
                              hint: "",
                              textareaController: descController,
                              notifyParent: checkChange,
                            )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 19),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              color: globals.activeButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(34),
                              ),
                              onPressed: () {
                                sendData();
                              },
                              child: Text(
                                "accept".tr().toString(),
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "thanks".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
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
