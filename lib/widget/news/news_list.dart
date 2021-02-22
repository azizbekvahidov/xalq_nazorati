import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/news/news_item_planned.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/news/news_item_urgent.dart';

class NewsList extends StatefulWidget {
  final List news;
  final bool breaking;
  bool isMain;
  NewsList({Key key, this.news, this.breaking, this.isMain = false})
      : super(key: key);
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height - 335,
      constraints: widget.isMain
          ? BoxConstraints(
              maxHeight: 150.0 * widget.news.length,
              minHeight: 120.0 * widget.news.length)
          : null,
      // height: 141.0 * widget.news.length,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        physics: BouncingScrollPhysics(),
        itemCount: widget.news.length,
        itemBuilder: (content, index) {
          String title = widget.news[index]["api_title".tr().toString()];
          return widget.breaking
              ? NewsItemUrgent(
                  widget.news[index]["id"].toString(),
                  title,
                  widget.news[index]["location"],
                  widget.news[index]["date_time"],
                  widget.news[index]["img"],
                  widget.news[index]["status"],
                )
              : NewsItemPlanned(
                  widget.news[index]["id"].toString(),
                  title,
                  widget.news[index]["location"],
                  widget.news[index]["date_time"],
                  widget.news[index]["img"],
                  widget.news[index]["api_content".tr().toString()]);
        },
      ),
    );
  }
}
