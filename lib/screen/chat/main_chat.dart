import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/chatMessage.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/full_screen.dart';

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

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 100), (Timer t) {
      refreshChat();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<List<ChatMessage>> getAllMessage() async {
    try {
      var url = '${globals.api_link}/problems/chat/${widget.id}';
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
          '${globals.api_link}/problems/refresh-chat?problem_id=${widget.id}';
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
      var url = '${globals.api_link}/problems/check-message?message_id=${id}';
      HttpGet request = HttpGet();
      var response = await request.methodGet(url);

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

  Future sendMessage() async {
    if (messageController.text != "" || _file != null) {
      try {
        var url2 = '${globals.api_link}/problems/chat';

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
        } else {
          print(res);
        }
      } catch (e) {
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
                    ? mediaQuery.size.height * 0.58
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
                      var userId = _data[index].user;
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
                                            ? Text(_data[index].message)
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
                                                                "png" ||
                                                            _data[index]
                                                                    .file
                                                                    .split(".")
                                                                    .last ==
                                                                "gif")
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
                                                                              Image.network(
                                                                            "${globals.site_link}${_data[index].file}",
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
                                                            child: Image.network(
                                                                "${globals.site_link}${_data[index].file}"),
                                                          )
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            color: Colors.white,
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
                                      Text(messageTime),
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

    if (result != null) {
      _file = File(result.files.single.path);
      sendMessage();
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
                bottom: 85,
                child: Container(
                  width: mediaQuery.size.width,
                  child: generateList(context),
                ),
              ),
              (widget.status == "canceled" ||
                      widget.status == "confirmed" ||
                      widget.status == "denied" ||
                      widget.status == "closed")
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
