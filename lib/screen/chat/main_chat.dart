import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/chatMessage.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/chat_box.dart';
import 'package:xalq_nazorati/widget/full_screen.dart';
import 'package:xalq_nazorati/widget/problems/pdf_view.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MainChat extends StatefulWidget {
  final int id;
  final String status;
  MainChat(this.id, this.status);
  @override
  _MainChatState createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  var messageController = TextEditingController();
  bool _first = false;
  Timer timer;
  List<ChatMessage> _data;
  File _file = null;
  bool _isHide = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      refreshChat();
    });
    if (widget.status == "canceled" ||
        widget.status == "confirmed" ||
        widget.status == "denied" ||
        widget.status == "closed") {
      setState(() {
        _isHide = true;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<List<ChatMessage>> getAllMessage() async {
    try {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/chat/${widget.id}';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);

      String reply = await response.transform(utf8.decoder).join();

      var temp = parseMessages(reply);
      temp.firstWhere((element) {
        checkMessage(element.id);
        return true;
      });
      if (!_first) _first = !_first;
      return temp;
    } catch (e) {
      print(e);
    }
  }

  Future refreshChat() async {
    try {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/refresh-chat?problem_id=${widget.id}';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);

      String reply = await response.transform(utf8.decoder).join();

      var temp = parseMessages(reply);
      temp.firstWhere((element) {
        checkMessage(element.id);
        return true;
      });
      setState(() {
        _data.add(temp[0]);
      });
    } catch (e) {
      print(e);
    }
  }

  Future checkMessage(int id) async {
    try {
      var url =
          '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/check-message?message_id=${id}';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);
      if (response.statusCode == 200) {
        globals.cardAlert[widget.id]["chat_cnt"] = 0;
        globals.checkCardAler(widget.id);
      }
      String reply = await response.transform(utf8.decoder).join();
    } catch (e) {
      print(e);
    }
  }

  List<ChatMessage> parseMessages(String responseBody) {
    final parsed = (json.decode(responseBody).cast<Map<String, dynamic>>());

    return parsed
        .map<ChatMessage>((json) => ChatMessage.fromJson(json))
        .toList();
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    return result;
  }

  bool isSended = false;

  Future sendMessage() async {
    if ((messageController.text != "" && isSended == false) ||
        (_file != null && isSended == false)) {
      isSended = true;
      try {
        var url2 =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/chat';

        var req = http.MultipartRequest("POST", Uri.parse(url2));
        req.headers.addAll({"Authorization": "token ${globals.token}"});
        req.fields.addAll({"problem_id": "${widget.id}"});
        req.fields.addAll({"message": "${messageController.text}"});
        if (_file != null) {
          String _fileName = _file.path;
          req.files.add(http.MultipartFile(
              "file", _file.readAsBytes().asStream(), _file.lengthSync(),
              filename: _fileName.split('/').last));
        }
        var res = await req.send();
        if (res.statusCode == 200) {
          messageController.text = "";
          _file = null;
          setState(() {
            generateList(context);
          });
          isSended = false;
        } else {
          isSended = false;
        }
      } catch (e) {
        isSended = false;
        print(e);
      }
    }
  }

  Widget generateList(BuildContext ctx) {
    var mediaQuery = MediaQuery.of(ctx);
    return FutureBuilder(
      future: getAllMessage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        _data = snapshot.data;
        return snapshot.hasData
            ? Container(
                width: mediaQuery.size.width,
                height: mediaQuery.size.height < 560
                    ? _isHide
                        ? mediaQuery.size.height * 0.66
                        : mediaQuery.size.height * 0.58
                    : _isHide
                        ? mediaQuery.size.height * 0.75
                        : mediaQuery.size.height * 0.67,
                child: ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _data.length,
                    itemBuilder: (BuildContext ctx, index) {
                      DateFormat formatter = DateFormat('HH:mm');
                      String messageTime = formatter.format(DateTime.parse(
                          DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                              .parseUTC(_data[index].when)
                              .toString()));
                      var userId = _data[index].user["id"];
                      return Row(
                        mainAxisAlignment: userId == globals.userData["id"]
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  bottom: 15,
                                  right:
                                      userId == globals.userData["id"] ? 20 : 0,
                                  left: userId == globals.userData["id"]
                                      ? 0
                                      : 20),
                              width: mediaQuery.size.width * 0.8,
                              padding: EdgeInsets.only(
                                  top: 10, left: 8, bottom: 5, right: 5),
                              decoration: BoxDecoration(
                                  color: userId == globals.userData["id"]
                                      ? Color(0xff1ABC9C).withOpacity(0.15)
                                      : Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(6.2)),
                              child: Column(
                                children: [
                                  userId != globals.userData["id"]
                                      ? Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  "${globals.capitalize(_data[index].user["last_name"])} ${globals.capitalize(_data[index].user["first_name"])}",
                                                  style: TextStyle(
                                                    color: Color(0xff3182CE),
                                                    fontFamily: globals.font,
                                                    fontSize:
                                                        mediaQuery.size.width *
                                                            globals.fontSize16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFeatures: [
                                                      FontFeature.enable(
                                                          "pnum"),
                                                      FontFeature.enable("lnum")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              _data[index].moderator
                                                  ? Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5, bottom: 5),
                                                      child: ChatBox(
                                                          val: "moderator"
                                                              .tr()
                                                              .toString()),
                                                    )
                                                  : Container(
                                                      child: Row(
                                                        children: [
                                                          ChatBox(
                                                              val: _data[index]
                                                                      .work_details[
                                                                  "organization"]),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5)),
                                                          ChatBox(
                                                              val: _data[index]
                                                                      .work_details[
                                                                  "district"]),
                                                        ],
                                                      ),
                                                    ),
                                              _data[index].moderator
                                                  ? Container()
                                                  : Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5, bottom: 5),
                                                      child: ChatBox(
                                                          val: _data[index]
                                                                  .work_details[
                                                              "position"]),
                                                    ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: _data[index].file == null
                                            ? mediaQuery.size.width * 0.7
                                            : 64,
                                        child: _data[index].file == null
                                            ? Text(
                                                _data[index].message,
                                                style: TextStyle(
                                                  fontFamily: globals.font,
                                                  fontSize:
                                                      mediaQuery.size.width *
                                                          globals.fontSize12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontFeatures: [
                                                    FontFeature.enable("pnum"),
                                                    FontFeature.enable("lnum")
                                                  ],
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  height: 60,
                                                  child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: (_data[index]
                                                                    .file
                                                                    .split(".")
                                                                    .last ==
                                                                "jpg" ||
                                                            _data[index]
                                                                    .file
                                                                    .split(".")
                                                                    .last ==
                                                                "jpeg" ||
                                                            _data[index]
                                                                    .file
                                                                    .split(".")
                                                                    .last ==
                                                                "png")
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return GestureDetector(
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Hero(
                                                                          tag:
                                                                              'imageHero',
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              Image.network(
                                                                                "${globals.site_link}${_data[index].file}",
                                                                              ),
                                                                              Positioned(
                                                                                  top: 40,
                                                                                  right: 10,
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 40,
                                                                                      height: 40,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Color(0xFFFFFFFF),
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                      ),
                                                                                      child: Icon(
                                                                                        Icons.close,
                                                                                        size: 40,
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                            child: CachedNetworkImage(
                                                                imageUrl:
                                                                    "${globals.site_link}${_data[index].file}"),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    var route;
                                                                    route = PdfView(
                                                                        fileName:
                                                                            "${_data[index].file}");
                                                                    return route;
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              color:
                                                                  Colors.white,
                                                              child: Center(
                                                                child: Text(
                                                                  "file"
                                                                      .tr()
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        globals
                                                                            .font,
                                                                    fontSize: mediaQuery
                                                                            .size
                                                                            .width *
                                                                        globals
                                                                            .fontSize14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xff050505),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      _data[index].file != null
                                          ? Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              width:
                                                  mediaQuery.size.width * 0.5,
                                              child: Text(_data[index]
                                                  .file
                                                  .split("/")
                                                  .last),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        messageTime,
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: mediaQuery.size.width *
                                              globals.fontSize8,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFeatures: [
                                            FontFeature.enable("pnum"),
                                            FontFeature.enable("lnum")
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      );
                    }),
              )
            : Center(
                child: Text(""),
              );
      },
    );
  }

  Future pickedFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null &&
        globals.validateFile(File(result.files.single.path))) {
      PlatformFile file = result.files.first;
      if (file.extension == "jpg" ||
          file.extension == "png" ||
          file.extension == "jpeg") {
        _file = File(result.files.single.path);
        final dir = await path_provider.getTemporaryDirectory();

        final targetPath =
            dir.absolute.path + "/${Time()}${_file.path.split("/").last}";

        _file = await testCompressAndGetFile(_file, targetPath);
        sendMessage();
      } else if (file.extension == "pdf") {
        _file = File(result.files.single.path);
        sendMessage();
      } else {
        Fluttertoast.showToast(
            msg: "file_warning".tr().toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "file_warning".tr().toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  bool _textActive = false;

  void changeText(String val) {
    if (val == "") {
      setState(() {
        _textActive = false;
      });
    } else {
      setState(() {
        _textActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "messages".tr().toString(),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: mediaQuery.size.height * 0.9,
          child: Stack(
            children: [
              Positioned(
                bottom: _isHide ? 20 : 85,
                child: Container(
                  width: mediaQuery.size.width,
                  child: generateList(context),
                ),
              ),
              (_isHide)
                  ? Container()
                  : Positioned(
                      bottom: 30,
                      child: Container(
                        width: mediaQuery.size.width,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _textActive
                                  ? Color(0xff1ABC9C)
                                  : Color.fromRGBO(178, 183, 208, 0.5),
                              width: 1,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(27.5),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  pickedFile();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: SvgPicture.asset(
                                    "assets/img/file_icon.svg",
                                    color: _textActive
                                        ? Color(0xff000000)
                                        : Color.fromRGBO(49, 59, 108, 0.4),
                                  ),
                                ),
                              ),
                              Container(
                                  width: (mediaQuery.size.width - 40) * 0.60,
                                  child: TextField(
                                    onSubmitted: (value) {
                                      sendMessage();
                                    },
                                    onChanged: (value) {
                                      changeText(value);
                                    },
                                    controller: messageController,
                                    decoration: InputDecoration.collapsed(
                                      hintText: "enter_message".tr().toString(),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                              fontSize: mediaQuery.size.width *
                                                  globals.fontSize18),
                                    ),
                                  )),
                              InkWell(
                                onTap: () {
                                  sendMessage();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: SvgPicture.asset(
                                    "assets/img/send_icon.svg",
                                    color: _textActive
                                        ? Color.fromRGBO(26, 188, 156, 1)
                                        : Color.fromRGBO(49, 59, 108, 0.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
