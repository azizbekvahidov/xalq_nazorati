import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/models/problems.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/problems/problem_list.dart';

class ProblemScreen extends StatefulWidget {
  final String title;
  final String status;
  ProblemScreen({this.title, this.status});
  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  Timer timer;
  bool isRequest = false;
  Map<int, bool> _problems = {};
  @override
  void initState() {
    super.initState();
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
      String _list = "";
      int i = 0;
      _problems.forEach((key, value) {
        i++;
        _problems[key] = false;
        _list += "$key";
        if (i != _problems.length) _list += ",";
      });

      var url =
          '${globals.api_link}/problems/refresh-user-bells?problem_ids=$_list';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);
      if (response.statusCode == 200) {
        var res = response.json();
        if (res['result'].length != 0) {
          for (var i = 0; i < res['result'].length; i++) {
            var problem_id = res['result'][i];
            _problems[problem_id] = true;
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

  Future<List> getProblems() async {
    String _type = "processing";
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
      var url = '${globals.api_link}/problems/list/$_type';
      HttpGet request = HttpGet();
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);

      var reply = response.json();
      // var some = temp.values.toList();
      var res = reply["results"];
      if (!isRequest) {
        for (var i = 0; i < res.length; i++) {
          Map<int, bool> elem = {res[i]["id"]: false};
          _problems.addAll(elem);
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            widget.title == null ? "unresolved".tr().toString() : widget.title,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: FutureBuilder(
          future: getProblems(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ProblemList(
                    data: snapshot.data,
                    title: widget.title == null
                        ? "unresolved".tr().toString()
                        : widget.title,
                    status: widget.status == null ? "warning" : widget.status,
                    alertList: _problems,
                  )
                : Center(
                    child: Text("Loading".tr().toString()),
                  );
          },
        ),
      ),
    );
  }
}
