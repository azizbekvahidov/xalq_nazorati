import 'package:xalq_nazorati/models/user.dart';

class Result {
  final bool is_active;
  final String before;
  final String after;
  final String content;
  final String status;
  final String file_1;
  final String file_2;
  final String file_3;
  final String file_4;
  final String file_5;
  final String file_6;
  final String file_7;
  final String file_8;
  final String file_9;
  final String file_10;

  Result({
    this.content,
    this.before,
    this.after,
    this.is_active,
    this.status,
    this.file_1,
    this.file_2,
    this.file_3,
    this.file_4,
    this.file_5,
    this.file_6,
    this.file_7,
    this.file_8,
    this.file_9,
    this.file_10,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      before: json['before'] as String,
      content: json['content'] as String,
      after: json['after'] as String,
      is_active: json['is_active'] as bool,
      status: json['status'] as String,
      file_1: json['file_1'] as String,
      file_2: json['file_2'] as String,
      file_3: json['file_3'] as String,
      file_4: json['file_4'] as String,
      file_5: json['file_5'] as String,
      file_6: json['file_6'] as String,
      file_7: json['file_7'] as String,
      file_8: json['file_8'] as String,
      file_9: json['file_9'] as String,
      file_10: json['file_10'] as String,
    );
  }
}
