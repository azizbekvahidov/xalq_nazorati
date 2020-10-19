class ProblemInfo {
  final int id;
  final String info_ru;
  final String info_uz;
  final String info_oz;
  final String datetime;
  final int problem;

  ProblemInfo(
      {this.id,
      this.info_ru,
      this.info_uz,
      this.info_oz,
      this.datetime,
      this.problem});

  factory ProblemInfo.fromJson(Map<String, dynamic> json) {
    return ProblemInfo(
      id: json['id'] as int,
      info_ru: json['info_ru'] as String,
      info_uz: json['info_uz'] as String,
      info_oz: json['info_oz'] as String,
      datetime: json['datetime'] as String,
      problem: json['problem'] as int,
    );
  }
}
