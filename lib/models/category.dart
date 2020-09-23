class Categories {
  final int id;
  final String title_ru;
  final String title_uz;
  final String title_oz;
  final String svg;

  Categories({this.id, this.title_uz, this.title_ru, this.title_oz, this.svg});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        id: json['id'] as int,
        title_uz: json['title_uz'] as String,
        title_ru: json['title_ru'] as String,
        title_oz: json['title_oz'] as String,
        svg: json['svg'] as String);
  }
}
