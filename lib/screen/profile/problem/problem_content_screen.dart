import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/models/problems.dart';
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
  static const routeName = "/problem-content-screen";
  final int id;
  ProblemContentScreen({this.id});
  @override
  _ProblemContentScreenState createState() => _ProblemContentScreenState();
}

class _ProblemContentScreenState extends State<ProblemContentScreen> {
  bool _alert = false;
  String _showTime;
  Timer timers;
  String _status = "processing";
  String _title;
  Map<String, dynamic> _data;
  @override
  void initState() {
    super.initState();
    try {
      timers = Timer.periodic(Duration(seconds: 1), (Timer t) {
        refreshBells();
      });
    } catch (e) {
      print(e);
    }
  }

  FutureOr onGoBack(dynamic value) {
    timers = Timer.periodic(Duration(seconds: 1), (Timer t) {
      refreshBells();
    });
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
    timers?.cancel();
    super.dispose();
  }

  getProblems(id) async {
    // String _type = "processing";
    // switch (widget.status) {
    //   case "warning":
    //     _type = "processing";
    //     break;
    //   case "success":
    //     _type = "confirmed";
    //     break;
    //   case "danger":
    //     _type = "denied";
    //     break;
    // }

    try {
      var reply;
      var url = '${globals.api_link}/problems/problem/$id';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        reply = response.json();
      }
      return reply["problem"];
    } catch (e) {
      print(e);
    }
  }

  void refreshBells() async {
    try {
      String _list = "${_data["id"]}";
      var url =
          '${globals.api_link}/problems/refresh-user-bells?problem_ids=$_list';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var res = response.json();
        if (res['result'].length != 0) {
          for (var i = 0; i < res['result'].length; i++) {
            var problem_id = res['result'][i];
            if (problem_id == _data["id"]) _alert = true;
          }
        } else {
          _alert = false;
        }
      }

      setState(() {});
      // String reply = await response.transform(utf8.decoder).join();

      // var temp = parseProblems(reply);

    } catch (e) {
      print(e);
    }
  }

  List<String> imgList = [];

  generateList(String img) {
    if (img != null) imgList.add("${globals.site_link}$img");
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var dWidth = mediaQuery.size.width;
    return FutureBuilder(
      future: getProblems(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.hasData) {
          _data = snapshot.data;
          if (_data["status"] == "completed" ||
              _data["status"] == "processing" ||
              _data["status"] == "moderating" ||
              _data["status"] == "not confirmed") {
            _status = "warning";
            _title = "unresolved".tr().toString();
          } else if (_data["status"] == "denied" ||
              _data["status"] == "canceled") {
            _status = "danger";
            _title = "take_off_problems".tr().toString();
          } else if (_data["status"] == "confirmed" ||
              _data["status"] == "closed") {
            _status = "success";
            _title = "solved".tr().toString();
          } else if (_data["status"] == "planned") {
            _status = "delayed";
            _title = "delayed_problems".tr().toString();
          }
          // switch (_data["status"]) {
          //   case "warning":
          //     break;
          //   case "success":
          //     _status = "confirmed";
          //     _title = "solved".tr().toString();
          //     break;
          //   case "danger":
          //     _status = "denied";
          //     _title = "take_off_problems".tr().toString();
          //     break;
          // }

          var deadline =
              DateTime.parse(_data["deadline"]).millisecondsSinceEpoch;
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
              "${days}${"d".tr().toString()}  : ${hours}${"h".tr().toString()}"; // : ${minutes}${"m".tr().toString()}";
          generateList(_data["file_1"]);
          generateList(_data["file_2"]);
          generateList(_data["file_3"]);
          generateList(_data["file_4"]);
          generateList(_data["file_5"]);
        }

        return snapshot.hasData
            ? Scaffold(
                appBar: CustomAppBar(
                  title: _title,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 19, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: mediaQuery.size.width * 0.7,
                                          child: Text(
                                            _data["subsubcategory"]
                                                ["api_title".tr().toString()],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: globals.font,
                                              fontSize:
                                                  dWidth * globals.fontSize18,
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
                                                            BorderRadius
                                                                .circular(
                                                                    3.375),
                                                        color:
                                                            Color(0xffFF5555),
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
                                        BoxTextDefault("№${_data["id"]}"),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                        ),
                                        BoxTextWarning(
                                            "${_data["status"]}"
                                                .tr()
                                                .toString(),
                                            _status),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                        ),
                                        BoxTextDefault(_showTime),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 19, vertical: 15),
                                child: Text(
                                  _data["content"],
                                  style: TextStyle(
                                    fontFamily: globals.font,
                                    fontSize: dWidth * globals.fontSize14,
                                  ),
                                ),
                              ),
                              if (_data["file_1"] != null ||
                                  _data["file_2"] != null ||
                                  _data["file_3"] != null ||
                                  _data["file_4"] != null ||
                                  _data["file_5"] != null)
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
                                                  width: mediaQuery.size.width *
                                                      0.23,
                                                  height: 90,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: _data["file_1"] !=
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return FullScreen(
                                                                          imgList);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    "${globals.site_link}/${_data["file_1"]}",
                                                              ),
                                                              // Image.network(
                                                              //     "),
                                                            )
                                                          : Container(),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: mediaQuery
                                                              .size.width *
                                                          0.024),
                                                  width: mediaQuery.size.width *
                                                      0.23,
                                                  height: 90,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: _data["file_2"] !=
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return FullScreen(
                                                                          imgList);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child: CachedNetworkImage(
                                                                  imageUrl:
                                                                      "${globals.site_link}/${_data["file_2"]}"),
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
                                                      top: mediaQuery
                                                              .size.width *
                                                          0.024),
                                                  width: mediaQuery.size.width *
                                                      0.23,
                                                  height: 90,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: _data["file_3"] !=
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return FullScreen(
                                                                          imgList);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child: CachedNetworkImage(
                                                                  imageUrl:
                                                                      "${globals.site_link}/${_data["file_3"]}"),
                                                            )
                                                          : Container(),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: mediaQuery
                                                              .size.width *
                                                          0.024,
                                                      top: mediaQuery
                                                              .size.width *
                                                          0.024),
                                                  width: mediaQuery.size.width *
                                                      0.23,
                                                  height: 90,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: _data["file_4"] !=
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return FullScreen(
                                                                          imgList);
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              child: CachedNetworkImage(
                                                                  imageUrl:
                                                                      "${globals.site_link}/${_data["file_4"]}"),
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
                                            left:
                                                mediaQuery.size.width * 0.024),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width: mediaQuery.size.width * 0.365,
                                        height: 190,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: _data["file_5"] != null
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
                                                                imgList);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${globals.site_link}/${_data["file_5"]}"))
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
                              CustomCardList(
                                "subcat2",
                                "status".tr().toString(),
                                ProblemStatusScreen(_data["id"]),
                                true,
                              ),
                              CustomCardList(
                                "subcat2",
                                "messages".tr().toString(),
                                MainChat(_data["id"], _data["status"]),
                                true,
                              ),
                              (_data["status"] == "confirmed" ||
                                      _data["status"] == "denied" ||
                                      _data["status"] == "closed")
                                  ? Container()
                                  : Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width: (mediaQuery
                                                                  .size.width -
                                                              mediaQuery.padding
                                                                  .left -
                                                              mediaQuery.padding
                                                                  .right) *
                                                          0.82,
                                                      child: Container(
                                                          child: RichText(
                                                        text: TextSpan(
                                                          text:
                                                              "problem_not_actual"
                                                                  .tr()
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                globals.font,
                                                            color: Color(
                                                                0xff050505),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: mediaQuery
                                                                    .size
                                                                    .width *
                                                                globals
                                                                    .fontSize18,
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
                                              timers.cancel();
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return ProblemNotRelevantScreen(
                                                        _data["id"],
                                                        _data['status']);
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
                                  status: _status,
                                  id: _data["id"],
                                ),
                                false,
                              ),
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
              )
            : Scaffold(
                body: Center(
                  child: Text("Loading".tr().toString()),
                ),
              );
      },
    );
  }
}
