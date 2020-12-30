import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/models/addresses.dart';
import 'package:xalq_nazorati/widget/input/default_input.dart';
import 'package:xalq_nazorati/widget/input/default_select.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import '../../flutter_typeahead/lib/flutter_typeahead.dart';

class AddressSearch extends StatefulWidget {
  Function setAddress;
  bool ischange;
  bool isFlat = false;

  AddressSearch({this.setAddress, this.ischange, this.isFlat, Key key})
      : super(key: key);

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  String placeType = "all";
  bool _all_type = true;
  bool _street_type = false;
  bool _quarter_type = false;
  bool _massiv_type = false;

  bool isSelectDistrict = true;
  bool isSelectStreet = true;
  bool isSelectHouse = true;
  bool with_flats = false;

  // List<DropdownMenuItem<String>> _district;
  String _selectedType;

  List<DropdownMenuItem<String>> _district;
  String _selectedDistrict;
  String _selectedStreet;
  String _selectedHouse;
  bool _isHouse = false;

  TextEditingController searchAddressController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController mahallaController = TextEditingController();
  TextEditingController flatController = TextEditingController();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    getDistricts();
  }

  getDistricts() async {
    try {
      Map<String, String> headers = {
        "Authorization": "token 156d860c1900e489b21bf6ef55b75957974e514c",
      };
      var url =
          'https://data2.xalqnazorati.uz/${(globals.lang).tr().toString()}/v1/districts';
      var r1 = await Requests.get(url, headers: headers);
      if (r1.statusCode == 200) {
        var json = r1.json();
        _district = convertToList(json["results"]);
        setState(() {});
        // return json.toList();
      }
    } catch (e) {
      print(e);
    }
  }

  getStreet(String value, String placeType) async {
    try {
      Map<String, String> headers = {
        "Authorization": "token 156d860c1900e489b21bf6ef55b75957974e514c",
      };
      var url;
      if (_selectedDistrict == null) {
        url =
            'https://data2.xalqnazorati.uz/${(globals.lang).tr().toString()}/v1/suggestions?q=$value';
        if (!_all_type) {
          url += "&type=$placeType";
        }
        var r1 = await Requests.get(url, headers: headers);
        if (r1.statusCode == 200) {
          var json = r1.json();
          return json["results"];
        }
      } else {
        url =
            'https://data2.xalqnazorati.uz/${(globals.lang).tr().toString()}/v1/streets?q=$value&district_id=$_selectedDistrict';
        if (!_all_type) {
          url += "&type=$placeType";
        }
        var r1 = await Requests.get(url, headers: headers);
        if (r1.statusCode == 200) {
          var json = r1.json();
          return json["results"];
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getHouse(String value) async {
    try {
      Map<String, String> headers = {
        "Authorization": "token 156d860c1900e489b21bf6ef55b75957974e514c",
      };
      var url =
          'https://data2.xalqnazorati.uz/${(globals.lang).tr().toString()}/v1/houses?q=$value&street_id=$_selectedStreet';
      if (!_all_type) {
        url += "&type=$placeType";
      }
      var r1 = await Requests.get(url, headers: headers);
      if (r1.statusCode == 200) {
        var json = r1.json();
        return json["results"];
      }
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

  List<DropdownMenuItem<String>> convertToList(var json) {
    List<DropdownMenuItem<String>> res = [];
    res.add(DropdownMenuItem<String>(
      value: null,
      child: Text("all_districts".tr().toString()),
    ));
    json.forEach((val) {
      res.add(DropdownMenuItem<String>(
        value: val["id"].toString(),
        child: Text(val["name_${(globals.lang).tr().toString()}"]),
      ));
    });
    return res;
  }

  var _suggets;
  SuggestionsBoxController suggestionsBoxController =
      SuggestionsBoxController();

  SuggestionsBoxController suggestionsHouseBoxController =
      SuggestionsBoxController();

  validate(var suggest) {
    if (mahallaController.text != "") {
      widget.ischange = true;
    }
    widget.setAddress(suggest, flatController, widget.ischange);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText("${"district".tr().toString()}*"),
          DefaultSelect(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                items: _district,
                onChanged: (val) {
                  setState(() {
                    _selectedDistrict = val;
                    setState(() {
                      // _selectedStreet = "";
                      // searchAddressController.text = "";
                      houseController.text = "";
                      widget.ischange = false;
                      _selectedHouse = "";
                      _selectedStreet = "";
                      searchAddressController.text = "";
                    });
                    validate(null);
                  });
                },
                hint: Text(
                  "select_district".tr().toString(),
                  style: TextStyle(
                      fontFamily: globals.font,
                      fontSize: dWidth * globals.fontSize18),
                ),
                value: _selectedDistrict,
              ),
            ),
          ),
          MainText("${"placeType".tr().toString()}*"),
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _all_type = true;
                          _street_type = false;
                          _quarter_type = false;
                          _massiv_type = false;
                          placeType = "all";

                          // _selectedStreet = "";
                          // searchAddressController.text = "";
                          houseController.text = "";
                          mahallaController.text = "";
                          _selectedHouse = "";
                          widget.ischange = false;
                          suggestionsBoxController.toggle();
                        });
                        validate(null);
                      },
                      child: Container(
                        width: dWidth / 2 - 20,
                        height: 35,
                        decoration: BoxDecoration(
                          color:
                              _all_type ? Color(0xff007BEC) : Color(0xffF5F6F9),
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(178, 183, 208, 0.5)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "all".tr().toString(),
                            style: TextStyle(
                                color: _all_type ? Colors.white : Colors.black,
                                fontFamily: globals.font,
                                fontWeight: FontWeight.w500,
                                fontSize: dWidth * globals.fontSize14),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _all_type = false;
                          _street_type = true;
                          _quarter_type = false;
                          _massiv_type = false;
                          placeType = "street";

                          // _selectedStreet = "";
                          // searchAddressController.text = "";
                          houseController.text = "";
                          mahallaController.text = "";
                          _selectedHouse = "";
                          widget.ischange = false;
                          suggestionsBoxController.toggle();
                        });
                        validate(null);
                      },
                      child: Container(
                        width: dWidth / 2 - 32,
                        height: 35,
                        decoration: BoxDecoration(
                          color: _street_type
                              ? Color(0xff007BEC)
                              : Color(0xffF5F6F9),
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(178, 183, 208, 0.5)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "street".tr().toString(),
                            style: TextStyle(
                                color:
                                    _street_type ? Colors.white : Colors.black,
                                fontFamily: globals.font,
                                fontWeight: FontWeight.w500,
                                fontSize: dWidth * globals.fontSize14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _all_type = false;
                          _street_type = false;
                          _quarter_type = true;
                          _massiv_type = false;
                          placeType = "quarter";

                          // _selectedStreet = "";
                          // searchAddressController.text = "";
                          houseController.text = "";
                          mahallaController.text = "";
                          _selectedHouse = "";
                          widget.ischange = false;
                          suggestionsBoxController.toggle();
                        });

                        validate(null);
                      },
                      child: Container(
                        width: dWidth / 2 - 20,
                        height: 35,
                        decoration: BoxDecoration(
                          color: _quarter_type
                              ? Color(0xff007BEC)
                              : Color(0xffF5F6F9),
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(178, 183, 208, 0.5)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "quarter".tr().toString(),
                            style: TextStyle(
                                color:
                                    _quarter_type ? Colors.white : Colors.black,
                                fontFamily: globals.font,
                                fontWeight: FontWeight.w500,
                                fontSize: dWidth * globals.fontSize14),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _all_type = false;
                          _street_type = false;
                          _quarter_type = false;
                          _massiv_type = true;
                          placeType = "massif";

                          // _selectedStreet = "";
                          // searchAddressController.text = "";
                          houseController.text = "";
                          mahallaController.text = "";
                          _selectedHouse = "";
                          widget.ischange = false;
                          suggestionsBoxController.toggle();
                        });
                        validate(null);
                      },
                      child: Container(
                        width: dWidth / 2 - 32,
                        height: 35,
                        decoration: BoxDecoration(
                          color: _massiv_type
                              ? Color(0xff007BEC)
                              : Color(0xffF5F6F9),
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(178, 183, 208, 0.5)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "massif".tr().toString(),
                            style: TextStyle(
                                color:
                                    _massiv_type ? Colors.white : Colors.black,
                                fontFamily: globals.font,
                                fontWeight: FontWeight.w500,
                                fontSize: dWidth * globals.fontSize14),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    child: TypeAheadField(
                      addWidth: 50,
                      offsetLeft: 10,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: searchAddressController,
                        autofocus: false,
                        decoration: InputDecoration.collapsed(
                          hintText: "select_street".tr().toString(),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .display1
                              .copyWith(fontSize: dWidth * globals.fontSize18),
                        ),
                      ),
                      hideOnEmpty: true,
                      suggestionsCallback: (pattern) async {
                        return await getStreet(pattern, placeType);
                      },
                      suggestionsBoxController: suggestionsBoxController,
                      itemBuilder: (context, suggestion) {
                        var tempDistrict = suggestion["district"][
                                    "name_${(globals.lang).tr().toString()}"] ==
                                ""
                            ? ""
                            : suggestion["district"]
                                    ["name_${(globals.lang).tr().toString()}"] +
                                ", ";
                        return ListTile(
                          title: _selectedDistrict == null
                              ? Text(suggestion[
                                  "address_${(globals.lang).tr().toString()}"])
                              : Text(tempDistrict +
                                  suggestion[
                                      "full_name_${(globals.lang).tr().toString()}"]),
                        );
                      },
                      suggestionsBoxDecoration:
                          SuggestionsBoxDecoration(offsetX: -20.0),
                      onSuggestionSelected: (suggestion) {
                        if (_selectedDistrict == null) {
                          setState(() {
                            _selectedHouse = "";

                            _selectedDistrict =
                                suggestion["district"]["id"].toString();
                            _selectedStreet = suggestion["id"].toString();
                          });
                          // _selectedStreet = suggestion["district"]["name"];
                          searchAddressController.text = suggestion[
                                  "name_${(globals.lang).tr().toString()}"] +
                              (suggestion["tags_${(globals.lang).tr().toString()}"] ==
                                          null ||
                                      suggestion[
                                              "tags_${(globals.lang).tr().toString()}"] ==
                                          ""
                                  ? ""
                                  : " (" +
                                      suggestion[
                                          "tags_${(globals.lang).tr().toString()}"] +
                                      ")");
                          // mahallaController.text = suggestion["community"]
                          //     ["name_${(globals.lang).tr().toString()}"];

                          validate(suggestion);
                        } else {
                          _selectedStreet = suggestion["id"].toString();
                          searchAddressController.text = suggestion[
                              "full_name_${(globals.lang).tr().toString()}"];

                          setState(() {
                            houseController.text = "";
                            mahallaController.text = "";
                            widget.ischange = false;
                            _selectedHouse = "";
                          });
                          validate(null);
                        }
                      },
                      noItemsFoundBuilder: (context) {
                        return Text("not_found".tr().toString());
                      },
                    )),
              ],
            ),
          ),

          // Stack(
          //   alignment: AlignmentDirectional.topStart,
          //   fit: StackFit.loose,
          //   overflow: Overflow.visible,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          //       margin: EdgeInsets.symmetric(vertical: 10),
          //       width: double.infinity,
          //       height: 45,
          //       decoration: BoxDecoration(
          //         color: Color(0xffF5F6F9),
          //         borderRadius: BorderRadius.circular(22.5),
          //         border: Border.all(
          //           color: Color.fromRGBO(178, 183, 208, 0.5),
          //           style: BorderStyle.solid,
          //           width: 0.5,
          //         ),
          //       ),
          //       child: Row(
          //         children: [
          //           Container(
          //             width: (mediaQuery.size.width -
          //                     mediaQuery.padding.left -
          //                     mediaQuery.padding.right) *
          //                 0.74,
          //             child: TextField(
          //               onChanged: (value) async {
          //                 await getStreet(value, placeType);
          //               },
          //               controller: searchAddressController,
          //               maxLines: 1,
          //               decoration: InputDecoration.collapsed(
          //                 hintText: "",
          //                 hintStyle: Theme.of(context)
          //                     .textTheme
          //                     .display1
          //                     .copyWith(
          //                         fontSize: mediaQuery.size.width *
          //                             globals.fontSize18),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Positioned(
          //       top: 60,
          //       child: Container(
          //         color: Colors.red,
          //         width: dWidth - 40,
          //         height: 200,
          //         child: Text("asdasda"),
          //       ),
          //     ),
          //   ],
          // ),
          MainText("${"houses".tr().toString()}*"),
          Container(
            // decoration: BoxDecoration(
            //     border: Border.all(color: Theme.of(context).primaryColor)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      InkWell(
                        onTap: () {
                          if (_isHouse) {
                            setState(() {
                              _isHouse = false;
                            });
                          } else {
                            setState(() {
                              _isHouse = true;
                            });
                          }
                          Timer(Duration(milliseconds: 300), () {
                            suggestionsHouseBoxController.open();
                          });
                        },
                        child: Container(
                          width: (mediaQuery.size.width -
                                  mediaQuery.padding.left -
                                  mediaQuery.padding.right) *
                              (mediaQuery.size.width <= 360 ? 0.74 : 0.78),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _selectedHouse == null
                                    ? Text(
                                        "select_houses".tr().toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(
                                                fontSize: dWidth *
                                                    globals.fontSize18),
                                      )
                                    : Text(
                                        _selectedHouse,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(
                                                fontSize:
                                                    dWidth * globals.fontSize18,
                                                color: Colors.black),
                                      ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          // );
                        ),
                      ),
                    ],
                  ),
                ),
                _isHouse
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        margin: EdgeInsets.symmetric(),
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
                                child: TypeAheadField(
                                  suggestionsBoxController:
                                      suggestionsHouseBoxController,
                                  suggestionsBoxDecoration:
                                      SuggestionsBoxDecoration(offsetX: -20.0),
                                  addWidth: 55,
                                  offsetLeft: 10,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: houseController,
                                    autofocus: false,
                                    decoration: InputDecoration.collapsed(
                                      hintText: "",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                              fontSize:
                                                  dWidth * globals.fontSize18),
                                    ),
                                  ),
                                  hideOnEmpty: true,
                                  suggestionsCallback: (pattern) async {
                                    return await getHouse(pattern);
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion["number"]),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    mahallaController.text = suggestion[
                                            "community"][
                                        "name_${(globals.lang).tr().toString()}"];
                                    // houseController.text = suggestion["number"];
                                    setState(() {
                                      _selectedHouse = suggestion["number"];
                                      _isHouse = false;
                                    });
                                    houseController.text = "";
                                    print(suggestion["with_flats"]);
                                    if (suggestion["with_flats"]) {
                                      setState(() {
                                        with_flats = true;
                                      });
                                    } else {
                                      setState(() {
                                        with_flats = false;
                                      });
                                    }

                                    validate(suggestion);
                                    _suggets = suggestion;
                                  },
                                  noItemsFoundBuilder: (context) {
                                    return Text("not_found".tr().toString());
                                  },
                                )),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          widget.isFlat && with_flats
              ? MainText("flat".tr().toString())
              : Container(),
          widget.isFlat && with_flats
              ? DefaultInput(
                  hint: "enter_flat".tr().toString(),
                  inputType: TextInputType.text,
                  textController: flatController,
                  notifyParent: () {
                    validate(_suggets);
                  },
                )
              : Container(),
          MainText("mahalla".tr().toString()),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      0.71,
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: mahallaController,
                    maxLines: 1,
                    decoration: InputDecoration.collapsed(
                      hintText: "here_mahalla".tr().toString(),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(fontSize: dWidth * globals.fontSize18),
                    ),
                    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.7)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
