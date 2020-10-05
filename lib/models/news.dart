class News {
  final int id;
  final String publishDate;
  final String location;
  final String title_ru;
  final String title_uz;
  final String title_oz;
  final String img;
  final String content_ru;
  final String content_uz;
  final String content_oz;

  News({
    this.id,
    this.title_uz,
    this.title_ru,
    this.title_oz,
    this.img,
    this.publishDate,
    this.location,
    this.content_ru,
    this.content_uz,
    this.content_oz,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      title_uz: json['title_uz'] as String,
      title_ru: json['title_ru'] as String,
      title_oz: json['title_oz'] as String,
      img: json['img'] as String,
      content_ru: json['content_ru'] as String,
      content_uz: json['content_uz'] as String,
      content_oz: json['content_oz'] as String,
      publishDate: json['date'] as String,
      location: json['location'] as String,
    );
  }
}
