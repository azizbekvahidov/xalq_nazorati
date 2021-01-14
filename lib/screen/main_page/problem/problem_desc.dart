import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final int categoryId;
  final int subcategoryId;
  final String breadCrumbs;
  ProblemDesc(this.id, this.title, this.categoryId, this.subcategoryId,
      this.breadCrumbs);
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
  FocusNode descNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // getPermission();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: descNode, toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
      ],
    );
  }

  getPermission() async {
    var status = await Permission.camera.status;
    if (status.isUndetermined || status.isDenied) {
      Permission.camera.request();
      // We didn't ask for permission yet.
    }

    status = await Permission.mediaLibrary.status;
    if (status.isUndetermined || status.isDenied) {
      Permission.mediaLibrary.request();
      // We didn't ask for permission yet.
    }
  }

  Future sendData() async {}
  void clearImages() {
    setState(() {
      globals.images.addAll({
        "file1": null,
        "file2": null,
        "file3": null,
        "file4": null,
      });
      globals.userLocation = null;
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
    var dWidth = mediaQuery.size.width;

    final size = (mediaQuery.size.width -
                mediaQuery.padding.left -
                mediaQuery.padding.right) /
            4 -
        25;
    return Scaffold(
      appBar: CustomAppBar(
        title: "desc_provlem".tr().toString(),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            // height: mediaQuery.size.height < 560
            //     ? mediaQuery.size.height
            //     : mediaQuery.size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShadowBox(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: 420, maxHeight: 465),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: KeyboardActions(
                              disableScroll: true,
                              isDialog: true,
                              config: _buildConfig(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      widget.breadCrumbs,
                                      style: TextStyle(
                                        color:
                                            Color.fromRGBO(102, 103, 108, 0.7),
                                        fontFamily: globals.font,
                                        fontSize: dWidth * globals.fontSize12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  MainText("problem_describe".tr().toString()),
                                  TextareaInput(
                                    hint:
                                        "problem_describe_hint".tr().toString(),
                                    textareaController: descController,
                                    notifyParent: checkChange,
                                    descNode: descNode,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MainText("upload_photo".tr().toString()),
                                      InkWell(
                                        onTap: () {
                                          clearImages();
                                        },
                                        child: Text(
                                          "clear".tr().toString(),
                                          style: TextStyle(
                                            color: Color(0xffB2B7D0),
                                            fontSize:
                                                dWidth * globals.fontSize14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: globals.font,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SvgPicture.asset(
                                            "assets/img/warning.svg"),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Text(
                                          "upload_warning".tr().toString(),
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
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: mediaQuery.size.height - mediaQuery.size.height < 560
                      ? mediaQuery.size.height * 0.2
                      : mediaQuery.size.height * 0.68,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: !_value
                                ? DefaultButton(
                                    "add_problem".tr().toString(),
                                    () {},
                                    Color(0xffB2B7D0),
                                  )
                                : DefaultButton("continue".tr().toString(), () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return ProblemLocate(
                                          descController.text,
                                          widget.id,
                                          widget.categoryId,
                                          widget.subcategoryId,
                                          widget.breadCrumbs);
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
      ),
    );
  }
}
