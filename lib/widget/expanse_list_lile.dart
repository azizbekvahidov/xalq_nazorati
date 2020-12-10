import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';
import 'package:xalq_nazorati/widget/custom_expansion_tile.dart' as custom;
import 'package:xalq_nazorati/widget/get_login_dialog.dart';

class ExpanseListTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final int subcategoryId;
  ExpanseListTile({this.data, this.subcategoryId, Key key}) : super(key: key);

  @override
  _ExpanseListTileState createState() => _ExpanseListTileState();
}

class _ExpanseListTileState extends State<ExpanseListTile> {
  bool isExpanded;

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
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: GetLoginDialog(),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpanded = false;
    print(widget.data["id"]);
    print(widget.subcategoryId);
    if (widget.subcategoryId != null) {
      if (widget.data["id"] == widget.subcategoryId) {
        setState(() {
          isExpanded = true;
        });
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
                fontSize: mediaQuery.size.width < 360 ? 16 : 18,
              ),
            )),
        iconColor: isExpanded ? Colors.white : Colors.black,
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        initiallyExpanded: isExpanded,
        headerBackgroundColor: Colors.transparent,
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                child: FutureBuilder(
                    future: getSubCategory(widget.data["id"]),
                    builder: (context, snap) {
                      if (snap.hasError) print(snap.error);
                      return snap.hasData
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: 69.0 * snap.data.length,
                                  minHeight: 56.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (globals.token != null) {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return ProblemDesc(
                                                        snap.data[index]["id"],
                                                        snap.data[index][
                                                            "api_title"
                                                                .tr()
                                                                .toString()],
                                                        widget.data["category"]
                                                            ["id"]);
                                                  },
                                                ),
                                                // ModalRoute.withName(HomePage.routeName),
                                              ).then(onGoBack);
                                            } else {
                                              customDialog(context);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 8),
                                            alignment: Alignment.centerLeft,
                                            height: 40,
                                            child: Text(
                                              snap.data[index]
                                                  ["api_title".tr().toString()],
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    mediaQuery.size.width < 360
                                                        ? 14
                                                        : 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(),
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
