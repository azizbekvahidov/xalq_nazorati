import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import '../../main_page/problem/problem_locate.dart';
import '../../../widget/app_bar/custom_appBar.dart';
import '../../../widget/custom_dotted_circle_container.dart';
import '../../../widget/default_button.dart';
import '../../../widget/input/textarea_input.dart';
import '../../../widget/text/main_text.dart';
import '../../../widget/shadow_box.dart';

class ProblemDesc extends StatefulWidget {
  static const routeName = "/problem-desc";
  final int id;
  final String title;
  ProblemDesc(this.id, this.title);
  @override
  _ProblemDescState createState() => _ProblemDescState();
}

class _ProblemDescState extends State<ProblemDesc> {
  File image1;
  File image2;
  File image3;
  File image4;
  var descController = TextEditingController();
  bool _value = false;

  Future sendData() async {}
  void clearImages() {
    setState(() {
      image1 = null;
      image2 = null;
      image3 = null;
      image4 = null;
    });
  }

  checkChange() {
    String descValue = descController.text;
    setState(() {
      if (descValue != "")
        _value = true;
      else
        _value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final size = (mediaQuery.size.width -
                mediaQuery.padding.left -
                mediaQuery.padding.right) /
            4 -
        25;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Опишите проблему",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: mediaQuery.size.height - mediaQuery.size.height * 0.17,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShadowBox(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("Описать проблему"),
                            TextareaInput(
                              hint: "Напишите о проблеме",
                              textareaController: descController,
                              notifyParent: checkChange,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MainText("Загрузите фото"),
                                InkWell(
                                  onTap: () {
                                    clearImages();
                                  },
                                  child: Text(
                                    "Очистить",
                                    style: TextStyle(
                                      color: Color(0xffB2B7D0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20, bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomDottedCircleContainer(
                                      size, image1, "file1"),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  CustomDottedCircleContainer(
                                      size, image2, "file2"),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  CustomDottedCircleContainer(
                                      size, image3, "file3"),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                  CustomDottedCircleContainer(
                                      size, image4, "file4"),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SvgPicture.asset(
                                      "assets/img/warning.svg"),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: Text(
                                    "Размер одного файла не должен превышать 10 Мб, в количестве не более 4 файлов",
                                    style: TextStyle(
                                        color: Color(0xffFF8F27),
                                        fontSize: 12,
                                        fontFamily: "Gilroy"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: !_value
                              ? DefaultButton(
                                  "Продолжить",
                                  () {},
                                  Color(0xffB2B7D0),
                                )
                              : DefaultButton("Продолжить", () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ProblemLocate(
                                        descController.text, widget.id);
                                  }));
                                }, Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
