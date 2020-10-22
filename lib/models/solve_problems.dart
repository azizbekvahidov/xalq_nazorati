import 'package:xalq_nazorati/models/problems.dart';
import 'package:xalq_nazorati/models/result.dart';

class SolveProblems {
  final Map<String, dynamic> problem;
  final Map<String, dynamic> result;

  SolveProblems({this.problem, this.result});

  factory SolveProblems.fromJson(Map<String, dynamic> json) {
    return SolveProblems(
      problem: json["problem"] as Map<String, dynamic>,
      result: json["result"] as Map<String, dynamic>,
    );
  }
}
