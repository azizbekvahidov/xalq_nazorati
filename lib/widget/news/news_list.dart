import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/news/news_item_planned.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/news/news_item_urgent.dart';

class NewsList extends StatefulWidget {
  final List news;
  final bool breaking;
  NewsList({Key key, this.news, this.breaking}) : super(key: key);
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 141.0 * widget.news.length,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.news.length,
        itemBuilder: (content, index) {
          String title = widget.news[index]["api_title".tr().toString()];

          return widget.breaking
              ? NewsItemUrgent(
                  widget.news[index]["id"].toString(),
                  title,
                  widget.news[index]["location"],
                  widget.news[index]["date_time"],
                  widget.news[index]["img"])
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
