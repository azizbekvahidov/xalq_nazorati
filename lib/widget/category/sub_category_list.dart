import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';

class SubCategoryCardList extends StatelessWidget {
  final String title;
  final int id;
  final bool divider;
  final int categoryId;
  FutureOr onGoBack(dynamic value) {
    clearImages();
  }

  void clearImages() {
    globals.images.addAll({
      "file1": null,
      "file2": null,
      "file3": null,
      "file4": null,
    });
  }

  SubCategoryCardList(this.id, this.title, this.categoryId, this.divider);
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
                            fontFamily: globals.font,
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
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ProblemDesc(id, title, categoryId);
                  },
                ),
                // ModalRoute.withName(HomePage.routeName),
              ).then(onGoBack);
            },
          ),
          if (divider) Divider(),
        ],
      ),
    );
  }
}
