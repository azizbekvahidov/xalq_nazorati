import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_screen_custom.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/custom_card_list.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

_MainProblemPageState mainProblemState;

class MainProblemPage extends StatefulWidget {
  MainProblemPage({Key key}) : super(key: key);

  @override
  _MainProblemPageState createState() {
    mainProblemState = _MainProblemPageState();
    return mainProblemState;
  }
}

class _MainProblemPageState extends State<MainProblemPage> {
  int isProcessing = 0;
  int isDenied = 0;
  int isConfirmed = 0;
  int isPlanned = 0;
  Timer timer;
  @override
  void initState() {
    super.initState();
    // globals.connectTimer?.cancel();
    refreshBells();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      refreshBells();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void refreshBells() async {
    try {
      var connect = new DioConnection();
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await connect.getHttp(
          '/problems/notifications-by-state', mainProblemState, headers);
      if (response["statusCode"] == 200) {
        var res = response["result"];
        isConfirmed = res["confirmed"];
        isDenied = res["denied"];
        isProcessing = res["processing"];
        isPlanned = res["planned"];
      }
      setState(() {});
      // String reply = await response.transform(utf8.decoder).join();

      // var temp = parseProblems(reply);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: 'problems'.tr().toString(),
            centerTitle: true,
          ),
          body: Container(
            child: Column(
              children: [
                ShadowBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCardList(
                        "subcat1",
                        "unresolved".tr().toString(),
                        ProblemScreenCustom(
                            title: "unresolved".tr().toString(),
                            status: "warning"),
                        true,
                        "${isProcessing + isPlanned}",
                        isProcessing != 0 ? true : false,
                      ),
                      CustomCardList(
                        "subcat2",
                        "solved".tr().toString(),
                        ProblemScreen(
                            title: "solved".tr().toString(), status: "success"),
                        true,
                        "$isConfirmed",
                        isConfirmed != 0 ? true : false,
                      ),
                      CustomCardList(
                        "subcat3",
                        "take_off_problems".tr().toString(),
                        ProblemScreen(
                            title: "take_off_problems".tr().toString(),
                            status: "danger"),
                        false,
                        "$isDenied",
                        isDenied != 0 ? true : false,
                      ),
                      // CustomCardList(
                      //   "subcat4",
                      //   "delayed_problems".tr().toString(),
                      //   ProblemScreen(
                      //       title: "delayed_problems".tr().toString(),
                      //       status: "delayed"),
                      //   false,
                      //   "$isPlanned",
                      //   isPlanned != 0 ? true : false,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        CheckConnection(),
      ],
    );
  }
}
