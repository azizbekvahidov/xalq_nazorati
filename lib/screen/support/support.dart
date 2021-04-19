import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/support/support_feedback.dart';
import 'package:xalq_nazorati/screen/support/support_info.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  int _index = 0;
  Color _bg1;
  Color _txt1;
  Color _bg2;
  Color _txt2;
  final List<Widget> _children = [
    SupportInfo(),
    SupportFeedback(),
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "technical_support".tr().toString(),
        // icon: "assets/img/support.svg",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
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
                              "call".tr().toString(),
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
                              "send_message".tr().toString(),
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
                  height: dHeight <= 560 ? dHeight - 160 : dHeight - 290,
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
