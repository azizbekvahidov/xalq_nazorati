import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/models/news.dart';
import 'package:xalq_nazorati/widget/news/news_list.dart';

_NewsPlannedScreenState newsPlannedScreenState;

class NewsPlannedScreen extends StatefulWidget {
  @override
  _NewsPlannedScreenState createState() => _NewsPlannedScreenState();
}

class _NewsPlannedScreenState extends State<NewsPlannedScreen> {
  Future<List> getNews() async {
    var connect = new DioConnection();
    Map<String, String> headers = {};
    var response = await connect.getHttp(
        '/news?category=planned', newsPlannedScreenState, headers);

    var reply = response["result"];

    return reply["results"];
  }

  List<News> parseNews(var responseBody) {
    final parsed = json.decode(responseBody).cast<dynamic>();
    var res = parsed.map<News>((json) => News.fromJson(json)).toList();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: FutureBuilder(
          future: getNews(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "planning".tr().toString().replaceAll("\n", " "),
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: width * globals.fontSize16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      NewsList(news: snapshot.data, breaking: false),
                    ],
                  )
                : Center(
                    child: Text("no_news".tr().toString()),
                  );
          }),
    );
  }
}
