import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/models/problems.dart';
import 'package:xalq_nazorati/widget/problems/problem_card.dart';

class ProblemList extends StatefulWidget {
  final List data;
  final String title;
  final String status;
  final Map<int, dynamic> alertList;
  Timer timer;
  Function refreshBells;
  ProblemList({this.data, this.title, this.status, this.alertList, Key key})
      : super(key: key);
  @override
  _ProblemListState createState() => _ProblemListState();
}

class _ProblemListState extends State<ProblemList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: widget.data.length,
      itemBuilder: (BuildContext ctx, index) {
        var _list = widget.alertList;
        Map<dynamic, dynamic> alerts = _list[widget.data[index]["id"]];

        // print(_list);
        return ProblemCard(
          status: widget.status,
          title: widget.title,
          data: widget.data[index],
          alert: _list[widget.data[index]["id"]],
        );
      },
    );
  }
}
