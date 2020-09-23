import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/models/category.dart';
import 'package:xalq_nazorati/models/sub_category.dart';
import 'package:xalq_nazorati/screen/main_page/sub_category_screen.dart';
import 'package:xalq_nazorati/widget/category/category_card.dart';
import 'package:xalq_nazorati/widget/category/category_card_list.dart';

class SubCategoriesList extends StatefulWidget {
  final List<SubCategories> categories;
  SubCategoriesList({Key key, this.categories}) : super(key: key);

  @override
  _SubCategoriesListState createState() => _SubCategoriesListState();
}

class _SubCategoriesListState extends State<SubCategoriesList> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: mediaQuery.size.height * 0.7,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          var encode = utf8.encode(widget.categories[index].title_ru);
          return CategoryCardList(
              widget.categories[index].id,
              widget.categories[index].title_ru,
              SubCategoryScreen(widget.categories[index].title_ru,
                  widget.categories[index].id),
              widget.categories.length - 1 != index ? true : false);
          // CategoryCard(widget.categories[index].id, utf8.decode(encode),
          //     "${widget.categories[index].svg}");
        },
      ),
    );
  }
}
