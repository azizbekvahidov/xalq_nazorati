import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/main_page/sub_category_screen.dart';
import 'package:xalq_nazorati/widget/category/category_card_list.dart';

class SubCategoriesList extends StatefulWidget {
  final List categories;
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
          return CategoryCardList(
              widget.categories[index]["id"],
              widget.categories[index]["api_title".tr().toString()],
              SubCategoryScreen(
                widget.categories[index]["api_title".tr().toString()],
                widget.categories[index]["id"],
                widget.categories[index]['category']["id"],
              ),
              widget.categories.length - 1 != index ? true : false);
        },
      ),
    );
  }
}
