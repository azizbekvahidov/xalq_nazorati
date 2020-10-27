import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/addresses.dart';
import 'package:xalq_nazorati/screen/main_page/main_page.dart';
import 'package:xalq_nazorati/screen/rule_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
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
  final int categoryId;

  ProblemLocate(this.desc, this.subSubCategoryId, this.categoryId);

  @override
  _ProblemLocateState createState() => _ProblemLocateState();
}

class _ProblemLocateState extends State<ProblemLocate> {
  GoogleMapController mapController;
  YandexMapController mapKitController;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition = LatLng(41.313014, 69.241047);

  static LatLng _lastMapPosition;
  final addressController = TextEditingController();
  final extraController = TextEditingController();
  double _latitude = 0;
  double _longitude = 0;
  bool _value = false;
  bool _valid = false;
  int _cnt = 40;

  Placemark _placemark;
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  }

  static List<Addresses> _address;
  changeAddress(String value) async {
    try {
      String address = addressController.text;
      Map<String, String> headers = {
        "Authorization": "42e3edd0-a430-11ea-bb37-0242ac130002"
      };
      var url =
          'https://data.xalqnazorati.uz/api/v1/addresses/suggestions?q=$value';
      var r1 = await Requests.get(url, headers: headers);
      if (r1.statusCode == 200) {
        var json = r1.json();

        List<Addresses> addresses = parseAddress(json["data"]);
        return addresses;
      }
    } catch (e) {
      print(e);
    }
  }

  getLocateFromAddress(String val) async {
    try {
      String address = addressController.text;
      var url =
          'https://geocode-maps.yandex.ru/1.x/?apikey=2795d389-a82c-4d0d-913e-35f811762571&geocode=$val&format=json';
      var r1 = await Requests.get(url);
      if (r1.statusCode == 200) {
        var json = r1.json();
        var temp = json['response']['GeoObjectCollection']['featureMember'];
        if (temp.length != 0) {
          var res = temp[0]['GeoObject']['Point']['pos'];
          print(res);
          var latlng = res.split(' ');
          double long = double.parse(latlng[0]);
          double lat = double.parse(latlng[1]);
          _setLocation(LatLng(lat, long));
        }
        // List<Addresses> addresses = parseAddress(json["data"]);
        // return addresses;
      }
    } catch (e) {
      print(e);
    }
  }

  getAddressFromLatLng(Point val) async {
    try {
      String lat = "${val.latitude}".substring(0, 9);
      String long = "${val.longitude}".substring(0, 9);
      var url =
          'https://geocode-maps.yandex.ru/1.x/?apikey=2795d389-a82c-4d0d-913e-35f811762571&geocode=$long,$lat&format=json';
      var r1 = await Requests.get(url);
      if (r1.statusCode == 200) {
        var json = r1.json();
        var temp = json['response']['GeoObjectCollection']['featureMember'];
        if (temp.length != 0) {
          var res = temp[0]['GeoObject']['name'];
          addressController.text = res;
        }
        // List<Addresses> addresses = parseAddress(json["data"]);
        // return addresses;
      }
    } catch (e) {
      print(e);
    }
  }

  var response;
  Future changeAddressMap(String value) async {
    try {
      await YandexSearch.getSuggestions(
          value,
          const Point(latitude: 41.400621, longitude: 69.153615),
          const Point(latitude: 41.229359, longitude: 69.398712),
          'GEO',
          true, (List<SuggestItem> suggestItems) {
        // print(suggestItems.runtimeType);
        response = suggestItems;
        setState(() {
          //   response =
          //       suggestItems.map((SuggestItem item) => item.title).join('\n');
        });
      });
      // print(response);
      // return response;
      // await Future<dynamic>.delayed(
      //     const Duration(seconds: 3), () => cancelListening());
    } catch (e) {
      print(e);
    }
  }

  List<Addresses> parseAddress(var responseBody) {
    var res = responseBody
        .map<Addresses>((json) => Addresses.fromJson(json))
        .toList();
    return res;
  }

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
    var status = await Permission.location.status;
    print(status);
    if (status.isUndetermined || status.isDenied) {
      Permission.location.request();
      // We didn't ask for permission yet.
    }
    var currentLocation =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _setLocation(LatLng(currentLocation.latitude, currentLocation.longitude));
  }

  void _setLocation(var coords) async {
    try {
      await mapKitController.removePlacemark(_placemark);
      var status = await Permission.location.status;
      if (status.isUndetermined || status.isDenied) {
        Permission.location.request();
        // We didn't ask for permission yet.
      }
      _latitude = coords.latitude;
      _longitude = coords.longitude;
      Point _point = Point(latitude: _latitude, longitude: _longitude);

      _placemark = Placemark(
        point: _point,
        opacity: 1,
        iconName: "flutter_assets/placemark.png",
      );
      setState(() async {
        // _markers.clear();
        // final marker = Marker(
        //   markerId: MarkerId("curr_loc"),
        //   position: LatLng(coords.latitude, coords.longitude),
        //   // infoWindow: InfoWindow(title: 'Your Location'),
        // );
        // _markers["Current Location"] = marker;

        // final p = CameraPosition(
        //     target: LatLng(coords.latitude, coords.longitude), zoom: 14.4746);

        await mapKitController.addPlacemark(_placemark);

        await mapKitController.move(
            point: _point,
            zoom: 14,
            animation: const MapAnimation(smooth: true, duration: 1.0));
        // (CameraUpdate.newCameraPosition(p));
        checkChange();
      });
    } catch (e) {
      print(e);
    }
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

  checkChange() {
    String descValue = addressController.text;
    setState(() {
      if (descValue != "" && _value && _latitude != 0 && _longitude != 0)
        _valid = true;
      else
        _valid = false;
    });
  }

  void changeTxt(String value) {
    setState(() {
      _cnt = 40 - value.length;
    });
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
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF5F6F9),
                                    borderRadius: BorderRadius.circular(22.5),
                                    border: Border.all(
                                      color: Color.fromRGBO(178, 183, 208, 0.5),
                                      style: BorderStyle.solid,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: (mediaQuery.size.width -
                                                mediaQuery.padding.left -
                                                mediaQuery.padding.right) *
                                            0.77,
                                        child: widget.categoryId != 18
                                            ? TypeAheadField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  controller: addressController,
                                                  autofocus: true,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                    hintText: "Введите адрес",
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display1,
                                                  ),
                                                ),
                                                hideOnEmpty: true,
                                                suggestionsCallback:
                                                    (pattern) async {
                                                  await changeAddressMap(
                                                      pattern);
                                                  return response;
                                                },
                                                itemBuilder:
                                                    (context, suggestion) {
                                                  return ListTile(
                                                    title:
                                                        Text(suggestion.title),
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (suggestion) {
                                                  getLocateFromAddress(
                                                      suggestion.title);
                                                  addressController.text =
                                                      suggestion.title;
                                                },
                                              )
                                            : TypeAheadField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  controller: addressController,
                                                  autofocus: true,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                    hintText: "Введите адрес",
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .display1,
                                                  ),
                                                ),
                                                hideOnEmpty: true,
                                                suggestionsCallback:
                                                    (pattern) async {
                                                  return await changeAddress(
                                                      pattern);
                                                },
                                                itemBuilder:
                                                    (context, suggestion) {
                                                  return ListTile(
                                                    title: Text(
                                                        suggestion.address),
                                                  );
                                                },
                                                onSuggestionSelected:
                                                    (suggestion) {
                                                  checkChange();
                                                  _setLocation(LatLng(
                                                      double.parse(suggestion
                                                          .house["latitude"]),
                                                      double.parse(
                                                          suggestion.house[
                                                              "longitude"])));
                                                  print(suggestion.address);
                                                  addressController.text =
                                                      suggestion.address;
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                MainText("Примечания"),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF5F6F9),
                                    borderRadius: BorderRadius.circular(22.5),
                                    border: Border.all(
                                      color: Color.fromRGBO(178, 183, 208, 0.5),
                                      style: BorderStyle.solid,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: (mediaQuery.size.width -
                                                mediaQuery.padding.left -
                                                mediaQuery.padding.right) *
                                            0.74,
                                        child: TextField(
                                          maxLength: 40,
                                          buildCounter: (BuildContext context,
                                                  {int currentLength,
                                                  int maxLength,
                                                  bool isFocused}) =>
                                              null,
                                          onChanged: (value) {
                                            changeTxt(value);
                                          },
                                          controller: extraController,
                                          maxLines: 1,
                                          decoration: InputDecoration.collapsed(
                                            hintText: "Ориентир: № подъезд",
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .display1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Не более $_cnt символов",
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            child: YandexMap(
                                          onMapTap: (coords) {
                                            _setLocation(coords);
                                            getAddressFromLatLng(coords);
                                          },
                                          onMapCreated: (YandexMapController
                                              yandexMapController) async {
                                            yandexMapController.move(
                                                point: Point(
                                                    latitude: _initialPosition
                                                        .latitude,
                                                    longitude: _initialPosition
                                                        .longitude),
                                                zoom: 11,
                                                animation: const MapAnimation(
                                                    smooth: true,
                                                    duration: 1.0));
                                            mapKitController =
                                                yandexMapController;
                                          },
                                        )),
                                        // Positioned(
                                        //   child: GoogleMap(
                                        //     markers: _markers.values.toSet(),
                                        //     mapType: _currentMapType,
                                        //     initialCameraPosition: CameraPosition(
                                        //       target: _initialPosition,
                                        //       zoom: 10,
                                        //     ),
                                        //     onTap: (coord) {
                                        //       _setLocation(coord);
                                        //       print(coord);
                                        //     },
                                        //     onMapCreated: _onMapCreated,
                                        //     zoomGesturesEnabled: true,
                                        //     onCameraMove: _onCameraMove,
                                        //     myLocationEnabled: true,
                                        //     compassEnabled: true,
                                        //     myLocationButtonEnabled: false,
                                        //     zoomControlsEnabled: false,
                                        //   ),
                                        // ),
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
                                          checkChange();
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
                                                      ..onTap = () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RulePage.routeName);
                                                      },
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
                                                      ..onTap = () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RulePage.routeName);
                                                      },
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
                        child: !_valid
                            ? DefaultButton(
                                "Продолжить",
                                () {},
                                Color(0xffB2B7D0),
                              )
                            : DefaultButton("Продолжить", () {
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
