import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/category/sub_category_list.dart';
import '../../widget/category/category_card_list.dart';

class SubCategoryScreen extends StatefulWidget {
  static const routeName = "/category-screen";
  final String title;
  final String id;

  SubCategoryScreen(this.title, this.id);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
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
                    SubCategoryCardList(
                        "Несвоевременное восстановление благоустройства территории после разрытий"),
                    SubCategoryCardList(
                        "Наличие опасно выступающих элементов во дворе"),
                    SubCategoryCardList(
                        "Неисправность элементов уличного освещения во дворе"),
                    SubCategoryCardList("Повреждение бордюров"),
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
