import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

_ProblemContentScreenState cardContentState;

class ProblemContentScreen extends StatefulWidget {
  static const routeName = "/problem-content-screen";
  final int id;
  ProblemContentScreen({this.id});
  @override
  _ProblemContentScreenState createState() {
    cardContentState = _ProblemContentScreenState();
    return cardContentState;
  }
}

class _ProblemContentScreenState extends State<ProblemContentScreen> {
  bool _alert = false;
  String _showTime;
  Timer timers;
  String _status = "processing";
  String _title;
  int _chat_messages = 0;
  int _event_messages = 0;
  bool _is_result = false;
  bool _hasResult = false;
  Map<int, dynamic> _problems;
  Map<String, dynamic> _data;
  Future<Map<String, dynamic>> _problem;
  Map<dynamic, dynamic> alertData;
  var problemStatus;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    _problems = {
      widget.id: {
        "notify": false,
        "chat_cnt": 0,
        "event_cnt": 0,
        "res": null,
        "res_seen": false,
        "status": ""
      }
    };
    _problem = getProblems(widget.id);
    globals.routeProblemId = null;
    if (globals.cardAlert.isEmpty ?? null) {
      refreshBells();
      timers = Timer.periodic(Duration(seconds: 5), (Timer t) {
        refreshBells();
      });
    } else {
      if (globals.cardAlert[widget.id] == null) {
        refreshBells();
        timers = Timer.periodic(Duration(seconds: 5), (Timer t) {
          refreshBells();
        });
      } else {
        timers?.cancel();
        alertData = globals.cardAlert[widget.id];

        _hasResult = alertData['res'] == null ? false : true;
        problemStatus = alertData["status"];
      }
    }
  }

  customDialog(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "result_notify".tr().toString(),
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: dWidth * globals.fontSize16,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
              );
            },
          );
        });
  }

  void _onRefresh() async {
    _problem = getProblems(widget.id);

    setState(() {});
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void refreshBells() async {
    try {
      String _list = "${widget.id}";

      var url =
          '${globals.api_link}/problems/refresh-problem?problem_ids=$_list';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var res = response.json();

        if (res.length != 0) {
          for (var i = 0; i < res.length; i++) {
            bool _notify = false;
            var problem_id = res[i]['problem_id'];
            _problems[problem_id]["chat_cnt"] = res[i]['new_messages_count'];
            _problems[problem_id]["event_cnt"] = res[i]['new_events_count'];
            _problems[problem_id]["res"] = res[i]['result'];
            _problems[problem_id]["status"] = res[i]['status'];
            if (res[i]['new_messages_count'] != 0) _notify = true;
            if (res[i]['new_events_count'] != 0) _notify = true;
            if (res[i]['result'] != null) {
              _problems[problem_id]["res_seen"] = res[i]['result']["seen"];
              if (res[i]['result']["seen"] == false) _notify = true;
            }
            if (_notify != _problems[problem_id]["notify"]) {
              setState(() {
                _problems[problem_id]["notify"] = _notify;
              });
              // cardContentState.setState(() {
              //   globals.cardAlert[problem_id] = _problems[problem_id];
              // });
            }
            setState(() {
              _hasResult = _problems[problem_id]['res'] == null ? false : true;
              alertData = _problems[problem_id];
              problemStatus = _problems[problem_id]['status'];
            });
          }
        }
      }
      // String reply = await response.transform(utf8.decoder).join();

      // var temp = parseProblems(reply);

    } catch (e) {
      print(e);
    }
  }

  // FutureOr onGoBack(dynamic value) {
  //   timers = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
  //     refreshBells();
  //   });
  //   clearImages();
  // }

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
    globals.cardAlert = {};
    super.dispose();
  }

  Future<Map<String, dynamic>> getProblems(id) async {
    try {
      var reply;
      var url = '${globals.api_link}/problems/problem/$id';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        reply = response.json();
        _data = reply;
        problemStatus = reply['problem']['status'];
        return reply["problem"];
      }
    } catch (e) {
      print(e);
    }
  }

  List<String> imgList = [];

  generateList(String img) {
    if (img != null) imgList.add("${globals.site_link}$img");
  }

  DateFormat dateF = DateFormat('dd.MM.yyyy HH.mm');
  @override
  Widget build(BuildContext context) {
    int hours;
    var mediaQuery = MediaQuery.of(context);
    var dWidth = mediaQuery.size.width;
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropMaterialHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: FutureBuilder(
        future: _problem,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            _data = snapshot.data;
            if (problemStatus != "processing") {
              _hasResult = true;
            }
            if (problemStatus == "not confirmed") {
              _status = "warning";
              _title = "unresolved".tr().toString();
            } else if (problemStatus == "completed" ||
                problemStatus == "processing" ||
                problemStatus == "moderating") {
              _status = "info";
              _title = "unresolved".tr().toString();
            } else if (problemStatus == "denied" || problemStatus == "closed") {
              _status = "danger";
              _title = "take_off_problems".tr().toString();
            } else if (problemStatus == "confirmed" ||
                problemStatus == "canceled") {
              _status = "success";
              _title = "solved".tr().toString();
            } else if (problemStatus == "planned") {
              _status = "delayed";
              _title = "delayed_problems".tr().toString();
            }

            var deadline =
                DateTime.parse(_data["deadline"]).millisecondsSinceEpoch;
            int days = DateTime.fromMillisecondsSinceEpoch(deadline)
                .difference(DateTime.now())
                .inDays;
            if (days >= 0) deadline -= (86400 * days) * 1000;
            hours = DateTime.fromMillisecondsSinceEpoch(deadline)
                .difference(DateTime.now())
                .inHours;
            if (hours >= 0) deadline -= (hours * 3600) * 1000;
            int minutes = DateTime.fromMillisecondsSinceEpoch(deadline)
                .difference(DateTime.now())
                .inMinutes;
            if (hours < 0)
              _showTime = "expired".tr().toString();
            else
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          alertData['notify']
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
                                                        decoration:
                                                            BoxDecoration(
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
                                              "${problemStatus}"
                                                  .tr()
                                                  .toString(),
                                              _status),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                          ),
                                          problemStatus == "not confirmed" ||
                                                  problemStatus == "processing"
                                              ? hours >= 0
                                                  ? BoxTextDefault(
                                                      "${"before_timer".tr().toString()}$_showTime${"after_timer".tr().toString()}")
                                                  : BoxTextDefault("$_showTime")
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 19),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${'send_data'.tr().toString()}: ",
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWidth * globals.fontSize12,
                                          fontWeight: FontWeight.bold,
                                          fontFeatures: [
                                            FontFeature.enable("pnum"),
                                            FontFeature.enable("lnum")
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(_data["created_at"]).toString()))}",
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWidth * globals.fontSize12,
                                          fontWeight: FontWeight.w400,
                                          fontFeatures: [
                                            FontFeature.enable("pnum"),
                                            FontFeature.enable("lnum")
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: dWidth * 0.9,
                                    padding: EdgeInsets.only(
                                        left: 19, right: 19, top: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${'address'.tr().toString()}: ",
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize:
                                                dWidth * globals.fontSize12,
                                            fontWeight: FontWeight.bold,
                                            fontFeatures: [
                                              FontFeature.enable("pnum"),
                                              FontFeature.enable("lnum")
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${_data["address"].replaceAll(new RegExp(r"\s+"), " ")}",
                                            style: TextStyle(
                                              fontFamily: globals.font,
                                              fontSize:
                                                  dWidth * globals.fontSize12,
                                              fontWeight: FontWeight.w400,
                                              fontFeatures: [
                                                FontFeature.enable("pnum"),
                                                FontFeature.enable("lnum")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 19),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  _data["file_1"] == null
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(),
                                                          width: mediaQuery
                                                                  .size.width *
                                                              0.20,
                                                          height: 70,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: _data[
                                                                          "file_1"] !=
                                                                      null
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context,
                                                                                rootNavigator: true)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return FullScreen(imgList);
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            "${globals.site_link}${_data["file_1"]}",
                                                                      ),
                                                                      // Image.network(
                                                                      //     "),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          ),
                                                        ),
                                                  _data["file_2"] == null
                                                      ? Container()
                                                      : Container(
                                                          margin: EdgeInsets.only(
                                                              left: mediaQuery
                                                                      .size
                                                                      .width *
                                                                  0.024),
                                                          width: mediaQuery
                                                                  .size.width *
                                                              0.20,
                                                          height: 70,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: _data[
                                                                          "file_2"] !=
                                                                      null
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context,
                                                                                rootNavigator: true)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return FullScreen(imgList);
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: CachedNetworkImage(
                                                                          imageUrl:
                                                                              "${globals.site_link}${_data["file_2"]}"),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          ),
                                                        ),
                                                  _data["file_3"] == null
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.024,
                                                          ),
                                                          width: mediaQuery
                                                                  .size.width *
                                                              0.20,
                                                          height: 70,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: _data[
                                                                          "file_3"] !=
                                                                      null
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context,
                                                                                rootNavigator: true)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return FullScreen(imgList);
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: CachedNetworkImage(
                                                                          imageUrl:
                                                                              "${globals.site_link}${_data["file_3"]}"),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          ),
                                                        ),
                                                  _data["file_4"] == null
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.024,
                                                          ),
                                                          width: mediaQuery
                                                                  .size.width *
                                                              0.20,
                                                          height: 70,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: _data[
                                                                          "file_4"] !=
                                                                      null
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context,
                                                                                rootNavigator: true)
                                                                            .push(
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return FullScreen(imgList);
                                                                            },
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: CachedNetworkImage(
                                                                          imageUrl:
                                                                              "${globals.site_link}${_data["file_4"]}"),
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
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffD5D8E5), width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(
                                      4, 6), // changes position of shadow
                                ),
                              ],
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                CustomCardList(
                                  "subcat2",
                                  "status".tr().toString(),
                                  ProblemStatusScreen(_data["id"]),
                                  true,
                                  "${alertData['event_cnt']}",
                                  alertData['event_cnt'] != 0 ? true : false,
                                ),
                                CustomCardList(
                                  "subcat2",
                                  "messages".tr().toString(),
                                  MainChat(_data["id"], problemStatus),
                                  (problemStatus == "confirmed" ||
                                          problemStatus == "denied" ||
                                          problemStatus == "closed" ||
                                          problemStatus == "planned" ||
                                          problemStatus == "canceled")
                                      ? false
                                      : true,
                                  "${alertData['chat_cnt']}",
                                  alertData['chat_cnt'] != 0 ? true : false,
                                ),
                                (problemStatus == "confirmed" ||
                                        problemStatus == "denied" ||
                                        problemStatus == "closed" ||
                                        problemStatus == "planned" ||
                                        problemStatus == "canceled")
                                    ? Container()
                                    : Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width:
                                                            (mediaQuery.size
                                                                        .width -
                                                                    mediaQuery
                                                                        .padding
                                                                        .left -
                                                                    mediaQuery
                                                                        .padding
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
                                                                  FontWeight
                                                                      .w600,
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
                                                timers?.cancel();
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
                                                );
                                              },
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10))
                                          ],
                                        ),
                                      ),
                                _hasResult
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xff50E3C6),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width:
                                                            (mediaQuery.size
                                                                        .width -
                                                                    mediaQuery
                                                                        .padding
                                                                        .left -
                                                                    mediaQuery
                                                                        .padding
                                                                        .right) *
                                                                0.82,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                child: RichText(
                                                              text: TextSpan(
                                                                text: "result"
                                                                    .tr()
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      globals
                                                                          .font,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: mediaQuery
                                                                          .size
                                                                          .width *
                                                                      globals
                                                                          .fontSize18,
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              child: !alertData[
                                                                      "res_seen"]
                                                                  ? Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          color:
                                                                              Colors.red),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      // padding: EdgeInsets.symmetric(
                                                                      //     vertical: 2, horizontal: 7),
                                                                      child:
                                                                          Text(
                                                                        "1",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontFamily:
                                                                              globals.font,
                                                                          fontSize:
                                                                              mediaQuery.size.width * globals.fontSize10,
                                                                          fontFeatures: [
                                                                            FontFeature.enable("pnum"),
                                                                            FontFeature.enable("lnum")
                                                                          ],
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          ],
                                                        )),
                                                    Container(
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                if (globals.token != null) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return SolveProblemScreen(
                                                          status: _status,
                                                          id: _data["id"],
                                                          stat: problemStatus,
                                                        );
                                                      },
                                                    ),
                                                  ).then((value) {
                                                    setState(() {});
                                                  });
                                                } else {}
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Divider(
                                                  height: 0,
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width:
                                                            (mediaQuery.size
                                                                        .width -
                                                                    mediaQuery
                                                                        .padding
                                                                        .left -
                                                                    mediaQuery
                                                                        .padding
                                                                        .right) *
                                                                0.82,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                child: RichText(
                                                              text: TextSpan(
                                                                text: "result"
                                                                    .tr()
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      globals
                                                                          .font,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          28,
                                                                          24,
                                                                          24,
                                                                          0.4),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: mediaQuery
                                                                          .size
                                                                          .width *
                                                                      globals
                                                                          .fontSize18,
                                                                ),
                                                              ),
                                                            )),
                                                            Container(
                                                              child: !alertData[
                                                                      "res_seen"]
                                                                  ? Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          color:
                                                                              Colors.red),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      // padding: EdgeInsets.symmetric(
                                                                      //     vertical: 2, horizontal: 7),
                                                                      child:
                                                                          Text(
                                                                        "1",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontFamily:
                                                                              globals.font,
                                                                          fontSize:
                                                                              mediaQuery.size.width * globals.fontSize10,
                                                                          fontFeatures: [
                                                                            FontFeature.enable("pnum"),
                                                                            FontFeature.enable("lnum")
                                                                          ],
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ),
                                                          ],
                                                        )),
                                                    Container(
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                customDialog(context);
                                              },
                                            ),
                                          ],
                                        ),
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
                  appBar: CustomAppBar(
                    title: "",
                    centerTitle: true,
                  ),
                  body: Center(
                    child: Text("Loading".tr().toString()),
                  ),
                );
        },
      ),
    );
  }
}
