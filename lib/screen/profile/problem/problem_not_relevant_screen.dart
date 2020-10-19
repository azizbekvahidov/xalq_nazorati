import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:xalq_nazorati/screen/profile/main_profile.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_screen.dart';
import '../../main_page/problem/problem_locate.dart';
import '../../../widget/app_bar/custom_appBar.dart';
import '../../../widget/custom_dotted_circle_container.dart';
import '../../../widget/default_button.dart';
import '../../../widget/input/textarea_input.dart';
import '../../../widget/text/main_text.dart';
import '../../../widget/shadow_box.dart';

class ProblemNotRelevantScreen extends StatefulWidget {
  static const routeName = "/problem-desc";
  final int id;
  ProblemNotRelevantScreen(this.id);
  @override
  _ProblemNotRelevantScreenState createState() =>
      _ProblemNotRelevantScreenState();
}

class _ProblemNotRelevantScreenState extends State<ProblemNotRelevantScreen> {
  File image1;
  File image2;
  File image3;
  File image4;
  var descController = TextEditingController();
  bool _value = false;

  Future insertData() async {
    try {
      var url2 = '${globals.api_link}/problems/cancel';

      var req = http.MultipartRequest("POST", Uri.parse(url2));
      req.headers.addAll({"Authorization": "token ${globals.token}"});
      req.fields.addAll({"problem_id": "${widget.id}"});
      req.fields.addAll({"reason": "${descController.text}"});
      if (globals.images['file1'] != null) {
        String _fileName = globals.images['file1'].path;
        req.files.add(http.MultipartFile(
            "file1",
            globals.images['file1'].readAsBytes().asStream(),
            globals.images['file1'].lengthSync(),
            filename: _fileName.split('/').last));
      }
      if (globals.images['file2'] != null) {
        String _fileName = globals.images['file2'].path;
        req.files.add(http.MultipartFile(
            "file2",
            globals.images['file2'].readAsBytes().asStream(),
            globals.images['file2'].lengthSync(),
            filename: _fileName.split('/').last));
      }
      if (globals.images['file3'] != null) {
        String _fileName = globals.images['file3'].path;
        req.files.add(http.MultipartFile(
            "file3",
            globals.images['file3'].readAsBytes().asStream(),
            globals.images['file3'].lengthSync(),
            filename: _fileName.split('/').last));
      }
      if (globals.images['file4'] != null) {
        String _fileName = globals.images['file4'].path;
        req.files.add(http.MultipartFile(
            "file4",
            globals.images['file4'].readAsBytes().asStream(),
            globals.images['file4'].lengthSync(),
            filename: _fileName.split('/').last));
      }
      var res = await req.send();

      if (res.statusCode == 200) {
        globals.images['file1'] = null;
        globals.images['file2'] = null;
        globals.images['file3'] = null;
        globals.images['file4'] = null;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return ProblemScreen("Нерешенные проблемы", "warning");
        }), (Route<dynamic> route) => true);
      } else {
        print(res);
      }
    } catch (e) {
      print(e);
    }
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
        title: "Проблема не актуальна",
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
                            MainText("Загрузите фото"),
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
                            MainText("Описать проблему"),
                            TextareaInput(
                                "Напишите о проблеме", descController),
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
                              DefaultButton("Снять с контроля", () {
                            insertData();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (BuildContext context) {
                            //   return ProblemLocate(
                            //       descController.text, widget.id);
                            // }));
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
