import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/widget/problems/box_text_default.dart';
import 'package:xalq_nazorati/widget/problems/box_text_warning.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemCard extends StatefulWidget {
  bool alert = false;
  final String status;
  final String title;
  final Map<String, dynamic> data;
  ProblemCard({
    this.alert,
    this.status,
    this.title,
    this.data,
  });

  @override
  _ProblemCardState createState() => _ProblemCardState();
}

class _ProblemCardState extends State<ProblemCard> {
  FutureOr onGoBack(dynamic value) {
    // widget.timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
    //   widget.refreshBells();
    // });
  }

  String _showTime;

  @override
  Widget build(BuildContext context) {
    var deadline =
        DateTime.parse(widget.data["deadline"]).millisecondsSinceEpoch;
    int days = DateTime.fromMillisecondsSinceEpoch(deadline)
        .difference(DateTime.now())
        .inDays;
    if (days >= 0) deadline -= (86400 * days) * 1000;
    int hours = DateTime.fromMillisecondsSinceEpoch(deadline)
        .difference(DateTime.now())
        .inHours;
    if (hours >= 0) deadline -= (hours * 3600) * 1000;
    int minutes = DateTime.fromMillisecondsSinceEpoch(deadline)
        .difference(DateTime.now())
        .inMinutes;
    _showTime =
        "${days}${"d".tr().toString()} : ${hours}${"h".tr().toString()} : ${minutes}${"m".tr().toString()}";
    bool _alert = widget.alert == null ? false : widget.alert;
    var mediaQuery = MediaQuery.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              var route;
              route = ProblemContentScreen(id: widget.data["id"]);
              return route;
            },
          ),
        ).then((value) => onGoBack(value));
      },
      child: ShadowBox(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 19, vertical: 15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: mediaQuery.size.width * 0.7,
                    child: Text(
                      widget.data["subsubcategory"]
                              ["api_title".tr().toString()] ??
                          "",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: globals.font,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _alert
                      ? Stack(
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                "assets/img/bell.svg",
                                color: Colors.black,
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 0,
                              child: Container(
                                width: 6.75,
                                height: 6.75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.375),
                                  color: Color(0xffFF5555),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          child: SvgPicture.asset("assets/img/bell.svg"),
                        ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: [
                  BoxTextWarning("${widget.data["status"]}".tr().toString(),
                      widget.status),
                  BoxTextDefault("${_showTime}"),
                  BoxTextDefault("№${widget.data["id"]}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
