import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/profile/problem/problem_screen_custom.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:easy_localization/easy_localization.dart';

class OpenProblemScreen extends StatefulWidget {
  final String title;
  final String status;
  OpenProblemScreen({this.status, this.title, Key key}) : super(key: key);

  @override
  _OpenProblemScreenState createState() => _OpenProblemScreenState();
}

class _OpenProblemScreenState extends State<OpenProblemScreen> {
  int _index = 0;
  Color _bg1;
  Color _txt1;
  Color _bg2;
  Color _txt2;
  final List<Widget> _children = [
    Container(
      child: Text("first"),
    ),
    Container(
      child: Text("second"),
    )
    // ProblemScreenCustom(title: "unresolved".tr().toString(), status: "warning"),
    // ProblemScreenCustom(
    //     title: "delayed_problems".tr().toString(), status: "delayed"),
  ];

  void _selectTab(index) {
    setState(() {
      _index = index;
      if (index == 0) {
        _bg1 = Theme.of(context).primaryColor;
        _bg2 = Color.fromRGBO(49, 59, 108, 0.05);
        _txt1 = Colors.white;
        _txt2 = Color(0xff66676C);
      } else {
        _bg1 = Color.fromRGBO(49, 59, 108, 0.05);
        _bg2 = Theme.of(context).primaryColor;
        _txt1 = Color(0xff66676C);
        _txt2 = Colors.white;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectTab(_index));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "unresolved".tr().toString(),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _selectTab(0);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _bg1,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "in_proccess".tr().toString(),
                              style: TextStyle(
                                color: _txt1,
                                fontFamily: globals.font,
                                fontSize: width * globals.fontSize16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectTab(1);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _bg2,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "delayed".tr().toString(),
                              style: TextStyle(
                                color: _txt2,
                                fontFamily: globals.font,
                                fontSize: width * globals.fontSize16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: dHeight <= 560 ? dHeight - 160 : dHeight - 230,
                  child: _children[_index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
