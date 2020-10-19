class Ideas {
  final int id;
  final String title_ru;
  final String title_uz;
  final String title_oz;
  final String description_ru;
  final String description_uz;
  final String description_oz;
  final int count_related_ideas;
  final String svg;

  Ideas(
      {this.id,
      this.title_uz,
      this.title_ru,
      this.title_oz,
      this.description_ru,
      this.description_uz,
      this.description_oz,
      this.count_related_ideas,
      this.svg});

  factory Ideas.fromJson(Map<String, dynamic> json) {
    return Ideas(
        id: json['id'] as int,
        title_uz: json['title_uz'] as String,
        title_ru: json['title_ru'] as String,
        title_oz: json['title_oz'] as String,
        description_ru: json['description_ru'] as String,
        description_uz: json['description_uz'] as String,
        description_oz: json['description_oz'] as String,
        count_related_ideas: json['count_related_ideas'] as int,
        svg: json['svg'] as String);
  }
}
