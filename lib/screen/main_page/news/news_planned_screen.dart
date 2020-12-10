import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/models/news.dart';
import 'package:xalq_nazorati/widget/news/news_list.dart';

class NewsPlannedScreen extends StatefulWidget {
  @override
  _NewsPlannedScreenState createState() => _NewsPlannedScreenState();
}

class _NewsPlannedScreenState extends State<NewsPlannedScreen> {
  Future<List> getNews() async {
    var url = '${globals.api_link}/news?category=planned';

    var response = await Requests.get(url);

    var reply = response.json();

    return reply["results"];
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
                    child: Text("no_news".tr().toString()),
                  );
          }),
    );
  }
}
