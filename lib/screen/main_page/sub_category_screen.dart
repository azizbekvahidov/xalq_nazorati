import 'package:flutter/material.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/category/sub_category_list.dart';

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
                    SubCategoryCardList(
                        "id1",
                        "Несвоевременное восстановление благоустройства территории после разрытий",
                        true),
                    SubCategoryCardList("id1",
                        "Наличие опасно выступающих элементов во дворе", true),
                    SubCategoryCardList(
                        "id1",
                        "Неисправность элементов уличного освещения во дворе",
                        true),
                    SubCategoryCardList("id1", "Повреждение бордюров", false),
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
