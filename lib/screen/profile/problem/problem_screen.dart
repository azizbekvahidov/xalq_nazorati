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
    }
    try {
      var url = '${globals.api_link}/problems/list/$_type';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);

      String reply = await response.transform(utf8.decoder).join();
      var temp = json.decode(reply);
      var some = temp.values.toList();

      return parseProblems(json.encode(some[3]));
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
        title: widget.title,
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
                    title: widget.title,
                    status: widget.status,
                  )
                : Center(
                    child: Text("Loading"),
                  );
          },
        ),
      ),
    );
  }
}
