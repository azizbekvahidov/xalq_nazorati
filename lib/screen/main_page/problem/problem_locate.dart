import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:geolocator/geolocator.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/models/addresses.dart';
import 'package:xalq_nazorati/screen/address_search.dart';
import 'package:xalq_nazorati/screen/main_page/main_page.dart';
import 'package:xalq_nazorati/screen/main_page/problem/flat_warning_problem.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../main_page/problem/problem_finish.dart';
import '../../../widget/app_bar/custom_appBar.dart';
import '../../../widget/default_button.dart';
import '../../../widget/text/main_text.dart';
import '../../../widget/shadow_box.dart';

_ProblemLocateState problemLocateState;

class ProblemLocate extends StatefulWidget {
  final String desc;
  final int subSubCategoryId;
  final int categoryId;
  final int subcategoryId;
  final String breadcrumbs;

  ProblemLocate(this.desc, this.subSubCategoryId, this.categoryId,
      this.subcategoryId, this.breadcrumbs);

  @override
  _ProblemLocateState createState() {
    problemLocateState = _ProblemLocateState();
    return problemLocateState;
  }
}

class _ProblemLocateState extends State<ProblemLocate>
    with SingleTickerProviderStateMixin {
  YandexMapController mapKitController;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static Point _initialPosition =
      Point(latitude: 41.313014, longitude: 69.241047);

  static Point _lastMapPosition;
  final addressController = TextEditingController();
  final extraController = TextEditingController();
  double _latitude = 0;
  double _longitude = 0;
  bool _value = true;
  bool _valid = false;
  bool _sending = false;
  int _cnt = 40;
  String _btn_message = "continue".tr().toString();
  String address = "";
  bool _isFlat = false;
  int _curLoad = 0;
  AnimationController _animationController;
  var _user_address = globals.userData["address"] == null
      ? ""
      : globals.generateAddrStr(globals.userData["address"]);
  int _val = 0;

  Placemark _placemark;
  Timer _timer;
  int problemId;
  bool isUpload = false;
  FocusNode _streetNode = FocusNode();
  FocusNode _houseNode = FocusNode();
  FocusNode _apartNode = FocusNode();
  FocusNode _yandexAddressNode = FocusNode();
  FocusNode _noteNode = FocusNode();

  bool getLocalAddress = false;
  bool getCustomAddress = true;
  ScrollController _scControl;
  @override
  void initState() {
    super.initState();
    _scControl = ScrollController();
    if (widget.categoryId == 18) {
      if (globals.userData["address"] != null) {
        getCustomAddress = false;
        getLocalAddress = true;
      } else {
        getCustomAddress = true;
        getLocalAddress = false;
      }
      getLocalData();
      checkChange();
    }
    _streetNode.addListener(() {
      print("street");
    });
    if (globals.userLocation != null) {
      getAddressFromLatLng(Point(
          latitude: globals.userLocation.latitude,
          longitude: globals.userLocation.longitude));
      Timer(Duration(seconds: 1), () {
        _setLocation(Point(
            latitude: globals.userLocation.latitude,
            longitude: globals.userLocation.longitude));
      });
    }

    _streetNode.addListener(() {
      print(this);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double percentage;

  static List<Addresses> _address;
  changeAddress(String value) async {
    try {
      address = addressController.text;
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
      address = addressController.text;
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
          _setLocation(Point(latitude: lat, longitude: long));
        }
        // List<Addresses> addresses = parseAddress(json["data"]);
        // return addresses;
      }
    } catch (e) {
      print(e);
    }
  }

  getAddressFromLatLng(var val) async {
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
          address = res;
        }
        checkChange();
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

  customDialog(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var dWidth = MediaQuery.of(context).size.width;
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.45,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/img/info.svg",
                      height: height * 0.12,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "problem_warning".tr().toString(),
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: dWidth * globals.fontSize16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "close".tr().toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void timerCencel() {
    _timer?.cancel();
  }

  void timerStart() {
    _timer = Timer.periodic(Duration(milliseconds: 400), (Timer t) {
      setState(() {
        _val += 1;
      });
      if (_val == 100 && problemId != null && isUpload) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProblemFinish(id: problemId);
            },
          ),
          ModalRoute.withName(MainPage.routeName),
        );
      }
    });
  }

  getHouse() async {
    try {
      if (globals.userData["address"] != "") {
        Map<String, String> headers = {
          "Authorization": "token 156d860c1900e489b21bf6ef55b75957974e514c",
        };
        var url =
            'https://data2.xalqnazorati.uz/${(globals.lang).tr().toString()}/v1/houses/${globals.userData["address"]["house"]["bigdata_id"]}';

        var r1 = await Requests.get(url, headers: headers);
        if (r1.statusCode == 200) {
          var json = r1.json();
          _isFlat = json["with_flats"];
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future insertData() async {
    try {
      print(_val);
      setState(() {
        _sending = true;
        _btn_message = "Loading".tr().toString();
      });
      timerStart();

      Map<String, String> sendData = {
        "subsubcategory": "${widget.subSubCategoryId}",
        "content": widget.desc,
        "address": address,
        "latitude": "$_latitude",
        "longitude": "$_longitude",
        "note": extraController.text,
      };
      var connect = new DioConnection();
      Map<String, String> headers = {"Authorization": "token ${globals.token}"};
      var response = await connect.postHttp(
          '/problems/problem', problemLocateState, headers, sendData);

      if (response["statusCode"] == 201) {
        setState(() {
          _sending = true;
          _btn_message = "Loading".tr().toString();
        });
        var reply = response["result"];
        problemId = reply["problem"]['id'];
        var url2 =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/problems/upload';

        var req = http.MultipartRequest("POST", Uri.parse(url2));
        req.headers.addAll({"Authorization": "token ${globals.token}"});
        req.fields.addAll({"problem_id": "${reply["problem"]['id']}"});
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
        if (req.files.length != 0) {
          var res = await req.send();
          if (res.statusCode == 201) {
            isUpload = true;
            setState(() {
              _val = 98;
            });
            globals.images['file1'] = null;
            globals.images['file2'] = null;
            globals.images['file3'] = null;
            globals.images['file4'] = null;
            globals.userLocation = null;
          }
        } else {
          isUpload = true;
          setState(() {
            _val = 98;
          });
          globals.images['file1'] = null;
          globals.images['file2'] = null;
          globals.images['file3'] = null;
          globals.images['file4'] = null;
          globals.userLocation = null;
        }
      } else {
        setState(() {
          _sending = false;
          _btn_message = "continue".tr().toString();
          _val = 0;
        });
        _timer?.cancel();
        customDialog(context);
      }
    } catch (e) {
      setState(() {
        _sending = false;
        _btn_message = "continue".tr().toString();
        _val = 0;
      });
      _timer?.cancel();
      print(e);
    }
  }

  setAddress(var addr, flatController, isChange) {
    try {
      address =
          "${addr['community']['district']["name_${(globals.lang).tr().toString()}"]}, ${addr['street']["name_${(globals.lang).tr().toString()}"]}, ${addr['number']}";
      _latitude = double.tryParse(addr['latitude']);
      _longitude = double.tryParse(addr['longitude']);
      _isFlat = addr["with_flats"];
      if (flatController.text != "") {
        address += ", ${flatController.text}";
      }
      address +=
          ", ${addr['community']["name_${(globals.lang).tr().toString()}"]}";
      if (isChange)
        setState(() {
          _valid = true;
        });
    } catch (e) {
      print(e);
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
    _setLocation(Point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude));
    getAddressFromLatLng(Point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude));
  }

  void _setLocation(var coords) async {
    try {
      await mapKitController.removePlacemark(_placemark);
      // var status = await Permission.location.status;
      // if (status.isUndetermined || status.isDenied) {
      //   Permission.location.request();
      //   // We didn't ask for permission yet.
      // }
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
    String descValue = address;
    setState(() {
      if (descValue != "" && _latitude != 0 && _longitude != 0)
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

  setMyaddress() {
    setState(() {
      if (globals.userData["address"] != null) {
        getLocalAddress = true;
        getCustomAddress = false;
        getLocalData();
        checkChange();
      }
    });
  }

  setOtherAddress() {
    setState(() {
      getLocalAddress = false;
      getCustomAddress = true;
      address = "";
      checkChange();
    });
  }

  getLocalData() {
    address = _user_address;
    if (_user_address != "") {
      _longitude =
          double.tryParse(globals.userData["address"]["house"]["longitude"]);
      _latitude =
          double.tryParse(globals.userData["address"]["house"]["latitude"]);
    }
    getHouse();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: widget.categoryId != 18
          ? [
              KeyboardActionsItem(
                  focusNode: _yandexAddressNode,
                  toolbarButtons: [
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
              KeyboardActionsItem(focusNode: _noteNode, toolbarButtons: [
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
            ]
          : [
              KeyboardActionsItem(focusNode: _streetNode, toolbarButtons: [
                (node) {
                  return GestureDetector(
                    onTap: () {
                      node.unfocus();
                      Navigator.pop(context, false);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ),
                  );
                }
              ]),
              KeyboardActionsItem(focusNode: _houseNode, toolbarButtons: [
                (node) {
                  return GestureDetector(
                    onTap: () {
                      node.unfocus();
                      Navigator.pop(context, false);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ),
                  );
                }
              ]),
              KeyboardActionsItem(focusNode: _apartNode, toolbarButtons: [
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
              KeyboardActionsItem(focusNode: _noteNode, toolbarButtons: [
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

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final _key = GlobalKey<GoogleMapStateBase>();
  @override
  Widget build(BuildContext context) {
    print(widget.categoryId);
    final mediaQuery = MediaQuery.of(context);
    var dWidth = MediaQuery.of(context).size.width;
    var appBar = CustomAppBar(title: "where_is_problem".tr().toString());
    return Stack(
      children: [
        Scaffold(
          appBar: appBar,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              controller: _scControl,
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top),
                child: KeyboardActions(
                  disableScroll: true,
                  // isDialog: true,
                  config: _buildConfig(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.categoryId != 18
                                      ? Container()
                                      : ShadowBox(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setMyaddress();
                                                  },
                                                  child: MainText("your_address"
                                                      .tr()
                                                      .toString()),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setMyaddress();
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 16),
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            248, 249, 250, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    183,
                                                                    208,
                                                                    0.25))),
                                                    child: _user_address == ""
                                                        ? Text(
                                                            "user_address_warning"
                                                                .tr()
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  globals.font,
                                                              fontSize: dWidth *
                                                                  globals
                                                                      .fontSize16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors.red,
                                                              fontFeatures: [
                                                                FontFeature
                                                                    .enable(
                                                                        "pnum"),
                                                                FontFeature
                                                                    .enable(
                                                                        "lnum")
                                                              ],
                                                            ),
                                                          )
                                                        : Text(
                                                            _user_address,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  globals.font,
                                                              fontSize: dWidth *
                                                                  globals
                                                                      .fontSize16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0.5),
                                                              fontFeatures: [
                                                                FontFeature
                                                                    .enable(
                                                                        "pnum"),
                                                                FontFeature
                                                                    .enable(
                                                                        "lnum")
                                                              ],
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                _user_address != ""
                                                    ? InkWell(
                                                        onTap: () {
                                                          setMyaddress();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "use_my_address"
                                                                  .tr()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    globals
                                                                        .font,
                                                                fontSize: dWidth *
                                                                    globals
                                                                        .fontSize16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      style: BorderStyle
                                                                          .solid,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: getLocalAddress
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Colors
                                                                          .transparent),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child:
                                                                    getLocalAddress
                                                                        ? Icon(
                                                                            Icons.check,
                                                                            size:
                                                                                15.0,
                                                                            color:
                                                                                Colors.white,
                                                                          )
                                                                        : Icon(
                                                                            Icons.check_box_outline_blank,
                                                                            size:
                                                                                15.0,
                                                                            color:
                                                                                Colors.transparent,
                                                                          ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20)),
                                                InkWell(
                                                  onTap: () {
                                                    setOtherAddress();
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "use_other_address"
                                                            .tr()
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              globals.font,
                                                          fontSize: dWidth *
                                                              globals
                                                                  .fontSize16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 2,
                                                                style:
                                                                    BorderStyle
                                                                        .solid,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                            shape:
                                                                BoxShape.circle,
                                                            color: getCustomAddress
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              getCustomAddress
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
                                                                      size:
                                                                          15.0,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .check_box_outline_blank,
                                                                      size:
                                                                          15.0,
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  getCustomAddress
                                      ? ShadowBox(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    widget.breadcrumbs,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          102, 103, 108, 0.7),
                                                      fontFamily: globals.font,
                                                      fontSize: dWidth *
                                                          globals.fontSize12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                widget.categoryId != 18
                                                    ? MainText("set_address"
                                                        .tr()
                                                        .toString())
                                                    : Container(),
                                                widget.categoryId != 18
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        width: double.infinity,
                                                        height: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffF5F6F9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      22.5),
                                                          border: Border.all(
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    183,
                                                                    208,
                                                                    0.5),
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: (mediaQuery
                                                                          .size
                                                                          .width -
                                                                      mediaQuery
                                                                          .padding
                                                                          .left -
                                                                      mediaQuery
                                                                          .padding
                                                                          .right) *
                                                                  0.74,
                                                              child:
                                                                  TypeAheadField(
                                                                suggestionsBoxDecoration:
                                                                    SuggestionsBoxDecoration(
                                                                        offsetX:
                                                                            -20.0),
                                                                addWidth: 50,
                                                                offsetLeft: 10,
                                                                textFieldConfiguration:
                                                                    TextFieldConfiguration(
                                                                  focusNode:
                                                                      _yandexAddressNode,
                                                                  controller:
                                                                      addressController,
                                                                  autofocus:
                                                                      true,
                                                                  decoration:
                                                                      InputDecoration
                                                                          .collapsed(
                                                                    hintText:
                                                                        "address_example"
                                                                            .tr()
                                                                            .toString(),
                                                                    hintStyle: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .display1
                                                                        .copyWith(
                                                                            fontSize:
                                                                                dWidth * globals.fontSize18),
                                                                  ),
                                                                ),
                                                                hideOnEmpty:
                                                                    true,
                                                                suggestionsCallback:
                                                                    (pattern) async {
                                                                  await changeAddressMap(
                                                                      pattern);
                                                                  return response;
                                                                },
                                                                itemBuilder:
                                                                    (context,
                                                                        suggestion) {
                                                                  return ListTile(
                                                                    title: Text(
                                                                        suggestion
                                                                            .title),
                                                                  );
                                                                },
                                                                onSuggestionSelected:
                                                                    (suggestion) {
                                                                  getLocateFromAddress(
                                                                      suggestion
                                                                          .title);
                                                                  addressController
                                                                          .text =
                                                                      suggestion
                                                                          .title;
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : AddressSearch(
                                                        setAddress: setAddress,
                                                        isFlat: true,
                                                        streetNode: _streetNode,
                                                        houseNode: _houseNode,
                                                        apartNode: _apartNode,
                                                      ),
                                                MainText(
                                                    "notes".tr().toString()),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  width: double.infinity,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffF5F6F9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.5),
                                                    border: Border.all(
                                                      color: Color.fromRGBO(
                                                          178, 183, 208, 0.5),
                                                      style: BorderStyle.solid,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width:
                                                            (mediaQuery.size
                                                                        .width -
                                                                    mediaQuery
                                                                        .padding
                                                                        .left -
                                                                    mediaQuery
                                                                        .padding
                                                                        .right) *
                                                                0.74,
                                                        child: TextField(
                                                          focusNode: _noteNode,
                                                          maxLength: 40,
                                                          buildCounter: (BuildContext
                                                                      context,
                                                                  {int
                                                                      currentLength,
                                                                  int maxLength,
                                                                  bool
                                                                      isFocused}) =>
                                                              null,
                                                          onChanged: (value) {
                                                            var result = value;
                                                            if (result.length >
                                                                40) {
                                                              result = result
                                                                  .substring(
                                                                      0, 40);
                                                              extraController
                                                                      .text =
                                                                  result;
                                                              extraController
                                                                      .selection =
                                                                  TextSelection.fromPosition(
                                                                      TextPosition(
                                                                          offset:
                                                                              result.length));
                                                            }
                                                            changeTxt(result);
                                                          },
                                                          controller:
                                                              extraController,
                                                          maxLines: 1,
                                                          decoration:
                                                              InputDecoration
                                                                  .collapsed(
                                                            hintText:
                                                                "note_example"
                                                                    .tr()
                                                                    .toString(),
                                                            hintStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display1
                                                                .copyWith(
                                                                    fontSize: dWidth *
                                                                        globals
                                                                            .fontSize18),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    "${"textarea_counter_start".tr().toString()}$_cnt ${"textarea_counter_end".tr().toString()}",
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          102, 103, 108, 0.6),
                                                      fontSize: dWidth *
                                                          globals.fontSize10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: globals.font,
                                                    ),
                                                  ),
                                                ),
                                                widget.categoryId != 18
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: 20),
                                                        width: double.infinity,
                                                        height: 335,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        178,
                                                                        183,
                                                                        208,
                                                                        0.5),
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                  child:
                                                                      YandexMap(
                                                                onMapTap:
                                                                    (coords) {
                                                                  _setLocation(
                                                                      coords);
                                                                  getAddressFromLatLng(
                                                                      coords);
                                                                },
                                                                onMapCreated:
                                                                    (YandexMapController
                                                                        yandexMapController) async {
                                                                  yandexMapController.move(
                                                                      point: Point(
                                                                          latitude: _initialPosition
                                                                              .latitude,
                                                                          longitude: _initialPosition
                                                                              .longitude),
                                                                      zoom: 11,
                                                                      animation: const MapAnimation(
                                                                          smooth:
                                                                              true,
                                                                          duration:
                                                                              1.0));
                                                                  mapKitController =
                                                                      yandexMapController;
                                                                },
                                                              )),
                                                              Positioned(
                                                                bottom: 10,
                                                                right: 10,
                                                                child:
                                                                    FloatingActionButton(
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/img/locate.svg"),
                                                                  onPressed:
                                                                      _getLocation,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
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
                                          "continue".tr().toString(),
                                          () {},
                                          Color(0xffB2B7D0),
                                        )
                                      : !_sending
                                          ? DefaultButton(_btn_message, () {
                                              if (widget.subSubCategoryId == 35 ||
                                                  widget.subSubCategoryId ==
                                                      102 ||
                                                  widget.subSubCategoryId ==
                                                      99 ||
                                                  widget.subcategoryId == 66 ||
                                                  widget.subcategoryId == 80) {
                                                if (_isFlat) {
                                                  insertData().then((value) {});
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return FlatWarningProblem();
                                                  }));
                                                }
                                              } else {
                                                insertData().then((value) {});
                                              }
                                            },
                                              (!_sending)
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Color(0xffB2B7D0))
                                          : Center(
                                              child: Container(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                child:
                                                    LiquidLinearProgressIndicator(
                                                  value: _val / 100,
                                                  backgroundColor:
                                                      Color(0xffB2B7D0),
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Theme.of(context)
                                                              .primaryColor),
                                                  borderRadius: 25.0,
                                                  center: Text(
                                                    "${_val}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
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
          ),
        ),
        CheckConnection(),
      ],
    );
  }
}
