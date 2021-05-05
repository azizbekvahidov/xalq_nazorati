import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/to_file.dart';
import 'package:xalq_nazorati/models/problems.dart';
import 'package:xalq_nazorati/models/result.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_solved_decline_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_solved_rate_screen.dart';
import 'package:xalq_nazorati/tetris/generated/i18n.dart';
import 'package:xalq_nazorati/widget/problems/image_carousel.dart';
import 'package:xalq_nazorati/widget/problems/pdf_widget.dart';
import 'package:xalq_nazorati/widget/problems/problem_solve_desc.dart';
import 'package:xalq_nazorati/widget/res_content.dart';
import 'package:xalq_nazorati/widget/success_box.dart';
import '../../../widget/app_bar/custom_appBar.dart';
import '../../../widget/shadow_box.dart';

class SolveProblemScreen extends StatefulWidget {
  final String status;
  final int id;
  final String stat;
  SolveProblemScreen({this.status, this.id, this.stat});
  @override
  _SolveProblemScreenState createState() => _SolveProblemScreenState();
}

class _SolveProblemScreenState extends State<SolveProblemScreen> {
  ToFile to_file = ToFile();
  List files;
  DateTime time;
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> getProblem(var id) async {
    try {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/problem/$id';
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await Requests.get(url, headers: headers);

      // String reply = await response.transform(utf8.decoder).join();
      // var temp = response.json();
      var res = response.json(); //parseProblems(response.content());
      if (widget.stat == "info") {
        var deadline = DateTime.parse(res["result"]["updated_at"]);

        time = (deadline.add(Duration(days: 7)));
      }
      if (res["result"] != null) {
        url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/results/check';
        Map<String, dynamic> data = {"id": res["result"]["id"]};
        var resp = await Requests.post(url, body: data, headers: headers);
        if (resp.statusCode == 200) {
          globals.cardAlert[widget.id]["res_seen"] = false;
          globals.checkCardAler(widget.id);
        }
        var deadline = DateTime.parse(res["result"]["updated_at"]);

        time = (deadline.add(Duration(days: 7)));
      }

      if (res["problem"]["reason_of_moving_to_planned"] != null) {
        url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/results/check';
        Map<String, dynamic> data = {
          "id": res["problem"]["reason_of_moving_to_planned"]["id"]
        };
        var resp = await Requests.post(url, body: data, headers: headers);
        if (resp.statusCode == 200) {
          globals.cardAlert[widget.id]["res_seen"] = false;
          globals.checkCardAler(widget.id);
        }
      }

      // String reply = await response.transform(utf8.decoder).join();
      // var temp = response.json();
      return res;
    } catch (e) {
      print(e);
    }
  }

  List analyzeImages(var res) {
    List files = [];
    List<String> images = [];
    if (res["file_1"] != null) {
      images.add("${globals.site_link}${res["file_1"]}");
    }
    if (res["file_2"] != null) {
      images.add("${globals.site_link}${res["file_2"]}");
    }
    if (res["file_3"] != null) {
      images.add("${globals.site_link}${res["file_3"]}");
    }
    if (res["file_4"] != null) {
      images.add("${globals.site_link}${res["file_4"]}");
    }
    if (res["file_5"] != null) {
      images.add("${globals.site_link}${res["file_5"]}");
    }
    return images;
  }

  List analyzeFiles(var res) {
    List files = [];
    List<String> images = [];
    int f_i = 0;
    int i_i = 0;
    if (res["file_1"] != null) {
      String uri = "${globals.site_link}${res["file_1"]}";
      var ext = res["file_1"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_1"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_1"]);
      }
    }
    if (res["file_2"] != null) {
      String uri = "${globals.site_link}${res["file_2"]}";
      var ext = res["file_2"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_2"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_2"]);
      }
    }
    if (res["file_3"] != null) {
      String uri = "${globals.site_link}${res["file_3"]}";
      var ext = res["file_3"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_3"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_3"]);
      }
    }
    if (res["file_4"] != null) {
      String uri = "${globals.site_link}${res["file_4"]}";
      var ext = res["file_4"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_4"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_4"]);
      }
    }
    if (res["file_5"] != null) {
      String uri = "${globals.site_link}${res["file_5"]}";
      var ext = res["file_5"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_5"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_5"]);
      }
    }
    if (res["file_6"] != null) {
      String uri = "${globals.site_link}${res["file_6"]}";
      var ext = res["file_6"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_6"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_6"]);
      }
    }
    if (res["file_7"] != null) {
      String uri = "${globals.site_link}${res["file_7"]}";
      var ext = res["file_7"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_7"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_7"]);
      }
    }
    if (res["file_8"] != null) {
      String uri = "${globals.site_link}${res["file_8"]}";
      var ext = res["file_8"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_8"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_8"]);
      }
    }
    if (res["file_9"] != null) {
      String uri = "${globals.site_link}${res["file_9"]}";
      var ext = res["file_9"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_9"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_9"]);
      }
    }
    if (res["file_10"] != null) {
      String uri = "${globals.site_link}${res["file_10"]}";
      var ext = res["file_10"].split(".").last;
      if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'gif') {
        images.add("${globals.site_link}${res["file_10"]}");
      } else if (ext == 'pdf') {
        files.add(res["file_10"]);
      }
    }
    return [images, files];
  }

  Problems parseProblems(String responseBody) {
    final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

    return parsed.map<Problems>((json) => Problems.fromJson(json));
  }

  Result parseresult(String responseBody) {
    final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

    return parsed.map<Result>((json) => Result.fromJson(json));
  }

  DateFormat dateF = DateFormat('dd.MM.yyyy');
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var dWidth = mediaQuery.size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: "result".tr().toString(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
          future: getProblem(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            // print(snapshot.data["result"]);
            var _widget;
            if (snapshot.hasData) {
              var res = snapshot.data;
              var result = res['result'];
              var executors = result != null ? res['problem']['closed_by'] : {};
              List _files = result != null ? analyzeFiles(result) : [];
              List _images = res != null ? analyzeImages(res["problem"]) : [];
              print(res["moderator_log"]);
              var res_widget = result != null
                  ? Column(
                      children: [
                        ShadowBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 19, top: 5, right: 19, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "executor".tr().toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                fontSize:
                                                    dWidth * globals.fontSize12,
                                                fontWeight: FontWeight.w400,
                                                fontFeatures: [
                                                  FontFeature.enable("pnum"),
                                                  FontFeature.enable("lnum")
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 10),
                                            ),
                                            Text(
                                              "${globals.capitalize(executors['last_name'])} ${globals.capitalize(executors['name'])}",
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                fontSize:
                                                    dWidth * globals.fontSize14,
                                                fontWeight: FontWeight.w600,
                                                fontFeatures: [
                                                  FontFeature.enable("pnum"),
                                                  FontFeature.enable("lnum")
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "execute_date".tr().toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                fontSize:
                                                    dWidth * globals.fontSize12,
                                                fontWeight: FontWeight.w400,
                                                fontFeatures: [
                                                  FontFeature.enable("pnum"),
                                                  FontFeature.enable("lnum")
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 10),
                                            ),
                                            Text(
                                              "${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(result['created_at']).toString()))}",
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                fontSize:
                                                    dWidth * globals.fontSize14,
                                                fontWeight: FontWeight.w600,
                                                fontFeatures: [
                                                  FontFeature.enable("pnum"),
                                                  FontFeature.enable("lnum")
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      width: dWidth * 0.8,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "${res["closed_by"]['organization']}, ${res["closed_by"]['district']} ${res["closed_by"]['position']}",
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWidth * globals.fontSize10,
                                          fontWeight: FontWeight.w400,
                                          fontFeatures: [
                                            FontFeature.enable("pnum"),
                                            FontFeature.enable("lnum")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 19),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "solve_description".tr().toString(),
                                      style: TextStyle(
                                        fontFamily: globals.font,
                                        fontSize: dWidth * globals.fontSize12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                    Text(
                                      "${result['content']}",
                                      style: TextStyle(
                                        fontFamily: globals.font,
                                        fontSize: dWidth * globals.fontSize14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _files[1].length != 0 ? Divider() : Container(),
                              _files[1].length != 0
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 19),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "docs".tr().toString(),
                                            style: TextStyle(
                                              fontFamily: globals.font,
                                              fontSize:
                                                  dWidth * globals.fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                          ),
                                          Container(
                                            height: 80,
                                            child: GridView.builder(
                                              padding: EdgeInsets.all(0),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 4,
                                              ),
                                              itemCount: _files[1].length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return PdfWidget(
                                                    _files[1][index],
                                                    "${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(result['created_at']).toString()))}");
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              _files[0].length != 0 && _images.length != 0
                                  ? Divider()
                                  : Container(),
                              _files[0].length != 0 && _images.length != 0
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: ImageCarousel(
                                        "was".tr().toString(),
                                        _images,
                                      ),
                                    )
                                  : Container(),
                              _files[0].length != 0 ? Divider() : Container(),
                              _files[0].length != 0
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: ImageCarousel(
                                          "be".tr().toString(), _files[0]),
                                    )
                                  : Container(),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, left: 19, right: 19),
                                child: Column(
                                  children: [
                                    ProblemSolveDesc("request".tr().toString(),
                                        "№${res["problem"]["id"]} от ${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(res["problem"]["created_at"]).toString()))}"),
                                    ProblemSolveDesc("problem".tr().toString(),
                                        "${res["problem"]["subsubcategory"]["api_title".tr().toString()]}"),
                                    ProblemSolveDesc("place".tr().toString(),
                                        "${res["problem"]["address"].replaceAll(new RegExp(r"\s+"), " ")}, ${res["problem"]["note"] != null ? res["problem"]["note"] : ""}"),
                                    ProblemSolveDesc(
                                      "solved_status".tr().toString(),
                                      "${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(result['created_at']).toString()))}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.stat == 'completed'
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 19),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: FlatButton(
                                        color: globals.activeButtonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(34),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return ProblemSolvedRateScreen(
                                              widget.id,
                                              "${globals.capitalize(executors['last_name'])} ${globals.capitalize(executors['name'])}",
                                              null, // executors['user']['avatar'],
                                              executors['id'],
                                              res["closed_by"]['position']
                                                  .toString(),
                                              // executors['position'][
                                              //     "title_${(globals.lang).tr().toString()}"],
                                            );
                                          }));
                                        },
                                        child: Text(
                                          "accept".tr().toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                fontSize:
                                                    dWidth * globals.fontSize18,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(34),
                                        border: Border.all(
                                          color: Color(0xffB2B7D0),
                                          width: 1,
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: 50,
                                      child: FlatButton(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(34),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return ProblemSolvedDeclineScreen(
                                              widget.id,
                                              "${globals.capitalize(executors['last_name'])} ${globals.capitalize(executors['name'])}",
                                              null, // executors['user']['avatar'],
                                              executors['id'],
                                              res["closed_by"]['position']
                                                  .toString(),
                                              // [
                                              //     "title_${(globals.lang).tr().toString()}"]
                                            );
                                          }));
                                        },
                                        child: Text(
                                          "deny".tr().toString(),
                                          style: TextStyle(
                                              fontSize:
                                                  dWidth * globals.fontSize18,
                                              fontFamily: globals.font,
                                              color: Color(0xffB2B7D0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                  : widget.stat != "denied" &&
                          widget.stat != "closed" &&
                          widget.stat != "canceled" &&
                          widget.stat != "planned"
                      ? Container(
                          height: mediaQuery.size.height * 0.8,
                          width: mediaQuery.size.width,
                          child: Center(
                            child: Text("solve_warning".tr().toString()),
                          ),
                        )
                      : Container();

              var res_header = result != null ||
                      res["problem"]["unsatisfactory_solution"] != null ||
                      res["moderator_log"] != null ||
                      res["problem"]["user_cancellation_reason"] != null
                  ? Column(
                      children: [
                        SuccessBox(
                          children: Text(
                            "${widget.stat}_solve".tr().toString(),
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: dWidth * globals.fontSize18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        (widget.status == "info")
                            ? SuccessBox(
                                children: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/img/info.svg",
                                      height: 36,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10)),
                                    Container(
                                      width: dWidth * 0.77,
                                      child: RichText(
                                        text: TextSpan(
                                          text:
                                              "${"start_solved_info".tr().toString()}\"${dateF.format(time)}\"${"end_solved_info".tr().toString()}",
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            color: Color(0xff050505),
                                            fontSize:
                                                dWidth * globals.fontSize18,
                                            fontWeight: FontWeight.w600,
                                            fontFeatures: [
                                              FontFeature.enable("pnum"),
                                              FontFeature.enable("lnum")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                  : widget.stat == 'planned'
                      ? SuccessBox(
                          children: Text(
                            "${widget.stat}_solve".tr().toString(),
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: dWidth * globals.fontSize18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container();
              var answers = Column(children: [
                widget.stat == "denied" ||
                        widget.stat == "closed" ||
                        widget.stat == "canceled" ||
                        widget.stat == 'planned'
                    ? widget.stat == "canceled"
                        ? ShadowBox(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            res["problem"]
                                                    ["user_cancellation_reason"]
                                                ["reason"],
                                            style: TextStyle(
                                              fontFamily: globals.font,
                                              fontSize:
                                                  dWidth * globals.fontSize14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : widget.stat == "planned"
                            ? ShadowBox(
                                child: ResContent(
                                  titleCol:
                                      "${globals.capitalize(res["problem"]["reason_of_moving_to_planned"]["executor"]["user"]["last_name"])} ${globals.capitalize(res["problem"]["reason_of_moving_to_planned"]["executor"]["user"]["first_name"])}",
                                  dateCol:
                                      "${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(res["problem"]['updated_at']).toString()))}",
                                  positionCol:
                                      "${res["problem"]["reason_of_moving_to_planned"]["executor"]["organization"]["api_title".tr().toString()]}, ${res["problem"]["reason_of_moving_to_planned"]["executor"]["district"]["name_" + globals.lang.tr().toString()]} ${res["problem"]["reason_of_moving_to_planned"]["executor"]["position"]["api_title".tr().toString()]}",
                                  contentCol: res["problem"]
                                      ["reason_of_moving_to_planned"]["reason"],
                                  files: analyzeFiles(res["problem"]
                                      ["reason_of_moving_to_planned"]),
                                ),
                              )
                            : res["moderator_log"] != null
                                ? ShadowBox(
                                    child: ResContent(
                                      titleCol:
                                          "${globals.capitalize(res["moderator_log"]["moderator"]["last_name"])} ${globals.capitalize(res["moderator_log"]["moderator"]["first_name"])}",
                                      dateCol:
                                          "${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(res["moderator_log"]['updated_at']).toString()))}",
                                      positionCol: "moderator".tr().toString(),
                                      contentCol: widget.stat == "denied" ||
                                              widget.stat == "closed"
                                          ? widget.stat == "closed"
                                              ? res["problem"]
                                                  ["moderator_closing_reason"]
                                              : res["problem"][
                                                  "moderator_cancellation_reason"]
                                          : "",
                                    ),
                                  )
                                : Container()
                    : Container(),
                // res["problem"]["unsatisfactory_solution"] != null
                //     ? ShadowBox(
                //         child: ResContent(
                //           titleCol:
                //               "${globals.capitalize(res["problem"]["user"]['last_name'])} ${globals.capitalize(res["problem"]["user"]['first_name'])}",
                //           dateCol:
                //               "${dateF.format(DateTime.parse(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(res["problem"]['updated_at']).toString()))}",
                //           positionCol: "liver".tr().toString(),
                //           contentCol: res["problem"]["unsatisfactory_solution"]
                //               ["reason"],
                //         ),
                //       )
                //     : Container(),
              ]);

              _widget = Column(
                children: [
                  res_header,
                  answers,
                  res_widget,
                ],
              );
            } else {
              _widget = Center(
                child: Text("Loading".tr().toString()),
              );
            }

            return _widget;
          },
        ),
      ),
    );
  }
}
