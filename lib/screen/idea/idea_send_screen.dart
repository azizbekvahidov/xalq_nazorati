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
import 'package:xalq_nazorati/screen/main_page/main_page.dart';
import 'package:xalq_nazorati/widget/idea-widget/idea_head_card.dart';
import '../main_page/problem/problem_finish.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/checkbox_custom.dart';
import '../../widget/default_button.dart';
import '../../widget/input/default_input.dart';
import '../../widget/text/main_text.dart';
import '../../widget/shadow_box.dart';

class IdeaSendScreen extends StatefulWidget {
  final int id;

  IdeaSendScreen(this.id);

  @override
  _IdeaSendScreenState createState() => _IdeaSendScreenState();
}

class _IdeaSendScreenState extends State<IdeaSendScreen> {
  GoogleMapController mapController;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition = LatLng(41.313014, 69.241047);

  static LatLng _lastMapPosition;
  final addressController = TextEditingController();
  final extraController = TextEditingController();
  double _latitude;
  double _longitude;
  final Map<String, Marker> _markers = {};

  // Future insertData() async {
  //   final sendData = json.encode(<String, String>{
  //     "subsubcategory:": "${widget.id}",
  //     "content": widget.desc,
  //     "address": addressController.text,
  //     "latitude": "$_latitude",
  //     "longitude": "$_longitude",
  //     "note": extraController.text,
  //   });
  //   var url = 'https://new.xalqnazorati.uz/ru/api/problems/problem';
  //   var response = await http.post(url, body: sendData, headers: {
  //     "Authorization": "token ${globals.token}",
  //     HttpHeaders.contentTypeHeader: "application/json",
  //   });
  //   // print(json.encode(response.request));
  //   print(utf8.decode(response.bodyBytes));
  //   print(response.request.headers);
  // }

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
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Предложить идею"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            IdeaHeadCard(
                widget.id,
                "Гаражи и парковки",
                "Предложения по улучшению детских площадок",
                "assets/img/road.svg",
                false),
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
                                DefaultInput(
                                    hint: "Например: улица Фархадская 65",
                                    textController: addressController),
                                MainText("Примечания"),
                                DefaultInput(
                                    hint: "Ориентир: № подъезд",
                                    textController: extraController),
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
                                      CheckboxCustom(_value),
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
                            DefaultButton("Отправить сообщение", () {
                          // insertData().then((value) {
                          // Navigator.of(context).pushAndRemoveUntil(
                          //   MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //       return ProblemFinish();
                          //     },
                          //   ),
                          //   ModalRoute.withName(MainPage.routeName),
                          // );
                          // });
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
