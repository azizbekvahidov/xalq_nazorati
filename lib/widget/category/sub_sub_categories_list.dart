import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/category/sub_category_list.dart';

class SubSubCategoriesList extends StatefulWidget {
  final List categories;
  final int categoryId;
  SubSubCategoriesList({Key key, this.categories, this.categoryId})
      : super(key: key);

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
          return SubCategoryCardList(
              widget.categories[index]["id"],
              widget.categories[index]["api_title".tr().toString()],
              widget.categoryId,
              widget.categories.length - 1 != index ? true : false);
        },
      ),
    );
  }
}
