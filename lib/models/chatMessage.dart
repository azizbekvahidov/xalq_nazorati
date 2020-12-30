class ChatMessage {
  final int id;
  final String message;
  final String file;
  final String when;
  final bool moderator;
  final Map<String, dynamic> user;
  final Map<String, dynamic> problem;
  final Map<String, dynamic> work_details;

  ChatMessage({
    this.id,
    this.message,
    this.file,
    this.moderator,
    this.work_details,
    this.when,
    this.user,
    this.problem,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json["id"] as int,
      message: json["message"] as String,
      file: json["file"] as String,
      when: json["when"] as String,
      moderator: json["moderator"] as bool,
      user: json["user"] as Map<String, dynamic>,
      work_details: json["work_details"] as Map<String, dynamic>,
      problem: json["problem"] as Map<String, dynamic>,
    );
  }
}
