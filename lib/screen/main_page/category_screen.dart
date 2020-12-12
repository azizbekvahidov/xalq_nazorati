import 'dart:async';
import 'dart:convert';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:requests/requests.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/models/sub_category.dart';
import 'package:xalq_nazorati/widget/category/sub_categories_list.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/expanse_list_lile.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/category-screen";
  final String title;
  final int id;
  final int subcategoryId;

  CategoryScreen({this.title, this.id, this.subcategoryId, Key key})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int _index = 0;

  Future<List> getCategory() async {
    var url = '${globals.api_link}/problems/subcategories/${widget.id}';

    // Map<String, String> headers = {"Authorization": "token ${globals.token}"};

    var response = await Requests.get(url);

    var reply = response.json();

    return reply;
  }

  @override
  void dispose() {
    timers?.cancel();
    super.dispose();
  }

  bool isExpanded = false;
  Timer timers;
  bool isScroll = false;
  @override
  void initState() {
    super.initState();
    timers = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      scrollToIndex();
    });
  }

  List<SubCategories> parseCategory(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<SubCategories>((json) => SubCategories.fromJson(json))
        .toList();
  }

  scrollToIndex() {
    if (_index != 0) {
      if (isScroll != true) {
        Timer(Duration(seconds: 2), () {
          itemScrollController.scrollTo(
              index: _index, duration: Duration(milliseconds: 100));
        });
        isScroll = true;
        timers.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF5F6F9),
        appBar: CustomAppBar(
          title: widget.title,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: mediaQuery.size.height - mediaQuery.size.height * 0.12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: FutureBuilder(
                      future: getCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? Container(
                                height: mediaQuery.size.height * 0.78,
                                child: ScrollablePositionedList.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    if (widget.subcategoryId != null) {
                                      if (snapshot.data[index]["id"] ==
                                          widget.subcategoryId) {
                                        _index = index;
                                        // print(index);
                                        // itemScrollController.jumpTo(
                                        //     index: index);
                                      }
                                    }
                                    return ExpanseListTile(
                                      data: snapshot.data[index],
                                      subcategoryId: widget.subcategoryId,
                                    );
                                  },
                                  itemScrollController: itemScrollController,
                                  itemPositionsListener: itemPositionsListener,
                                ),
                              )
                            : Center(
                                child: Text("Loading"),
                              );
                      }),
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
