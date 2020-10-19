import 'package:xalq_nazorati/models/user.dart';

class Ideas {
  final int id;
  final User user;
  final String address;
  final String title;
  final int likes_count;
  final int dislikes_count;
  final String users_vote;
  final String latitude;
  final String longitude;
  final String status;
  final String file_1;
  final String file_2;
  final String file_3;
  final String file_4;
  final String file_5;
  final String content;
  final String created_at;

  Ideas({
    this.id,
    this.user,
    this.address,
    this.title,
    this.likes_count,
    this.dislikes_count,
    this.users_vote,
    this.latitude,
    this.longitude,
    this.status,
    this.file_1,
    this.file_2,
    this.file_3,
    this.file_4,
    this.file_5,
    this.content,
    this.created_at,
  });

  factory Ideas.fromJson(Map<String, dynamic> json) {
    return Ideas(
      id: json['id'] as int,
      user: json['user'] as User,
      address: json['address'] as String,
      title: json['title'] as String,
      likes_count: json['likes_count'] as int,
      dislikes_count: json['dislikes_count'] as int,
      users_vote: json['users_vote'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      status: json['status'] as String,
      file_1: json['file_1'] as String,
      file_2: json['file_2'] as String,
      file_3: json['file_3'] as String,
      file_4: json['file_4'] as String,
      file_5: json['file_5'] as String,
      content: json['content'] as String,
      created_at: json['created_at'] as String,
    );
  }
}
