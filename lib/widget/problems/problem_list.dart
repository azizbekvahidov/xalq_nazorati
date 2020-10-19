import 'package:flutter/material.dart';
import 'package:xalq_nazorati/models/problems.dart';
import 'package:xalq_nazorati/widget/problems/problem_card.dart';

class ProblemList extends StatefulWidget {
  final List<Problems> data;
  final String title;
  final String status;
  ProblemList({this.data, this.title, this.status, Key key}) : super(key: key);
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
        return ProblemCard(
          status: widget.status,
          title: widget.title,
          data: widget.data[index],
        );
      },
    );
  }
}
