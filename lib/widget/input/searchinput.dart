import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:requests/requests.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/models/search-category.dart';
import 'package:xalq_nazorati/screen/main_page/category_screen.dart';
import 'package:xalq_nazorati/screen/main_page/problem/problem_desc.dart';
import 'package:xalq_nazorati/widget/get_login_dialog.dart';

class SearchInput extends StatefulWidget {
  final String hint;
  SearchInput(this.hint);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  var searchController = TextEditingController();

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
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: GetLoginDialog(),
            ),
          );
        });
  }

  var response;
  Future changeAddressMap(String value) async {
    try {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/search-category?q=$value';
      var r1 = await Requests.get(url);
      if (r1.statusCode == 200) {
        var json = r1.json();

        return generateCategoryList(json);

        // List<Addresses> addresses = parseAddress(json["data"]);
        // return addresses;
      } else {
        var json = r1.json();

        print(json);
      }
    } catch (e) {
      print(e);
    }
  }

  List<dynamic> generateCategoryList(var list) {
    var res = [];
    if (list['categories'].length != 0) {
      for (var i = 0; i < list["categories"].length; i++) {
        res.addAll([
          {
            "name": list["categories"][i]["api_title".tr().toString()],
            "id": list["categories"][i]["id"],
            "type": "categories",
            "breadcrumbs":
                "${list["categories"][i]["api_title".tr().toString()]}",
          }
        ]);
      }
    }
    if (list['subcategories'].length != 0) {
      for (var i = 0; i < list["subcategories"].length; i++) {
        res.addAll([
          {
            "name": list["subcategories"][i]["api_title".tr().toString()],
            "id": list["subcategories"][i]["id"],
            "type": "subcategories",
            "category_id": list["subcategories"][i]["category"]["id"],
            "category_name": list["subcategories"][i]["category"]
                ["api_title".tr().toString()],
            "breadcrumbs":
                "${list["subcategories"][i]["category"]["api_title".tr().toString()]} -> ${list["subcategories"][i]["api_title".tr().toString()]}",
          }
        ]);
      }
    }
    if (list['subsubcategories'].length != 0) {
      for (var i = 0; i < list["subsubcategories"].length; i++) {
        res.addAll([
          {
            "name": list["subsubcategories"][i]["api_title".tr().toString()],
            "id": list["subsubcategories"][i]["id"],
            "type": "subsubcategories",
            "category_id": list["subsubcategories"][i]["subcategory"]
                ["category"]["id"],
            "breadcrumbs":
                "${list["subsubcategories"][i]["subcategory"]["category"]["api_title".tr().toString()]} -> ${list["subsubcategories"][i]["subcategory"]["api_title".tr().toString()]} -> ${list["subsubcategories"][i]["api_title".tr().toString()]}",
          }
        ]);
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 20),
          margin: EdgeInsets.only(top: 10),
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xffF5F6F9),
            borderRadius: BorderRadius.circular(22.5),
            border: Border.all(
              color: Color.fromRGBO(178, 183, 208, 0.5),
              style: BorderStyle.solid,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 5),
                child: Icon(
                  Icons.search,
                  color: Color(0xffB2B7D0),
                  size: 26,
                ),
              ),
              Container(
                width: (mediaQuery.size.width -
                        mediaQuery.padding.left -
                        mediaQuery.padding.right) *
                    0.68,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hint.tr().toString(),
                    hintStyle: Theme.of(context).textTheme.display1.copyWith(
                        fontSize: mediaQuery.size.width * globals.fontSize18),
                  ),
                  onChanged: (val) {
                    print(val);
                  },
                ),

                // TypeAheadField(
                //   getImmediateSuggestions: true,
                //   textFieldConfiguration: TextFieldConfiguration(
                //     controller: searchController,
                //     autofocus: false,
                //     decoration: InputDecoration.collapsed(
                //       hintText: widget.hint.tr().toString(),
                //       hintStyle: Theme.of(context).textTheme.display1.copyWith(
                //           fontSize: mediaQuery.size.width * globals.fontSize18),
                //     ),
                //   ),
                //   hideOnEmpty: false,
                //   suggestionsCallback: (pattern) async {
                //     if (pattern.length >= 3) {
                //       return await changeAddressMap(pattern);
                //     } else
                //       return null;
                //   },
                //   noItemsFoundBuilder: (context) {
                //     return Text("not_found".tr().toString());
                //   },
                //   suggestionsBoxDecoration: SuggestionsBoxDecoration(),
                //   itemBuilder: (context, suggestion) {
                //     print(suggestion);
                //     return InkWell(
                //       onTap: () {
                //         if (suggestion["type"] == "categories") {
                //           searchController.text = "";
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (BuildContext context) {
                //                 return CategoryScreen(
                //                   title: suggestion["name"],
                //                   id: suggestion["id"],
                //                 );
                //               },
                //             ),
                //           );
                //         }
                //         if (suggestion["type"] == "subcategories") {
                //           searchController.text = "";
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (BuildContext context) {
                //                 return CategoryScreen(
                //                   title: suggestion["category_name"],
                //                   id: suggestion["category_id"],
                //                   subcategoryId: suggestion["id"],
                //                 );
                //               },
                //             ),
                //           );
                //         }
                //         if (suggestion["type"] == "subsubcategories") {
                //           searchController.text = "";
                //           if (globals.token != null) {
                //             Navigator.of(context, rootNavigator: true).push(
                //               MaterialPageRoute(
                //                 builder: (BuildContext context) {
                //                   return ProblemDesc(
                //                       suggestion["id"],
                //                       suggestion["name"],
                //                       suggestion["category_id"]);
                //                 },
                //               ),
                //             ).then(onGoBack);
                //           } else {
                //             customDialog(context);
                //           }
                //         }
                //       },
                //       child: Container(
                //         width: mediaQuery.size.width,
                //         child: ListTile(
                //           title: Container(
                //               child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Container(
                //                 padding: EdgeInsets.only(top: 12),
                //                 child: Text(
                //                   suggestion["name"],
                //                   style: TextStyle(
                //                     fontFamily: globals.font,
                //                     fontSize:
                //                         mediaQuery.size.width * globals.fontSize14,
                //                     color: Colors.black,
                //                     fontWeight: FontWeight.w500,
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 padding: EdgeInsets.symmetric(vertical: 5),
                //                 child: Text(
                //                   suggestion["breadcrumbs"],
                //                   style: TextStyle(
                //                     fontFamily: globals.font,
                //                     fontSize:
                //                         mediaQuery.size.width * globals.fontSize12,
                //                     color: Color.fromRGBO(102, 103, 108, 0.7),
                //                     fontWeight: FontWeight.w400,
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 height: 1,
                //                 decoration: BoxDecoration(
                //                     border: Border.all(
                //                   color: Color(0xffB2B7D0),
                //                 )),
                //               )
                //             ],
                //           )),
                //         ),
                //       ),
                //     );
                //   },
                //   onSuggestionSelected: (suggestion) {
                //     print(suggestion);
                //     // getLocateFromAddress(suggestion.title);
                //     // searchController.text = suggestion.title;
                //   },
                // ),
              ),
            ],
          ),
        ),
        Positioned(
            child: Container(
          width: mediaQuery.size.width,
          height: 300,
        ))
      ],
    );
  }
}
