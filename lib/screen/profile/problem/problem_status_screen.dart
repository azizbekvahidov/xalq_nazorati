import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/models/problem_info.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/problems/problem_status-card.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ProblemStatusScreen extends StatefulWidget {
  final int id;
  ProblemStatusScreen(this.id);
  @override
  _ProblemStatusScreenState createState() => _ProblemStatusScreenState();
}

class _ProblemStatusScreenState extends State<ProblemStatusScreen> {
  Timer timer;
  List _data;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 100), (Timer t) {
      refreshChat();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<List> getStatus() async {
    try {
      var url = '${globals.api_link}/problems/event-log/${widget.id}';
      HttpGet request = HttpGet();
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);

      var reply = response.json();
      reply.firstWhere((element) {
        checkMessage(element["id"]);
        return true;
      });
      return reply;
    } catch (e) {
      print(e);
    }
  }

  void refreshChat() async {
    try {
      var url =
          '${globals.api_link}/problems/refresh-event-log?problem_id=${widget.id}';
      HttpGet request = HttpGet();
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);

      var reply = response.json();

      reply.lastWhere((element) {
        checkMessage(element["id"]);
        return true;
      });
      setState(() {
        _data.add(reply[0]);
      });
    } catch (e) {
      print(e);
    }
  }

  void checkMessage(int id) async {
    try {
      var url = '${globals.api_link}/problems/check-event?event_id=$id';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);

      String reply = await response.transform(utf8.decoder).join();
    } catch (e) {
      print(e);
    }
  }

  List<ProblemInfo> parseProblems(String responseBody) {
    final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

    return parsed
        .map<ProblemInfo>((json) => ProblemInfo.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "problem_status".tr().toString(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 25, left: 19),
                  child: Text(
                    "problem_status".tr().toString(),
                    style: TextStyle(
                      fontFamily: globals.font,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  )),
              ShadowBox(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: FutureBuilder(
                      future: getStatus(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        _data = snapshot.data;
                        return snapshot.hasData
                            ? ProblemStatusCard(_data)
                            : Center(
                                child: Text("Loading".tr().toString()),
                              );
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
