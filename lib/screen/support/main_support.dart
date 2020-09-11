import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/screen/support/support_feedback.dart';
import 'package:xalq_nazorati/screen/support/support_info.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_icon_appbar.dart';

class MainSupport extends StatefulWidget {
  @override
  _MainSupportState createState() => _MainSupportState();
}

class _MainSupportState extends State<MainSupport> {
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
    return Scaffold(
      appBar: CustomIconAppBar(
        title: "Связаться с нами",
        icon: "assets/img/support.svg",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
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
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: _bg1,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Позвоните",
                        style: TextStyle(
                          color: _txt1,
                          fontFamily: "Gilroy",
                          fontSize: 18,
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
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: _bg2,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Напишите",
                        style: TextStyle(
                          color: _txt2,
                          fontFamily: "Gilroy",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                child: _children[_index],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
