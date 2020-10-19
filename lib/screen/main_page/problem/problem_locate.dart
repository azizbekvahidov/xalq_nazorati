import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/screen/main_page/main_page.dart';
import '../../main_page/problem/problem_finish.dart';
import '../../../widget/app_bar/custom_appBar.dart';
import '../../../widget/checkbox_custom.dart';
import '../../../widget/default_button.dart';
import '../../../widget/input/default_input.dart';
import '../../../widget/text/main_text.dart';
import '../../../widget/shadow_box.dart';

class ProblemLocate extends StatefulWidget {
  final String desc;
  final int subSubCategoryId;

  ProblemLocate(this.desc, this.subSubCategoryId);

  @override
  _ProblemLocateState createState() => _ProblemLocateState();
}

class _ProblemLocateState extends State<ProblemLocate> {
  GoogleMapController mapController;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition = LatLng(41.313014, 69.241047);

  static LatLng _lastMapPosition;
  final addressController = TextEditingController();
  final extraController = TextEditingController();
  double _latitude;
  double _longitude;
  bool _value = false;
  final Map<String, Marker> _markers = {};

  Future insertData() async {
    if (_value) {
      try {
        Map<String, String> sendData = {
          "subsubcategory": "${widget.subSubCategoryId}",
          "content": widget.desc,
          "address": addressController.text,
          "latitude": "$_latitude".substring(0, 10),
          "longitude": "$_longitude".substring(0, 10),
          "note": extraController.text,
        };
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}",
        };
        var url = 'https://new.xalqnazorati.uz/ru/api/problems/problem';
        HttpGet request = HttpGet();
        HttpClientResponse response = await request.methodPost(sendData, url);

        String reply = await response.transform(utf8.decoder).join();

        Map<String, dynamic> responseBody = json.decode(reply);

        if (response.statusCode == 201) {
          var url2 = 'https://new.xalqnazorati.uz/ru/api/problems/upload';

          var req = http.MultipartRequest("POST", Uri.parse(url2));
          req.headers.addAll({"Authorization": "token ${globals.token}"});
          req.fields.addAll({"problem_id": "${responseBody["problem"]['id']}"});
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

          if (res.statusCode == 201) {
            globals.images['file1'] = null;
            globals.images['file2'] = null;
            globals.images['file3'] = null;
            globals.images['file4'] = null;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProblemFinish();
                },
              ),
              ModalRoute.withName(MainPage.routeName),
            );
          }
        } else {
          print(responseBody["detail"]);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _getLocation() async {
    var currentLocation =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _latitude = currentLocation.latitude;
    _longitude = currentLocation.longitude;
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        // infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;

      final p = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 14.4746);

      mapController.animateCamera(CameraUpdate.newCameraPosition(p));
    });
  }

  void _setLocation(var coords) async {
    var currentLocation =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _latitude = coords.latitude;
    _longitude = coords.longitude;
    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(coords.latitude, coords.longitude),
        // infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;

      final p = CameraPosition(
          target: LatLng(coords.latitude, coords.longitude), zoom: 14.4746);

      mapController.animateCamera(CameraUpdate.newCameraPosition(p));
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  MapType _currentMapType = MapType.normal;

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final _key = GlobalKey<GoogleMapStateBase>();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Где обнаружена проблема?"),
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
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
                                MainText("Укажите место на карте или адрес"),
                                DefaultInput("Например: улица Фархадская 65",
                                    addressController),
                                MainText("Примечания"),
                                DefaultInput(
                                    "Ориентир: № подъезд", extraController),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Не более 40 символов",
                                    style: TextStyle(
                                      color: Color.fromRGBO(102, 103, 108, 0.6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Gilroy",
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: double.infinity,
                                  height: 335,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromRGBO(
                                              178, 183, 208, 0.5),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: GoogleMap(
                                          markers: _markers.values.toSet(),
                                          mapType: _currentMapType,
                                          initialCameraPosition: CameraPosition(
                                            target: _initialPosition,
                                            zoom: 10,
                                          ),
                                          onTap: (coord) {
                                            _setLocation(coord);
                                            print(coord);
                                          },
                                          onMapCreated: _onMapCreated,
                                          zoomGesturesEnabled: true,
                                          onCameraMove: _onCameraMove,
                                          myLocationEnabled: true,
                                          compassEnabled: true,
                                          myLocationButtonEnabled: false,
                                          zoomControlsEnabled: false,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: FloatingActionButton(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: SvgPicture.asset(
                                              "assets/img/locate.svg"),
                                          onPressed: _getLocation,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _value = !_value;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  style: BorderStyle.solid,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              shape: BoxShape.circle,
                                              color: _value
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.transparent),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: _value
                                                ? Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                    color: Colors.white,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 15.0,
                                                    color: Colors.transparent,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        width: mediaQuery.size.width * 0.8,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "Ознакомлен и согласен с ",
                                                style: TextStyle(
                                                  fontFamily: "Gilroy",
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {},
                                                text:
                                                    "пользовательским соглашением",
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontFamily: "Gilroy",
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " и ",
                                                style: TextStyle(
                                                  fontFamily: "Gilroy",
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {},
                                                text:
                                                    "правилами модерации проблем ",
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontFamily: "Gilroy",
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
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
                            DefaultButton("Продолжить", () {
                          insertData().then((value) {
                            // print("sended");
                            // Navigator.of(context).pushAndRemoveUntil(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) {
                            //       return ProblemFinish();
                            //     },
                            //   ),
                            //   ModalRoute.withName(MainPage.routeName),
                            // );
                          });
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
    );
  }
}
