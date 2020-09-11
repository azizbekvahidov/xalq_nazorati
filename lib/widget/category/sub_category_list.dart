import 'package:flutter/material.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';

class SubCategoryCardList extends StatelessWidget {
  final String title;
  final String id;
  final bool divider;

  SubCategoryCardList(this.id, this.title, this.divider);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: (mediaQuery.size.width -
                              mediaQuery.padding.left -
                              mediaQuery.padding.right) *
                          0.84,
                      child: Container(
                          child: RichText(
                        text: TextSpan(
                          text: title,
                          style: TextStyle(
                            fontFamily: "Gilroy",
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ))),
                  Container(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ProblemDesc(id, title);
                  },
                ),
                // ModalRoute.withName(HomePage.routeName),
              );
            },
          ),
          if (divider) Divider(),
        ],
      ),
    );
  }
}
