import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sms/sms.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/address_search.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/widget/input/default_input.dart';
import 'package:xalq_nazorati/widget/input/phone_input.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ChangePersonalData extends StatefulWidget {
  @override
  _ChangePersonalDataState createState() => _ChangePersonalDataState();
}

class _ChangePersonalDataState extends State<ChangePersonalData> {
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  String address;
  bool _value = false;
  Map<String, dynamic> bigData = {};

  final codeController = TextEditingController();

  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        print("reach the bottom");
      });
    }
  }

  Future changeProfile() async {
    try {
      String email = emailController.text;
      String code = "${codeController.text}";
      if (address != "") {
        var url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/profile';

        Map<String, dynamic> map = {};
        // if (address != '') map.addAll({"address_str": address});
        // if (email != '') map.addAll({"email": email});
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}",
        };
        map.addAll(bigData);
        // var req = await http.put(Uri.parse(url), headers: headers, body: map);
        var r1 =
            await Requests.put(url, body: map, headers: headers, verify: false);

        if (r1.statusCode == 200) {
          r1.raiseForStatus();
          Map<String, dynamic> reply = await r1.json();

          globals.userData = reply;
          Navigator.pop(context, address);
        } else {
          var res = r1.json();
          print(res);
        }
      } else {
        Fluttertoast.showToast(
            msg: "fill_personal_data".tr().toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } catch (e) {
      print(e);
    }
  }

  setAddress(var addr, flatController, var isChange) {
    if (addr != null) {
      address =
          "${addr['community']['district']["name_${(globals.lang).tr().toString()}"]}, ${addr['street']["name_${(globals.lang).tr().toString()}"]}, ${addr['community']["name_${(globals.lang).tr().toString()}"]}, ${addr['number']}";
      bigData = {
        "district_id": addr['community']['district']["id"],
        "community_id": addr['community']["id"],
        "street_id": addr['street']["id"],
        "house_id": addr["id"]
      };
      if (flatController.text != "") {
        address += ", ${flatController.text}";
        bigData.addAll({"apartment": flatController.text});
      }
    }

    if (isChange) {
      setState(() {
        _value = true;
      });
    } else {
      setState(() {
        _value = false;
      });
    }

    // latlang = Point(
    //     latitude: double.tryParse(addr['latitude']),
    //     longitude: double.tryParse(addr['longitude']));
  }

  checkChange() {}

  @override
  Widget build(BuildContext context) {
    print(globals.userData);
    final mediaQuery = MediaQuery.of(context);
    final appbar = CustomAppBar(
      title: "change_address".tr().toString(),
      centerTitle: true,
    );
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appbar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShadowBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AddressSearch(
                                setAddress: setAddress,
                                isFlat: true,
                                ischange: _value,
                              ),

                              // MainText("email_title".tr().toString()),
                              // DefaultInput(
                              //   hint: "email_hint".tr().toString(),
                              //   textController: emailController,
                              //   notifyParent: checkChange,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(38),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: !_value
                                ? DefaultButton(
                                    "change".tr().toString(),
                                    () {},
                                    Color(0xffB2B7D0),
                                  )
                                : DefaultButton("change".tr().toString(), () {
                                    changeProfile();
                                    // setState(() {
                                    //   _value = !_value;
                                    // });
                                    // Navigator.of(context)
                                    //     .pushNamed(PasRecognizedScreen.routeName);
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
        ),
      ),
    );
  }
}
