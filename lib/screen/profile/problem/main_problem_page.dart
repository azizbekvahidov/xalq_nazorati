import 'dart:async';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/custom_card_list.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class MainProblemPage extends StatefulWidget {
  MainProblemPage({Key key}) : super(key: key);

  @override
  _MainProblemPageState createState() => _MainProblemPageState();
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
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/notifications-by-state';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var res = response.json();
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
    return Scaffold(
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
                    ProblemScreen(
                        title: "unresolved".tr().toString(), status: "warning"),
                    true,
                    "$isProcessing",
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
                    true,
                    "$isDenied",
                    isDenied != 0 ? true : false,
                  ),
                  CustomCardList(
                    "subcat4",
                    "delayed_problems".tr().toString(),
                    ProblemScreen(
                        title: "delayed_problems".tr().toString(),
                        status: "delayed"),
                    false,
                    "$isPlanned",
                    isPlanned != 0 ? true : false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
