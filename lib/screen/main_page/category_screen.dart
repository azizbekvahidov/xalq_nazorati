import 'package:flutter/material.dart';
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
        appBar: AppBar(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.display2,
          ),
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
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryCardList("subcat1", "Благоустройство"),
                      CategoryCardList("subcat2", "Деревья"),
                      CategoryCardList("subcat3", "Дворная инфраструктура"),
                      CategoryCardList("subcat4", "Благоустройство"),
                      CategoryCardList("subcat5", "Уборка и мусор"),
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
