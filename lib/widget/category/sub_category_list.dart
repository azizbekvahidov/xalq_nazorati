import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';
import 'package:xalq_nazorati/widget/get_login_dialog.dart';

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

  customDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.45,
              padding: EdgeInsets.symmetric(vertical: 40),
              child: GetLoginDialog(),
            ),
          );
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
                          0.82,
                      child: Container(
                          child: RichText(
                        text: TextSpan(
                          text: title,
                          style: TextStyle(
                            fontFamily: globals.font,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontSize: mediaQuery.size.width < 360 ? 16 : 18,
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
              if (globals.token != null) {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return null;
                      //ProblemDesc(id, title, categoryId, "");
                    },
                  ),
                  // ModalRoute.withName(HomePage.routeName),
                ).then(onGoBack);
              } else {
                customDialog(context);
              }
            },
          ),
          if (divider) Divider(),
        ],
      ),
    );
  }
}
