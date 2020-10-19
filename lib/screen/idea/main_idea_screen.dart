import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/ideas.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_icon_appbar.dart';
import 'package:xalq_nazorati/widget/idea-widget/idea_card_widget.dart';

class MainIdeaScreen extends StatefulWidget {
  @override
  _MainIdeaScreenState createState() => _MainIdeaScreenState();
}

class _MainIdeaScreenState extends State<MainIdeaScreen> {
  Future<List<Ideas>> getIdeas() async {
    var url = '${globals.api_link}/ideas/categories';
    HttpGet request = HttpGet();
    var response = await request.methodGet(url);

    String reply = await response.transform(utf8.decoder).join();
    var temp = json.decode(reply);
    var some = temp.values.toList();
    return parseNews(json.encode(some[3]));
  }

  List<Ideas> parseNews(var responseBody) {
    final parsed = json.decode(responseBody).cast<dynamic>();
    var res = parsed.map<Ideas>((json) => Ideas.fromJson(json)).toList();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomIconAppBar(
        title: "Предложить идею",
        icon: "assets/img/idea.svg",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
            future: getIdeas(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              var data = snapshot.data;
              return snapshot.hasData
                  ? Container(
                      // color: Colors.black,
                      height: data.length * 78.0,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return IdeaCardWidget(data[index]);
                        },
                      ),
                    )
                  : Center(
                      child: Text("Loading"),
                    );
            }),
      ),
    );
  }
}
