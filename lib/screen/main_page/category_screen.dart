import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/models/sub_category.dart';
import 'package:xalq_nazorati/widget/category/sub_categories_list.dart';
import '../../screen/main_page/sub_category_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import '../../widget/category/category_card_list.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/category-screen";
  final String title;
  final int id;

  CategoryScreen({this.title, this.id, Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  Future<List<SubCategories>> getCategory() async {
    var url =
        'https://new.xalqnazorati.uz/ru/api/problems/subcategories/${widget.id}';
    var response = await http
        .get(url, headers: {"Authorization": "token ${globals.token}"});
    print(response);
    return parseCategory(utf8.decode(response.bodyBytes));
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF5F6F9),
        appBar: CustomAppBar(
          title: widget.title,
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
                    children: [
                      FutureBuilder(
                          future: getCategory(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? SubCategoriesList(categories: snapshot.data)
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
