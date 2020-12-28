import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/models/addresses.dart';
import 'package:xalq_nazorati/screen/address_search.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/login_screen.dart';
import 'package:xalq_nazorati/widget/input/pass_input.dart';
import '../rule_page.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/shadow_box.dart';
import '../../widget/default_button.dart';
import '../../widget/input/default_input.dart';
import '../../widget/text/main_text.dart';

class RegisterPersonalDataScreen extends StatefulWidget {
  static const routeName = "/register-personal-data";

  @override
  _RegisterPersonalDataScreenState createState() =>
      _RegisterPersonalDataScreenState();
}

class _RegisterPersonalDataScreenState
    extends State<RegisterPersonalDataScreen> {
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passController = TextEditingController();
  final repassController = TextEditingController();
  bool isLogin = false;
  bool _value = false;
  String address = "";
  Map bigData = {};

  Future sendData() async {
    String email = emailController.text;

    String pass = passController.text;
    String repass = repassController.text;
    if (_value && address != "") {
      try {
        String url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/signup';
        Map map = {
          "email": email,
          'address_str': address,
          'password': pass,
          'password2': repass,
          'agreement': _value,
        };
        // String url = '${globals.api_link}/users/get-phone';
        var r1 = await Requests.post(url,
            body: map, verify: false, persistCookies: true);

        if (r1.statusCode == 201) {
          getLogin();
        } else {
          var json = r1.json();
          Map<String, dynamic> res = json['detail'];
          print(json);
          res.forEach((key, value) {
            Fluttertoast.showToast(
                msg: res[key][0],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 15.0);
          });
        }
      } catch (e) {
        print(e);
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
  }

  void getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', null);
    String phone = globals.tempPhone;
    String pass = passController.text;
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/signin';
    Map map = {
      "phone": phone,
      "password": pass,
      "fcm_token": globals.deviceToken,
      "device_type": globals.device,
      "lang": globals.lang.tr().toString(),
    };
    map.addAll(bigData);
    var response = await Requests.post(
      url,
      body: map,
    );
    // request.methodPost(map, url);
    if (response.statusCode == 200) {
      // Map<String,dynamic> reply = response.json();

      Map<String, dynamic> responseBody = response.json();
      addStringToSF(responseBody["token"]);
      globals.token = responseBody["token"];
      isLogin = true;
    } else {
      Map<String, dynamic> responseBody = response.json();
      Fluttertoast.showToast(
          msg: responseBody['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15.0);
    }

    if (isLogin)
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      }),
          (Route<dynamic> route) =>
              false); //Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  setAddress(var addr, flatController, isChanged) {
    print(addr);
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

    validate();
    // latlang = Point(
    //     latitude: double.tryParse(addr['latitude']),
    //     longitude: double.tryParse(addr['longitude']));
  }

  void validate() {
    if (address != "" &&
        passController.text != "" &&
        repassController.text != "") {
      setState(() {
        _value = true;
      });
    }
    print("validate");
  }

  @override
  Widget build(BuildContext context) {
    var appbar = CustomAppBar(
      title: "confirm_data".tr().toString(),
    );
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
    print(dWith);
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appbar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              // height: mediaQuery.size.height < 560
              //     ? mediaQuery.size.height
              //     : mediaQuery.size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: 10, horizontal: 20),
                          //   margin: EdgeInsets.symmetric(vertical: 10),
                          //   width: double.infinity,
                          //   height: 45,
                          //   decoration: BoxDecoration(
                          //     color: Color(0xffF5F6F9),
                          //     borderRadius: BorderRadius.circular(22.5),
                          //     border: Border.all(
                          //       color: Color.fromRGBO(178, 183, 208, 0.5),
                          //       style: BorderStyle.solid,
                          //       width: 0.5,
                          //     ),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //           width: (mediaQuery.size.width -
                          //                   mediaQuery.padding.left -
                          //                   mediaQuery.padding.right) *
                          //               0.74,
                          //           child: TypeAheadField(
                          //             textFieldConfiguration:
                          //                 TextFieldConfiguration(
                          //               controller: addressController,
                          //               autofocus: false,
                          //               decoration: InputDecoration.collapsed(
                          //                 hintText:
                          //                     "address_hint".tr().toString(),
                          //                 hintStyle: Theme.of(context)
                          //                     .textTheme
                          //                     .display1,
                          //               ),
                          //             ),
                          //             hideOnEmpty: true,
                          //             suggestionsCallback: (pattern) async {
                          //               return await changeAddress(pattern);
                          //             },
                          //             itemBuilder: (context, suggestion) {
                          //               return ListTile(
                          //                 title: Text(suggestion.address),
                          //               );
                          //             },
                          //             onSuggestionSelected: (suggestion) {
                          //               print(suggestion.address);
                          //               addressController.text =
                          //                   suggestion.address;
                          //             },
                          //           )),
                          //     ],
                          //   ),
                          // ),
                          // MainText("email_title".tr().toString()),
                          // DefaultInput(
                          //   hint: "email_hint".tr().toString(),
                          //   textController: emailController,
                          //   notifyParent: () {},
                          //   inputType: TextInputType.emailAddress,
                          // ),
                          MainText("${"pass_title".tr().toString()}*"),
                          PassInput(
                            "come_up_pass_hint".tr().toString(),
                            passController,
                            () {
                              validate();
                            },
                          ),
                          MainText("${"confirm_pass_title".tr().toString()}*"),
                          PassInput(
                            "confirm_pass_hint".tr().toString(),
                            repassController,
                            () {
                              validate();
                            },
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 10),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     InkWell(
                          //       onTap: () {
                          //         setState(() {
                          //           _value = !_value;
                          //         });
                          //       },
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //                 width: 2,
                          //                 style: BorderStyle.solid,
                          //                 color:
                          //                     Theme.of(context).primaryColor),
                          //             shape: BoxShape.circle,
                          //             color: _value
                          //                 ? Theme.of(context).primaryColor
                          //                 : Colors.transparent),
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(5.0),
                          //           child: _value
                          //               ? Icon(
                          //                   Icons.check,
                          //                   size: 15.0,
                          //                   color: Colors.white,
                          //                 )
                          //               : Icon(
                          //                   Icons.check_box_outline_blank,
                          //                   size: 15.0,
                          //                   color: Colors.transparent,
                          //                 ),
                          //         ),
                          //       ),
                          //     ),
                          //     Container(
                          //       padding: EdgeInsets.only(left: 20),
                          //       width: mediaQuery.size.width * 0.76,
                          //       child: RichText(
                          //         text: TextSpan(
                          //           children: [
                          //             TextSpan(
                          //               text: "agree_agreements_start"
                          //                   .tr()
                          //                   .toString(),
                          //               style: TextStyle(
                          //                 fontFamily: globals.font,
                          //                 fontSize: dWith * globals.fontSize12,
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.normal,
                          //               ),
                          //             ),
                          //             TextSpan(
                          //               recognizer: TapGestureRecognizer()
                          //                 ..onTap = () {
                          //                   Navigator.pushNamed(
                          //                       context, RulePage.routeName);
                          //                 },
                          //               text: "agreement".tr().toString(),
                          //               style: TextStyle(
                          //                 decoration: TextDecoration.underline,
                          //                 fontFamily: globals.font,
                          //                 fontSize: dWith * globals.fontSize12,
                          //                 color: Theme.of(context).primaryColor,
                          //                 fontWeight: FontWeight.normal,
                          //               ),
                          //             ),
                          //             TextSpan(
                          //               text: "agree_agreements_end"
                          //                   .tr()
                          //                   .toString(),
                          //               style: TextStyle(
                          //                 fontFamily: globals.font,
                          //                 fontSize: 12,
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.normal,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: !_value
                                  ? DefaultButton(
                                      "continue".tr().toString(),
                                      () {},
                                      Color(0xffB2B7D0),
                                    )
                                  : DefaultButton("continue".tr().toString(),
                                      () {
                                      sendData().then((value) {
                                        setState(() {
                                          _value = !_value;
                                        });
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
          ),
        ),
      ),
    );
  }
}
