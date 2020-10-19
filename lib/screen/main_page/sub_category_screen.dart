import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/sub_category.dart';
import 'package:xalq_nazorati/widget/category/sub_sub_categories_list.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/category/sub_category_list.dart';

class SubCategoryScreen extends StatefulWidget {
  static const routeName = "/category-screen";
  final String title;
  final int id;

  SubCategoryScreen(this.title, this.id);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  Future<List<SubCategories>> getCategory() async {
    var url = '${globals.api_link}/problems/subsubcategories/${widget.id}';
    HttpGet request = HttpGet();
    var response = await request.methodGet(url);

    String reply = await response.transform(utf8.decoder).join();
    print(response);
    return parseCategory(reply);
  }

  List<SubCategories> parseCategory(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<SubCategories>((json) => SubCategories.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: CustomAppBar(
        title: widget.title,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height - mediaQuery.size.height * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(4, 6), // changes position of shadow
                    ),
                  ],
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                        future: getCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? SubSubCategoriesList(categories: snapshot.data)
                              : Center(
                                  child: Text("Loading"),
                                );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
