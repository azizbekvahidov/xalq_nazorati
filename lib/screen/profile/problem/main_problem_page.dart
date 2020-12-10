import 'package:flutter/material.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/custom_card_list.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';
import 'package:easy_localization/easy_localization.dart';

class MainProblemPage extends StatefulWidget {
  MainProblemPage({Key key}) : super(key: key);

  @override
  _MainProblemPageState createState() => _MainProblemPageState();
}

class _MainProblemPageState extends State<MainProblemPage> {
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
                          title: "unresolved".tr().toString(),
                          status: "warning"),
                      true),
                  CustomCardList(
                    "subcat2",
                    "solved".tr().toString(),
                    ProblemScreen(
                        title: "solved".tr().toString(), status: "success"),
                    true,
                  ),
                  CustomCardList(
                    "subcat3",
                    "take_off_problems".tr().toString(),
                    ProblemScreen(
                        title: "take_off_problems".tr().toString(),
                        status: "danger"),
                    true,
                  ),
                  CustomCardList(
                    "subcat4",
                    "delayed_problems".tr().toString(),
                    ProblemScreen(
                        title: "delayed_problems".tr().toString(),
                        status: "delayed"),
                    false,
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
