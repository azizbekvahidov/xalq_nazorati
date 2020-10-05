import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/news.dart';
import 'package:xalq_nazorati/widget/news/news_list.dart';

class NewsPlannedScreen extends StatefulWidget {
  @override
  _NewsPlannedScreenState createState() => _NewsPlannedScreenState();
}

class _NewsPlannedScreenState extends State<NewsPlannedScreen> {
  Future<List<News>> getNews() async {
    var url = '${globals.api_link}/news?category=planned';
    HttpGet request = HttpGet();
    var response = await request.methodGet(url);

    String reply = await response.transform(utf8.decoder).join();
    var temp = json.decode(reply);
    var some = temp.values.toList();
    return parseNews(json.encode(some[3]));
  }

  List<News> parseNews(var responseBody) {
    final parsed = json.decode(responseBody).cast<dynamic>();
    var res = parsed.map<News>((json) => News.fromJson(json)).toList();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getNews(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? NewsList(news: snapshot.data, breaking: false)
                : Center(
                    child: Text("Loading"),
                  );
          }),
    );
  }
}
