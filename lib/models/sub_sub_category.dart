class SubSubCategories {
  final int id;
  final String title_ru;
  final String title_uz;
  final String title_oz;
  final String svg;

  SubSubCategories(
      {this.id, this.title_uz, this.title_ru, this.title_oz, this.svg});

  factory SubSubCategories.fromJson(Map<String, dynamic> json) {
    return SubSubCategories(
      id: json['id'] as int,
      title_uz: json['title_uz'] as String,
      title_ru: json['title_ru'] as String,
      title_oz: json['title_oz'] as String,
    );
  }
}
