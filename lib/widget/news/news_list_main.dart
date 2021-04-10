import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/news/news_item_main.dart';
import 'package:xalq_nazorati/widget/news/news_item_planned.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/news/news_item_urgent.dart';

class NewsListMain extends StatefulWidget {
  final List news;
  final bool breaking;
  bool isMain;
  NewsListMain({Key key, this.news, this.breaking, this.isMain = false})
      : super(key: key);
  @override
  _NewsListMainState createState() => _NewsListMainState();
}

class _NewsListMainState extends State<NewsListMain> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: 300,
      // height: 141.0 * widget.news.length,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: widget.news.length,
        itemBuilder: (content, index) {
          String title = widget.news[index]["api_title".tr().toString()];
          return NewsItemMain(
            widget.news[index]["id"].toString(),
            title,
            widget.news[index]["location"],
            widget.news[index]["date_time"],
            widget.news[index]["img"],
            widget.news[index]["status"],
          );
        },
      ),
    );
  }
}
