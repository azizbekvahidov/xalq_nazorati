import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/category/category_card.dart';

class CategoryList extends StatefulWidget {
  final List categories;
  CategoryList({Key key, this.categories}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      alignment: Alignment.topLeft,
      width: mediaQuery.size.width,
      height: mediaQuery.size.width * 3 / 4,
      child: GridView.builder(
        // reverse: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 3.5,
        ),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          var encode = utf8
              .encode(widget.categories[index]["api_title".tr().toString()]);
          return CategoryCard(widget.categories[index]["id"],
              utf8.decode(encode), "${widget.categories[index]["svg"]}");
        },
      ),
    );
  }
}
