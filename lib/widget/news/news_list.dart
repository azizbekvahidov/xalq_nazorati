import 'package:flutter/material.dart';
import 'package:xalq_nazorati/models/news.dart';
import 'package:xalq_nazorati/widget/news/news_item_planned.dart';
import 'package:xalq_nazorati/widget/news/news_item_urgent.dart';

class NewsList extends StatefulWidget {
  final List<News> news;
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
          String title = widget.news[index].title_ru;
          return widget.breaking
              ? NewsItemUrgent(
                  widget.news[index].id,
                  title,
                  widget.news[index].location,
                  widget.news[index].publishDate,
                  widget.news[index].img)
              : NewsItemPlanned(
                  widget.news[index].id,
                  title,
                  widget.news[index].location,
                  widget.news[index].publishDate,
                  widget.news[index].img,
                  widget.news[index].content_ru);
        },
      ),
    );
  }
}
