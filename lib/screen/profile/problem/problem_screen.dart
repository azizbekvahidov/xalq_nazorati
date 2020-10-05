import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/models/problems.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/problems/problem_list.dart';

class ProblemScreen extends StatefulWidget {
  final String title;
  final String status;
  ProblemScreen(this.title, this.status);
  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  Future<List<Problems>> getProblems() async {
    try {
      var url = '${globals.api_link}/problems/processing';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      // Map map = {"phone": "processing"};
      var r1 = await Requests.get(url,
          headers: headers, verify: false, persistCookies: true);

      if (r1.statusCode == 200) {
        r1.raiseForStatus();
      } else {
        dynamic json = r1.json();
        print(json);
      }

      return parseProblems(r1.content());
    } catch (e) {
      print(e);
    }
  }

  List<Problems> parseProblems(String responseBody) {
    print(responseBody);
    final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

    return parsed.map<Problems>((json) => Problems.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: FutureBuilder(
          future: getProblems(),
          builder: (context, snapshot) {
            return ProblemList(widget.title, widget.status);
          },
        ),
      ),
    );
  }
}
