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

class AddressSearch extends StatefulWidget {
  Function setAddress;
  AddressSearch({this.setAddress, Key key}) : super(key: key);

  @override
  _AddressSearchState createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  List<String> placeType = ["street", "quarter", "massif", "all"];

  // List<DropdownMenuItem<String>> _district;
  String _selectedType;

  List<DropdownMenuItem<String>> _district;
  String _selectedDistrict;
  String _selectedStreet;

  TextEditingController searchAddressController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController mahallaController = TextEditingController();

  //  = menuItems
  //     .map(
  //       (String val) => DropdownMenuItem<String>(
  //         child: Text(val),
  //         value: val,
  //       ),
  //     )
  //     .toList();
  @override
  void initState() {
    super.initState();
    getDistricts();
  }

  getDistricts() async {
    try {
      Map<String, String> headers = {
        "Authorization": "42e3edd0-a430-11ea-bb37-0242ac130002",
        "Accept-Language": globals.lang == "ru" ? "ru" : "uz"
      };
      var url = 'https://data.xalqnazorati.uz/api/v1/addresses/districts';
      var r1 = await Requests.get(url, headers: headers);
      if (r1.statusCode == 200) {
        var json = r1.json();
        _district = convertToList(json["data"]);
        setState(() {});
        // return json.toList();
      }
    } catch (e) {
      print(e);
    }
  }

  getStreet(String value) async {
    try {
      Map<String, String> headers = {
        "Authorization": "42e3edd0-a430-11ea-bb37-0242ac130002",
        "Accept-Language": globals.lang == "ru" ? "ru" : "uz"
      };
      var url =
          'https://data.xalqnazorati.uz/api/v1/addresses/streets?q=$value&district_id=$_selectedDistrict';
      if (_selectedType != "all_parametr") {
        url += "&type=$_selectedType";
      }
      var r1 = await Requests.get(url, headers: headers);
      if (r1.statusCode == 200) {
        var json = r1.json();
        return json["data"];
      }
    } catch (e) {
      print(e);
    }
  }

  getHouse(String value) async {
    try {
      Map<String, String> headers = {
        "Authorization": "42e3edd0-a430-11ea-bb37-0242ac130002",
        "Accept-Language": globals.lang == "ru" ? "ru" : "uz"
      };
      var url =
          'https://data.xalqnazorati.uz/api/v1/addresses/houses?q=$value&street_id=$_selectedStreet';

      var r1 = await Requests.get(url, headers: headers);
      if (r1.statusCode == 200) {
        var json = r1.json();
        return json["data"];
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
    json.forEach((val) {
      res.add(DropdownMenuItem<String>(
        value: val["id"].toString(),
        child: Text(val["name"]),
      ));
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainText("district".tr().toString()),
          DefaultSelect(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                items: _district,
                onChanged: (val) {
                  setState(() {
                    _selectedDistrict = val;
                  });
                },
                hint: Text("select_district".tr().toString()),
                value: _selectedDistrict,
              ),
            ),
          ),
          MainText("placeType".tr().toString()),
          DefaultSelect(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                items: <String>["street", "quarter", "massif", "all"]
                    .map<DropdownMenuItem<String>>((String e) {
                  return DropdownMenuItem<String>(
                    child: Text(e.tr().toString()),
                    value: e,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedType = val;
                  });
                },
                hint: Text("select_placeType".tr().toString()),
                value: _selectedType,
              ),
            ),
          ),
          MainText("streets".tr().toString()),
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
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: searchAddressController,
                        autofocus: false,
                        decoration: InputDecoration.collapsed(
                          hintText: "select_street".tr().toString(),
                          hintStyle: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      hideOnEmpty: true,
                      suggestionsCallback: (pattern) async {
                        return await getStreet(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion["full_name"]),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        _selectedStreet = suggestion["id"].toString();
                        searchAddressController.text = suggestion["full_name"];
                      },
                    )),
              ],
            ),
          ),
          MainText("houses".tr().toString()),
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
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: houseController,
                        autofocus: false,
                        decoration: InputDecoration.collapsed(
                          hintText: "select_houses".tr().toString(),
                          hintStyle: Theme.of(context).textTheme.display1,
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
                        widget.setAddress(suggestion);
                        mahallaController.text =
                            suggestion["community"]["name"];
                        houseController.text = suggestion["number"];
                      },
                    )),
              ],
            ),
          ),
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
                      hintStyle: Theme.of(context).textTheme.display1,
                    ),
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
