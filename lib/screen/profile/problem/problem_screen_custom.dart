import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:requests/requests.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/models/problems.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/problems/problem_list.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';
import 'package:xalq_nazorati/widget/success_box.dart';

_ProblemScreenCustomState problemScreenCustomState;

class ProblemScreenCustom extends StatefulWidget {
  final String title;
  final String status;
  ProblemScreenCustom({this.title, this.status});

  @override
  _ProblemScreenCustomState createState() {
    problemScreenCustomState = _ProblemScreenCustomState();
    return problemScreenCustomState;
  }
}

class _ProblemScreenCustomState extends State<ProblemScreenCustom> {
  Timer timer;
  bool isRequest = false;
  Map<int, dynamic> _problems = {};
  Future _problemList;
  int _index = 0;
  Color _bg1;
  Color _txt1;
  Color _bg2;
  Color _txt2;
  bool _onLoad = false;
  String _problem_status = "warning";
  bool isInfo = true;
  final List<Widget> _children = [
    Container(
      child: Text("first"),
    ),
    Container(
      child: Text("second"),
    )
    // ProblemScreenCustom(title: "unresolved".tr().toString(), status: "warning"),
    // ProblemScreenCustom(
    //     title: "delayed_problems".tr().toString(), status: "delayed"),
  ];

  void _selectTab(index) {
    _problemList;
    setState(() {});
    setState(() {
      _index = index;
      isRequest = false;
      if (index == 0) {
        _problem_status = "warning";
        _bg1 = Theme.of(context).primaryColor;
        _bg2 = Color.fromRGBO(49, 59, 108, 0.05);
        _txt1 = Colors.white;
        _txt2 = Color(0xff66676C);
      } else {
        _bg1 = Color.fromRGBO(49, 59, 108, 0.05);
        _bg2 = Theme.of(context).primaryColor;
        _txt1 = Color(0xff66676C);
        _txt2 = Colors.white;
        _problem_status = "delayed";
      }
      _problemList = getProblems();
    });
  }

  @override
  void initState() {
    super.initState();
    _problem_status = widget.status;
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectTab(_index));
    _problemList = getProblems();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
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
      String _list = "";
      int i = 0;
      _problems.forEach((key, value) {
        i++;
        _problems[key]["notify"] = false;
        _list += "$key";
        if (i != _problems.length) _list += ",";
      });
      var connect = new DioConnection();
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await connect.getHttp(
          '/problems/refresh-problem?problem_ids=$_list',
          problemScreenCustomState,
          headers);

      if (response["statusCode"] == 200) {
        var res = response['result'];

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
            // print('$problem_id ==> ${res[i]['status']} ==> $_notify');
            if (_notify != _problems[problem_id]["notify"]) {
              setState(() {
                _problems[problem_id]["notify"] = _notify;
              });
              // cardContentState.setState(() {
              //   globals.cardAlert[problem_id] = _problems[problem_id];
              // });
            } else {
              setState(() {});
            }
            globals.cardAlert[problem_id] = _problems[problem_id];
          }
        }
      }
      // String reply = await response.transform(utf8.decoder).join();

      // var temp = parseProblems(reply);

    } catch (e) {
      print(e);
    }
  }

  String _loadMore = "";
  String _type = "processing";
  List<dynamic> _results = [];
  Future<List> getProblems() async {
    switch (_problem_status) {
      case "warning":
        _type = "processing";
        break;
      case "success":
        _type = "confirmed";
        break;
      case "danger":
        _type = "denied";
        break;
      case "delayed":
        _type = "planned";
        break;
    }
    try {
      var connect = new DioConnection();
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await connect.getHttp(
          '/problems/list/$_type?limit=20', problemScreenCustomState, headers);

      var reply = response["result"];
      _loadMore = reply['next'];
      var res = reply["results"];
      _results.addAll(res);
      if (!isRequest) {
        for (var i = 0; i < res.length; i++) {
          Map<int, dynamic> elem = {
            res[i]["id"]: {
              "notify": false,
              "chat_cnt": 0,
              "event_cnt": 0,
              "res": null,
              "res_seen": true,
              "status": res[i]["status"]
            }
          };
          _problems.addAll(elem);
        }
        globals.cardAlert = _problems;
        refreshBells();
        isRequest = true;
        _onLoad = true;
      }
      return res;
    } catch (e) {
      print(e);
    }
  }

  List<Problems> parseProblems(String responseBody) {
    final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

    return parsed.map<Problems>((json) => Problems.fromJson(json)).toList();
  }

  Future loadMore() async {
    switch (_problem_status) {
      case "warning":
        _type = "processing";
        break;
      case "success":
        _type = "confirmed";
        break;
      case "danger":
        _type = "denied";
        break;
      case "delayed":
        _type = "planned";
        break;
    }
    try {
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(_loadMore, headers: headers);

      var reply = response.json();

      _loadMore = reply['next'];
      var res = reply["results"];

      for (var i = 0; i < res.length; i++) {
        Map<int, dynamic> elem = {
          res[i]["id"]: {
            "notify": false,
            "chat_cnt": 0,
            "event_cnt": 0,
            "res": null,
            "res_seen": false,
            "status": ""
          }
        };
        _problems.addAll(elem);
      }
      globals.cardAlert.addAll(_problems);
      refreshBells();
      _results.addAll(res);
      return _results;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: widget.title == null
                ? "unresolved".tr().toString()
                : widget.title,
            centerTitle: true,
          ),
          body: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _onLoad = false;
                              });
                              _selectTab(0);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: _bg1,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "in_proccess".tr().toString(),
                                style: TextStyle(
                                  color: _txt1,
                                  fontFamily: globals.font,
                                  fontSize: width * globals.fontSize16,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _onLoad = false;
                              });
                              _selectTab(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: _bg2,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "delayed".tr().toString(),
                                style: TextStyle(
                                  color: _txt2,
                                  fontFamily: globals.font,
                                  fontSize: width * globals.fontSize16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: _onLoad
                      ? Column(
                          children: [
                            (_problem_status == 'delayed')
                                ? SuccessBox(
                                    children: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/img/info.svg",
                                          height: 24,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 10)),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isInfo = !isInfo;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(top: 4),
                                            width: width * 0.77,
                                            child: RichText(
                                              text: TextSpan(
                                                text: isInfo
                                                    ? "delayed_info"
                                                        .tr()
                                                        .toString()
                                                    : "delayed_desc"
                                                        .tr()
                                                        .toString(),
                                                style: TextStyle(
                                                  fontFamily: globals.font,
                                                  color: Color(0xff050505),
                                                  fontSize: width *
                                                      globals.fontSize14,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures: [
                                                    FontFeature.enable("pnum"),
                                                    FontFeature.enable("lnum")
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Container(
                              height: dHeight <= 560
                                  ? dHeight -
                                      ((_problem_status != 'delayed')
                                          ? 160
                                          : isInfo
                                              ? 210
                                              : 300)
                                  : dHeight -
                                      ((_problem_status != 'delayed')
                                          ? 270
                                          : isInfo
                                              ? 331
                                              : 482),
                              child: Container(
                                padding: EdgeInsets.only(top: 0),
                                child: LazyLoadScrollView(
                                  onEndOfPage: () {
                                    if (_loadMore != null)
                                      setState(() {
                                        _problemList = loadMore();
                                      });
                                  },
                                  child: _problemList != null
                                      ? FutureBuilder(
                                          future: _problemList,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError)
                                              print(snapshot.error);
                                            return snapshot.hasData
                                                ? ProblemList(
                                                    data: snapshot.data,
                                                    title: widget.title == null
                                                        ? "unresolved"
                                                            .tr()
                                                            .toString()
                                                        : widget.title,
                                                    status:
                                                        _problem_status == null
                                                            ? "warning"
                                                            : _problem_status,
                                                    alertList: _problems,
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemCount: 5,
                                                    itemBuilder:
                                                        (BuildContext ctx,
                                                            index) {
                                                      // print(_list);
                                                      return SkeletonAnimation(
                                                        child: ShadowBox(
                                                          bgColor:
                                                              Color.fromRGBO(49,
                                                                  59, 108, 0.1),
                                                          child: Container(
                                                            height: 50,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        19,
                                                                    vertical:
                                                                        15),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                          },
                                        )
                                      : Container(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
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
