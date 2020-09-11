import 'package:flutter/material.dart';
import '../../screen/main_page/sub_category_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import '../../widget/category/category_card_list.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/category-screen";
  final String title;
  final String id;

  CategoryScreen({this.title, this.id, Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
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
                      CategoryCardList(
                          "subcat1",
                          "Благоустройство",
                          SubCategoryScreen("Благоустройство", "subcat1"),
                          true),
                      CategoryCardList("subcat2", "Деревья",
                          SubCategoryScreen("Деревья", "subcat1"), true),
                      CategoryCardList(
                          "subcat3",
                          "Дворная инфраструктура",
                          SubCategoryScreen(
                              "Дворная инфраструктура", "subcat1"),
                          true),
                      CategoryCardList(
                          "subcat4",
                          "Благоустройство",
                          SubCategoryScreen("Благоустройство", "subcat1"),
                          true),
                      CategoryCardList(
                          "subcat5",
                          "Уборка и мусор",
                          SubCategoryScreen("Уборка и мусор", "subcat1"),
                          false),
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
