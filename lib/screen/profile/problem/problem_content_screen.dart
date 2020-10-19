import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/models/problems.dart';
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
  final Problems data;

  ProblemContentScreen(this.title, this.status, this.data);
  @override
  _ProblemContentScreenState createState() => _ProblemContentScreenState();
}

class _ProblemContentScreenState extends State<ProblemContentScreen> {
  bool _alert = true;
  String _showTime;
  @override
  Widget build(BuildContext context) {
    var deadline = DateTime.parse(widget.data.deadline).millisecondsSinceEpoch;
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
    _showTime = "${days}д : ${hours}ч : ${minutes}м";
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
                                  widget.data.subsubcategory["title_ru"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Gilroy",
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
                              BoxTextWarning(widget.data.status.tr().toString(),
                                  widget.status),
                              BoxTextDefault(_showTime),
                              BoxTextDefault("№${widget.data.id}"),
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
                        widget.data.content,
                        style: TextStyle(
                          fontFamily: "Gilroy",
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (widget.data.file_1 != null ||
                        widget.data.file_2 != null ||
                        widget.data.file_3 != null ||
                        widget.data.file_4 != null ||
                        widget.data.file_5 != null)
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
                                            child: widget.data.file_1 != null
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
                                                                widget.data
                                                                    .file_1);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data.file_1),
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
                                            child: widget.data.file_2 != null
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
                                                                widget.data
                                                                    .file_2);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data.file_2),
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
                                            child: widget.data.file_3 != null
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
                                                                widget.data
                                                                    .file_3);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data.file_3),
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
                                            child: widget.data.file_4 != null
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
                                                                widget.data
                                                                    .file_4);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Image.network(
                                                        widget.data.file_4),
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
                                  child: widget.data.file_5 != null
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return FullScreen(
                                                      widget.data.file_5);
                                                },
                                              ),
                                            );
                                          },
                                          child:
                                              Image.network(widget.data.file_5))
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
                    CustomCardList("subcat2", "Статус",
                        ProblemStatusScreen(widget.data.id), true),
                    CustomCardList(
                        "subcat2", "Сообщение", MainChat(widget.data.id), true),
                    CustomCardList("subcat2", "Проблема не актуально",
                        ProblemNotRelevantScreen(widget.data.id), true),
                    CustomCardList("subcat2", "Проблема решена",
                        SolveProblemScreen(status: false), false),
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
