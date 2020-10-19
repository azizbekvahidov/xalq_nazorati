class ChatMessage {
  final int id;
  final String message;
  final String file;
  final String when;
  final int user;
  final int problem;

  ChatMessage({
    this.id,
    this.message,
    this.file,
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
      user: json["user"] as int,
      problem: json["problem"] as int,
    );
  }
}
