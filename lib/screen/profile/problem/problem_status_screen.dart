import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/problems/problem_status-card.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemStatusScreen extends StatefulWidget {
  @override
  _ProblemStatusScreenState createState() => _ProblemStatusScreenState();
}

class _ProblemStatusScreenState extends State<ProblemStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Статус проблемы",
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(top: 25, left: 19),
                child: Text(
                  "Статус проблемы",
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                )),
            ShadowBox(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      ProblemStatusCard(),
                      ProblemStatusCard(),
                      ProblemStatusCard(),
                      ProblemStatusCard(),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
