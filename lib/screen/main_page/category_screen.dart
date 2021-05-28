import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/models/sub_category.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/expanse_list_lile.dart';

_CategoryScreenState categoryScreenState;

class CategoryScreen extends StatefulWidget {
  static const routeName = "/category-screen";
  final String title;
  final int id;
  final int subcategoryId;

  CategoryScreen({this.title, this.id, this.subcategoryId, Key key})
      : super(key: key);

  @override
  _CategoryScreenState createState() {
    categoryScreenState = _CategoryScreenState();
    return categoryScreenState;
  }
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int _index = 0;
  Future<dynamic> _subCategories;

  Future<List> getCategory() async {
    var connect = new DioConnection();
    Map<String, String> headers = {};
    var response = await connect.getHttp(
        '/problems/subcategories/${widget.id}', categoryScreenState, headers);

    var reply = response["result"];

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
    if (globals.subcategoryList.isEmpty) {
      if (globals.subcategoryList[widget.id] == null) {
        _subCategories = getCategory();
        globals.subcategoryList.addAll({widget.id: _subCategories});
      } else {
        _subCategories = globals.subcategoryList[widget.id];
      }
    } else {
      if (globals.subcategoryList[widget.id] == null) {
        _subCategories = getCategory();
        globals.subcategoryList.addAll({widget.id: _subCategories});
      } else {
        _subCategories = globals.subcategoryList[widget.id];
      }
    }
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
      isScroll = true;
      if (isScroll == true) {
        Timer(Duration(seconds: 1), () {
          itemScrollController.scrollTo(
              index: _index, duration: Duration(milliseconds: 500));
        });
        Timer(Duration(milliseconds: 10), () {
          itemScrollController.scrollTo(
              index: _index, duration: Duration(milliseconds: 500));
        });
        timers.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
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
                          future: _subCategories,
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
                                          category_title: widget.title,
                                        );
                                      },
                                      itemScrollController:
                                          itemScrollController,
                                      itemPositionsListener:
                                          itemPositionsListener,
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
          CheckConnection(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
