import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/main_page/problem/check_problem_category.dart';
import 'package:xalq_nazorati/screen/main_page/problem/how_it_works.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';
import 'package:xalq_nazorati/widget/custom_expansion_tile.dart' as custom;
import 'package:xalq_nazorati/widget/get_login_dialog.dart';

class ExpanseListTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final int subcategoryId;
  final String category_title;
  ExpanseListTile({this.data, this.subcategoryId, this.category_title, Key key})
      : super(key: key);

  @override
  _ExpanseListTileState createState() => _ExpanseListTileState();
}

class _ExpanseListTileState extends State<ExpanseListTile> {
  bool isExpanded;

  Future<dynamic> _subsubCategories;
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
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: GetLoginDialog(),
            ),
          );
        });
  }

  customWarningDialog(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var dWidth = MediaQuery.of(context).size.width;
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
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/img/info.svg",
                      height: height * 0.12,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "problem_warning".tr().toString(),
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: dWidth * globals.fontSize16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 35),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "close".tr().toString(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        FlatButton(
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 35),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "next".tr().toString(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpanded = true;
    if (widget.subcategoryId != null) {
      if (widget.data["id"] == widget.subcategoryId) {}
    }
    if (globals.subsubcategoryList.isEmpty) {
      if (globals.subsubcategoryList[widget.data["id"]] == null) {
        _subsubCategories = getSubCategory(widget.data["id"]);
        globals.subsubcategoryList
            .addAll({widget.data["id"]: _subsubCategories});
      } else {
        _subsubCategories = globals.subsubcategoryList[widget.data["id"]];
      }
    } else {
      if (globals.subsubcategoryList[widget.data["id"]] == null) {
        _subsubCategories = getSubCategory(widget.data["id"]);
        globals.subsubcategoryList
            .addAll({widget.data["id"]: _subsubCategories});
      } else {
        _subsubCategories = globals.subsubcategoryList[widget.data["id"]];
      }
    }
  }

  Future<List> getSubCategory(int id) async {
    var url = '${globals.api_link}/problems/subsubcategories/$id';

    // Map<String, String> headers = {"Authorization": "token ${globals.token}"};

    var response = await Requests.get(url);

    var reply = response.json();

    return reply;
  }

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

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var dWidth = mediaQuery.size.width;
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffD5D8E5), width: 0.5),
        borderRadius: BorderRadius.circular(10),
        color: isExpanded ? Theme.of(context).primaryColor : Colors.white,
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
      // padding: EdgeInsets.symmetric(vertical: 10),
      child: custom.ExpansionTile(
        title: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            child: Text(
              widget.data["api_title".tr().toString()],
              style: TextStyle(
                fontFamily: globals.font,
                color: (isExpanded) ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: dWidth * globals.fontSize18,
              ),
            )),
        iconColor: isExpanded ? Colors.white : Colors.black,
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        initiallyExpanded: true,
        headerBackgroundColor: Colors.transparent,
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                child: FutureBuilder(
                    future: _subsubCategories,
                    builder: (context, snap) {
                      if (snap.hasError) print(snap.error);
                      return snap.hasData
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: 81.0 * snap.data.length,
                                  minHeight: 56.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  String breadCrumbs =
                                      "${widget.category_title} → ${widget.data["api_title".tr().toString()]} → ${snap.data[index]["api_title".tr().toString()]}";
                                  return ListTile(
                                    title: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (globals.token != null) {
                                              // customWarningDialog(context);
                                              if (snap.data[index]
                                                      ["how_it_works"] !=
                                                  null) {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return HowItWorks(
                                                        id: snap.data[index]
                                                            ["id"],
                                                        title: snap.data[index][
                                                            "api_title"
                                                                .tr()
                                                                .toString()],
                                                        category_id: widget
                                                                .data[
                                                            "category"]["id"],
                                                        content: snap
                                                                .data[index][
                                                            "how_it_works_${globals.lang.tr().toString()}"],
                                                        subcategoryId:
                                                            widget.data["id"],
                                                        breadcrumbs:
                                                            breadCrumbs,
                                                        photo_required: snap
                                                                .data[index]
                                                            ["photo_required"],
                                                      );
                                                    },
                                                  ),
                                                  // ModalRoute.withName(HomePage.routeName),
                                                ).then(onGoBack);
                                              } else {
                                                if (snap.data[index]["id"] ==
                                                        102 ||
                                                    snap.data[index]["id"] ==
                                                        35 ||
                                                    snap.data[index]["id"] ==
                                                        99 ||
                                                    widget.data["id"] == 66 ||
                                                    widget.data["id"] == 80) {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return CheckProblemCategory(
                                                          id: snap.data[index]
                                                              ["id"],
                                                          title: snap
                                                                  .data[index][
                                                              "api_title"
                                                                  .tr()
                                                                  .toString()],
                                                          category_id: widget
                                                                  .data[
                                                              "category"]["id"],
                                                          subcategoryId:
                                                              widget.data["id"],
                                                          breadcrumbs:
                                                              breadCrumbs,
                                                          photo_required: snap
                                                                  .data[index][
                                                              "photo_required"],
                                                        );
                                                      },
                                                    ),
                                                    // ModalRoute.withName(HomePage.routeName),
                                                  ).then(onGoBack);
                                                } else {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .push(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                          context) {
                                                        return ProblemDesc(
                                                          snap.data[index]
                                                              ["id"],
                                                          snap.data[index][
                                                              "api_title"
                                                                  .tr()
                                                                  .toString()],
                                                          widget.data[
                                                              "category"]["id"],
                                                          widget.data["id"],
                                                          breadCrumbs,
                                                          snap.data[index][
                                                              "photo_required"],
                                                        );
                                                      },
                                                    ),
                                                    // ModalRoute.withName(HomePage.routeName),
                                                  ).then(onGoBack);
                                                }
                                              }
                                            } else {
                                              customDialog(context);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 8),
                                            alignment: Alignment.centerLeft,
                                            height: 52,
                                            child: Text(
                                              snap.data[index]
                                                  ["api_title".tr().toString()],
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    dWidth * globals.fontSize14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: snap.data.length,
                              ),
                            )
                          : Center(
                              child: Text("Loading"),
                            );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
