import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/models/addresses.dart';
import 'package:xalq_nazorati/widget/input/default_input.dart';
import 'package:xalq_nazorati/widget/input/default_select.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// import '../../flutter_typeahead/lib/flutter_typeahead.dart';
_AddressSearchState addressState;

class AddressSearch extends StatefulWidget {
  Function setAddress;
  bool ischange;
  bool isFlat = false;
  FocusNode streetNode;
  FocusNode houseNode;
  FocusNode apartNode;

  AddressSearch(
      {this.setAddress,
      this.ischange,
      this.isFlat,
      this.apartNode,
      this.houseNode,
      this.streetNode,
      Key key})
      : super(key: key);

  @override
  _AddressSearchState createState() {
    addressState = _AddressSearchState();
    return addressState;
  }
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
  String _selectedStreet = "";
  String _selectedHouse = "";
  bool _isHouse = false;
  bool _isSelectedStreet = false;
  bool _isSelectedHouse = false;

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
        "Authorization": "token ${globals.addressToken}",
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
        "Authorization": "token ${globals.addressToken}",
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
        "Authorization": "token ${globals.addressToken}",
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

  customDialog(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
          return Container(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              width: MediaQuery.of(context).size.width,
              height: 50, //MediaQuery.of(context).size.height * 0.5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          if (!focus) {
                            if (_selectedStreet == "") {
                              setState(() {
                                _isSelectedStreet = true;
                                searchAddressController.text = "";
                              });
                            } else {
                              _isSelectedStreet = false;
                            }
                          }
                          // widget.streetNode.requestFocus();
                        },
                        child: Container(
                          width: (mediaQuery.size.width -
                                  mediaQuery.padding.left -
                                  mediaQuery.padding.right) *
                              0.74,
                          margin: EdgeInsets.only(top: 20),
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: TypeAheadField(
                              addWidth: 65,
                              offsetLeft: 15,
                              textFieldConfiguration: TextFieldConfiguration(
                                onSubmitted: (value) {
                                  Navigator.pop(context, false);
                                },
                                focusNode: widget.streetNode,
                                controller: searchAddressController,
                                autofocus: true,
                                decoration: InputDecoration.collapsed(
                                  hintText: "".tr().toString(),
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
                                return await getStreet(pattern, placeType);
                              },
                              suggestionsBoxController:
                                  suggestionsBoxController,
                              itemBuilder: (context, suggestion) {
                                var tempDistrict = suggestion["district"][
                                            "name_${(globals.lang).tr().toString()}"] ==
                                        ""
                                    ? ""
                                    : suggestion["district"][
                                            "name_${(globals.lang).tr().toString()}"] +
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
                                  streetSetState("", "", false, "");
                                  _selectedStreet = suggestion["id"].toString();
                                  _selectedHouse = "";

                                  _selectedDistrict =
                                      suggestion["district"]["id"].toString();

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

                                  Navigator.pop(context, false);
                                  validate(suggestion);
                                } else {
                                  try {
                                    _selectedStreet =
                                        suggestion["id"].toString();
                                    searchAddressController.text = suggestion[
                                        "full_name_${(globals.lang).tr().toString()}"];

                                    streetSetState("", "", false, "");
                                    Navigator.pop(context, false);
                                    validate(null);
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              noItemsFoundBuilder: (context) {
                                return Text("not_found".tr().toString());
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  customHouseDialog(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
          return Container(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              width: MediaQuery.of(context).size.width,
              height: 50, //MediaQuery.of(context).size.height * 0.5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    FocusScope(
                      child: Focus(
                        onFocusChange: (focus) {
                          if (!focus) {
                            if (_selectedHouse == "") {
                              setState(() {
                                _isSelectedHouse = true;
                                houseController.text = "";
                              });
                            } else {
                              _isSelectedHouse = false;
                            }
                          }
                          // widget.streetNode.requestFocus();
                        },
                        child: Container(
                          width: (mediaQuery.size.width -
                                  mediaQuery.padding.left -
                                  mediaQuery.padding.right) *
                              0.74,
                          margin: EdgeInsets.only(top: 20),
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: TypeAheadField(
                              suggestionsBoxController:
                                  suggestionsHouseBoxController,
                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(offsetX: -20.0),
                              addWidth: 65,
                              offsetLeft: 15,
                              textFieldConfiguration: TextFieldConfiguration(
                                onSubmitted: (value) {
                                  Navigator.pop(context, false);
                                },
                                focusNode: widget.houseNode,
                                controller: houseController,
                                autofocus: true,
                                decoration: InputDecoration.collapsed(
                                  hintText: "".tr().toString(),
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
                                mahallaController.text = suggestion["community"]
                                    ["name_${(globals.lang).tr().toString()}"];
                                houseController.text = suggestion["number"];

                                setState(() {
                                  _selectedHouse = suggestion["number"];
                                  _isHouse = false;
                                });
                                if (suggestion["with_flats"]) {
                                  setState(() {
                                    with_flats = true;
                                  });
                                } else {
                                  setState(() {
                                    with_flats = false;
                                  });
                                }

                                Navigator.pop(context);
                                validate(suggestion);
                                _suggets = suggestion;
                              },
                              noItemsFoundBuilder: (context) {
                                return Text("not_found".tr().toString());
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  streetSetState(house, mahalla, _isChange, sHouse) {
    addressState.setState(() {
      houseController.text = house;
      mahallaController.text = mahalla;
      widget.ischange = _isChange;
      _selectedHouse = sHouse;
    });
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
    return Stack(
      children: [
        Container(
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
                              // suggestionsBoxController.toggle();
                            });
                            validate(null);
                          },
                          child: Container(
                            width: dWidth / 2 - 20,
                            height: 35,
                            decoration: BoxDecoration(
                              color: _all_type
                                  ? Color(0xff007BEC)
                                  : Color(0xffF5F6F9),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(178, 183, 208, 0.5)),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Center(
                              child: Text(
                                "all".tr().toString(),
                                style: TextStyle(
                                    color:
                                        _all_type ? Colors.white : Colors.black,
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
                              // suggestionsBoxController.toggle();
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
                                    color: _street_type
                                        ? Colors.white
                                        : Colors.black,
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
                              // suggestionsBoxController.toggle();
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
                                    color: _quarter_type
                                        ? Colors.white
                                        : Colors.black,
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
                              // suggestionsBoxController.toggle();
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
                                    color: _massiv_type
                                        ? Colors.white
                                        : Colors.black,
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
              InkWell(
                onTap: () {
                  // widget.streetNode.requestFocus();
                  customDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xffF5F6F9),
                    borderRadius: BorderRadius.circular(22.5),
                    border: Border.all(
                      color: _isSelectedStreet
                          ? Color(0xffFF5555)
                          : Color.fromRGBO(178, 183, 208, 0.5),
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
                        child:
                            // FocusScope(
                            //   child:
                            // Focus(
                            //   onFocusChange: (focus) {
                            //     FocusScope.of(context).unfocus();
                            //     widget.streetNode.requestFocus();
                            //   },
                            //   child:
                            TextField(
                          controller: searchAddressController,
                          enabled: false,
                          decoration: InputDecoration.collapsed(
                            hintText: "select_street".tr().toString(),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                    fontSize: dWidth * globals.fontSize18),
                          ),
                        ),
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              MainText("${"houses".tr().toString()}*"),
              InkWell(
                onTap: () {
                  // widget.streetNode.requestFocus();
                  customHouseDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xffF5F6F9),
                    borderRadius: BorderRadius.circular(22.5),
                    border: Border.all(
                      color: _isSelectedHouse
                          ? Color(0xffFF5555)
                          : Color.fromRGBO(178, 183, 208, 0.5),
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
                          controller: houseController,
                          enabled: false,
                          decoration: InputDecoration.collapsed(
                            hintText: "select_houses".tr().toString(),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                    fontSize: dWidth * globals.fontSize18),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        focusNode: widget.apartNode,
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
        ),
      ],
    );
  }
}
