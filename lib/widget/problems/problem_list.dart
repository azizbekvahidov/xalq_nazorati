import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/problems/problem_card.dart';

class ProblemList extends StatefulWidget {
  final String title;
  final String status;
  ProblemList(this.title, this.status);
  @override
  _ProblemListState createState() => _ProblemListState();
}

class _ProblemListState extends State<ProblemList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        ProblemCard(
          status: widget.status,
          title: widget.title,
        ),
        ProblemCard(
          alert: true,
          status: widget.status,
          title: widget.title,
        ),
      ],
    );
  }
}
