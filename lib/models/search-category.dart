import 'package:flutter/foundation.dart';

class SearchCategory {
  final Map<String, dynamic> categories;
  final Map<String, dynamic> subcategories;
  final Map<String, dynamic> subsubcategories;

  SearchCategory({
    this.categories,
    this.subcategories,
    this.subsubcategories,
  });

  factory SearchCategory.fromJson(Map<String, dynamic> json) {
    return SearchCategory(
      categories: json["categories"] as Map<String, dynamic>,
      subcategories: json["subcategories"] as Map<String, dynamic>,
      subsubcategories: json["subsubcategories"] as Map<String, dynamic>,
    );
  }
}
