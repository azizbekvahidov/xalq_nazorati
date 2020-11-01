import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/idea/idea_send_screen.dart';
import 'package:xalq_nazorati/widget/idea-widget/idea_head_card.dart';
import 'package:xalq_nazorati/widget/input/default_input.dart';
import '../main_page/problem/problem_locate.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/custom_dotted_circle_container.dart';
import '../../widget/default_button.dart';
import '../../widget/input/textarea_input.dart';
import '../../widget/text/main_text.dart';
import '../../widget/shadow_box.dart';

class IdeaAddScreen extends StatefulWidget {
  static const routeName = "/idea-add";
  final int id;
  IdeaAddScreen(this.id);
  @override
  _IdeaAddScreenState createState() => _IdeaAddScreenState();
}

class _IdeaAddScreenState extends State<IdeaAddScreen> {
  var ideaTitleController = TextEditingController();
  File image1;
  File image2;
  File image3;
  File image4;
  var descController = TextEditingController();

  Future sendData() async {}
  void clearImages() {
    setState(() {
      image1 = null;
      image2 = null;
      image3 = null;
      image4 = null;
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
        title: "Предложить идею",
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IdeaHeadCard(
                  widget.id,
                  "Гаражи и парковки",
                  "Предложения по улучшению детских площадок",
                  "assets/img/road.svg",
                  false),
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
                            MainText("Заголовок предлагаемой идеи"),
                            DefaultInput(
                              hint: "Предложить идею",
                              textController: ideaTitleController,
                              notifyParent: () {},
                            ),
                            MainText("Описать идею"),
                            TextareaInput(
                              hint: "Было бы лучше",
                              textareaController: descController,
                              notifyParent: () {},
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
                                      fontFamily: globals.font,
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
                                        fontFamily: globals.font),
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
                          child:
                              /*!_value
                              ? DefaultButton(
                                  "Продолжить",
                                  () {},
                                  Color(0xffB2B7D0),
                                )
                              : */
                              DefaultButton("Перейти в следующий шаг", () {
                            print("this image $image1");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return IdeaSendScreen(widget.id);
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
