import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
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
  Future<List<ProblemInfo>> getStatus() async {
    try {
      var url = '${globals.api_link}/problems/event-log/${widget.id}';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);

      String reply = await response.transform(utf8.decoder).join();

      return parseProblems(reply);
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
        title: "Статус проблемы",
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
                    child: FutureBuilder(
                      future: getStatus(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);

                        return snapshot.hasData
                            ? ProblemStatusCard(snapshot.data)
                            : Center(
                                child: Text("Loading"),
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
