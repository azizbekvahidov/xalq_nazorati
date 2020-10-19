import 'package:xalq_nazorati/models/user.dart';

class Problems {
  final int id;
  final bool is_active;
  final String address;
  final String latitude;
  final String longitude;
  final String content;
  final String status;
  final String file_1;
  final String file_2;
  final String file_3;
  final String file_4;
  final String file_5;
  final String deadline;
  final Map<String, dynamic> user;
  final Map<String, dynamic> subsubcategory;

  Problems({
    this.id,
    this.address,
    this.content,
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
  });

  factory Problems.fromJson(Map<String, dynamic> json) {
    return Problems(
      id: json['id'] as int,
      address: json['address'] as String,
      content: json['content'] as String,
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
    );
  }
}
