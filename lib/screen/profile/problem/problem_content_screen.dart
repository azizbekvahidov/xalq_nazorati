import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/chat/main_chat.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_not_relevant_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_status_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/solve_problem_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/custom_card_list.dart';
import 'package:xalq_nazorati/widget/full_screen.dart';
import 'package:xalq_nazorati/widget/problems/box_text_default.dart';
import 'package:xalq_nazorati/widget/problems/box_text_warning.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemContentScreen extends StatefulWidget {
  final String status;
  final String title;
  final Map<String, dynamic> data;

  ProblemContentScreen(this.title, this.status, this.data);
  @override
  _ProblemContentScreenState createState() => _ProblemContentScreenState();
}

class _ProblemContentScreenState extends State<ProblemContentScreen> {
  bool _alert = false;
  String _showTime;
  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      refreshBells();
    });
  }

  FutureOr onGoBack(dynamic value) {
    clearImages();
  }

  void clearImages() {
    globals.images.addAll({
      "file1": null,
      "file2": null,
      "file3": null,
      "file4": null,
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void refreshBells() async {
    try {
      _alert = false;
      String _list = "${widget.data["id"]}";
      var url =
          '${globals.api_link}/problems/refresh-user-bells?problem_ids=$_list';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var res = response.json();
        if (res['result'].length != 0) {
          for (var i = 0; i < res['result'].length; i++) {
            var problem_id = res['result'][i];
            if (problem_id == widget.data["id"]) _alert = true;
          }
        }
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
        "${days}${"d".tr().toString()}  : ${hours}${"h".tr().toString()} : ${minutes}${"m".tr().toString()}";
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              ShadowBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: mediaQuery.size.width * 0.7,
                                child: Text(
                                  widget.data["subsubcategory"]
                                      ["api_title".tr().toString()],
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
                                              borderRadius:
                                                  BorderRadius.circular(3.375),
                                              color: Color(0xffFF5555),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      child: SvgPicture.asset(
                                          "assets/img/bell.svg"),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Row(
                            children: [
                              BoxTextWarning(
                                  "${widget.data["status"]}".tr().toString(),
                                  widget.status),
                              BoxTextDefault(_showTime),
                              BoxTextDefault("№${widget.data["id"]}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                      child: Text(
                        widget.data["content"],
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (widget.data["file_1"] != null ||
                        widget.data["file_2"] != null ||
                        widget.data["file_3"] != null ||
                        widget.data["file_4"] != null ||
                        widget.data["file_5"] != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 19),
                        child: Row(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(),
                                        width: mediaQuery.size.width * 0.24,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: widget.data["file_1"] != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return FullScreen(
                                                                widget.data[
                                                                    "file_1"]);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data["file_1"]),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left:
                                                mediaQuery.size.width * 0.0266),
                                        width: mediaQuery.size.width * 0.24,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: widget.data["file_2"] != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return FullScreen(
                                                                widget.data[
                                                                    "file_2"]);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data["file_2"]),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top:
                                                mediaQuery.size.width * 0.0266),
                                        width: mediaQuery.size.width * 0.24,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: widget.data["file_3"] != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return FullScreen(
                                                                widget.data[
                                                                    "file_3"]);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data["file_3"]),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left:
                                                mediaQuery.size.width * 0.0266,
                                            top:
                                                mediaQuery.size.width * 0.0266),
                                        width: mediaQuery.size.width * 0.24,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: widget.data["file_4"] != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return FullScreen(
                                                                widget.data[
                                                                    "file_4"]);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data["file_4"]),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: mediaQuery.size.width * 0.0266),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: mediaQuery.size.width * 0.365,
                              height: 190,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: widget.data["file_5"] != null
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return FullScreen(
                                                      widget.data["file_5"]);
                                                },
                                              ),
                                            );
                                          },
                                          child: Image.network(
                                              widget.data["file_5"]))
                                      : Container(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    )
                  ],
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
                    CustomCardList("subcat2", "status".tr().toString(),
                        ProblemStatusScreen(widget.data["id"]), true),
                    CustomCardList("subcat2", "messages".tr().toString(),
                        MainChat(widget.data["id"]), true),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: (mediaQuery.size.width -
                                              mediaQuery.padding.left -
                                              mediaQuery.padding.right) *
                                          0.84,
                                      child: Container(
                                          child: RichText(
                                        text: TextSpan(
                                          text: "problem_not_actual"
                                              .tr()
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            color: Color(0xff050505),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ))),
                                  Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ProblemNotRelevantScreen(
                                        widget.data["id"]);
                                  },
                                ),
                              ).then(onGoBack);
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    CustomCardList(
                        "subcat2",
                        "problem_solved".tr().toString(),
                        SolveProblemScreen(
                          status: widget.status,
                          id: widget.data["id"],
                        ),
                        false),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
