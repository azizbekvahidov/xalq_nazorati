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
import 'package:xalq_nazorati/widget/category/sub_category_list.dart';

class SubSubCategoriesList extends StatefulWidget {
  final List<SubCategories> categories;
  SubSubCategoriesList({Key key, this.categories}) : super(key: key);

  @override
  _SubSubCategoriesListState createState() => _SubSubCategoriesListState();
}

class _SubSubCategoriesListState extends State<SubSubCategoriesList> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.75, minHeight: 70),

      // height: mediaQuery.size.height * 0.75,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          var encode = utf8.encode(widget.categories[index].title_ru);
          return SubCategoryCardList(
              widget.categories[index].id,
              widget.categories[index].title_ru,
              widget.categories.length - 1 != index ? true : false);
          // CategoryCard(widget.categories[index].id, utf8.decode(encode),
          //     "${widget.categories[index].svg}");
        },
      ),
    );
  }
}
