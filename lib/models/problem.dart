import 'package:xalq_nazorati/models/user.dart';

class Problem {
  final int id;
  final bool is_active;
  final String address;
  final String latitude;
  final String longitude;
  final String content;
  final String note;
  final String create_at;
  final String status;
  final String file_1;
  final String file_2;
  final String file_3;
  final String file_4;
  final String file_5;
  final String deadline;
  final Map<String, dynamic> user;
  final Map<String, dynamic> subsubcategory;
  final Map<String, dynamic> executors;
  final Map<String, dynamic> result;

  Problem({
    this.id,
    this.address,
    this.content,
    this.note,
    this.create_at,
    this.deadline,
    this.file_1,
    this.file_2,
    this.file_3,
    this.file_4,
    this.file_5,
    this.is_active,
    this.latitude,
    this.longitude,
    this.status,
    this.user,
    this.subsubcategory,
    this.executors,
    this.result,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'] as int,
      address: json['address'] as String,
      content: json['content'] as String,
      note: json['note'] as String,
      create_at: json['create_at'] as String,
      deadline: json['deadline'] as String,
      file_1: json['file_1'] as String,
      file_2: json['file_2'] as String,
      file_3: json['file_3'] as String,
      file_4: json['file_4'] as String,
      file_5: json['file_5'] as String,
      is_active: json['is_active'] as bool,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      status: json['status'] as String,
      user: json['user'] as Map<String, dynamic>,
      subsubcategory: json['subsubcategory'] as Map<String, dynamic>,
      executors: json['executors'] as Map<String, dynamic>,
      result: json['result'] as Map<String, dynamic>,
    );
  }
}
