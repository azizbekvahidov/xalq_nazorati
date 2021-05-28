import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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

_ProblemScreenState problemScreenState;

class ProblemScreen extends StatefulWidget {
  final String title;
  final String status;
  ProblemScreen({this.title, this.status});
  @override
  _ProblemScreenState createState() {
    problemScreenState = _ProblemScreenState();
    return problemScreenState;
  }
}

class _ProblemScreenState extends State<ProblemScreen> {
  Timer timer;
  bool isRequest = false;
  Map<int, dynamic> _problems = {};
  Future _problemList;

  @override
  void initState() {
    super.initState();
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
          problemScreenState,
          headers);

      if (response["statusCode"] == 200) {
        var res = response["result"];

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
    switch (widget.status) {
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
          '/problems/list/$_type?limit=20', problemScreenState, headers);

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
    switch (widget.status) {
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
            padding: EdgeInsets.only(top: 15),
            child: LazyLoadScrollView(
              onEndOfPage: () {
                if (_loadMore != null)
                  setState(() {
                    _problemList = loadMore();
                  });
              },
              child: FutureBuilder(
                future: _problemList,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ProblemList(
                          data: snapshot.data,
                          title: widget.title == null
                              ? "unresolved".tr().toString()
                              : widget.title,
                          status:
                              widget.status == null ? "warning" : widget.status,
                          alertList: _problems,
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (BuildContext ctx, index) {
                            // print(_list);
                            return SkeletonAnimation(
                              child: ShadowBox(
                                bgColor: Color.fromRGBO(49, 59, 108, 0.1),
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 19, vertical: 15),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ),
        ),
        CheckConnection(),
      ],
    );
  }
}
