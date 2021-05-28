import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/methods/dio_connection.dart';
import 'package:xalq_nazorati/methods/helper.dart';
import 'package:xalq_nazorati/screen/address_search.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/widget/input/pass_input.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/shadow_box.dart';
import '../../widget/default_button.dart';
import '../../widget/text/main_text.dart';

_RegisterPersonalDataScreenState registerPersonalDataScreenState;

class RegisterPersonalDataScreen extends StatefulWidget {
  static const routeName = "/register-personal-data";

  @override
  _RegisterPersonalDataScreenState createState() {
    registerPersonalDataScreenState = _RegisterPersonalDataScreenState();
    return registerPersonalDataScreenState;
  }
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
  Helper helper = new Helper();
  Future sendData() async {
    String email = emailController.text;

    String pass = passController.text;
    String repass = repassController.text;
    if (_value && address != "") {
      try {
        String url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/signup';
        Map map = {
          // "email": email,
          // 'address_str': address,
          'password': pass,
          'password2': repass,
          'agreement': _value,
        };
        map.addAll(bigData);
        var connect = new DioConnection();

        Map<String, String> headers = {};
        var response = await connect.postCoockieHttp(
            '/users/signup', registerPersonalDataScreenState, headers, map);

        if (response["statusCode"] == 201) {
          getLogin();
        } else {
          var json = response["result"];
          Map<String, dynamic> res = json['detail'];
          print(json);
          res.forEach((key, value) {
            helper.getToast(res[key][0], context);
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      helper.getToast("fill_personal_data".tr().toString(), context);
    }
  }

  void getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', null);
    String phone = globals.tempPhone;
    String pass = passController.text;
    Map map = {
      "phone": phone,
      "password": pass,
      "fcm_token": globals.deviceToken,
      "device_type": globals.device,
      "lang": globals.lang.tr().toString(),
    };
    var connect = new DioConnection();
    Map<String, String> headers = {};
    var response = await connect.postHttp(
        'users/signin', registerPersonalDataScreenState, headers, map);

    // request.methodPost(map, url);
    if (response["statusCode"] == 200) {
      // Map<String,dynamic> reply = response.json();

      Map<String, dynamic> responseBody = response["result"];
      addStringToSF(responseBody["token"]);
      globals.token = responseBody["token"];
      await getUser();
      isLogin = true;
    } else {
      Map<String, dynamic> responseBody = response["result"];
      helper.getToast(responseBody['message'], context);
    }

    if (isLogin)
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      }),
          (Route<dynamic> route) =>
              false); //Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  getUser() async {
    var connect = new DioConnection();
    Map<String, String> headers = {"Authorization": "token ${globals.token}"};
    var response = await connect.getHttp(
        '/users/profile', registerPersonalDataScreenState, headers);

    if (response["statusCode"] == 200) {
      // dynamic json = response.json();

      globals.userData = response["result"];
      print(globals.userData);
    } else {
      globals.token = null;
      dynamic json = response["result"];
      helper.getToast(json['detail'], context);
    }
    // String reply = await response.transform(utf8.decoder).join();
    // print(response.statusCode);
    // globals.userData = json.decode(reply);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "warning_fact_address".tr().toString(),
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
                  ],
                ),
              ),
            ),
          );
        });
  }

  FocusNode _streetNode = FocusNode();
  FocusNode _houseNode = FocusNode();
  FocusNode _apartNode = FocusNode();
  FocusNode _passNode = FocusNode();
  FocusNode _repassNode = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
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
        KeyboardActionsItem(focusNode: _passNode, toolbarButtons: [
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
        KeyboardActionsItem(focusNode: _repassNode, toolbarButtons: [
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

  @override
  Widget build(BuildContext context) {
    var appbar = CustomAppBar(
      title: "confirm_data".tr().toString(),
    );
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
    print(dWith);
    return Stack(
      children: [
        Scaffold(
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
                          child: Container(
                            child: KeyboardActions(
                              disableScroll: true,
                              // isDialog: true,
                              config: _buildConfig(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "set_fact_address".tr().toString(),
                                    style: TextStyle(
                                      fontFamily: globals.font,
                                      fontSize: dWith * globals.fontSize16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      customDialog(context);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        "why_fact_address".tr().toString(),
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWith * globals.fontSize10,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff0AB394),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AddressSearch(
                                    setAddress: setAddress,
                                    isFlat: true,
                                    streetNode: _streetNode,
                                    houseNode: _houseNode,
                                    apartNode: _apartNode,
                                  ),
                                  MainText("${"pass_title".tr().toString()}*"),
                                  PassInput(
                                    hint: "come_up_pass_hint".tr().toString(),
                                    passController: passController,
                                    notifyParent: () {
                                      validate();
                                    },
                                    textFocusNode: _passNode,
                                  ),
                                  MainText(
                                      "${"confirm_pass_title".tr().toString()}*"),
                                  PassInput(
                                    hint: "confirm_pass_hint".tr().toString(),
                                    passController: repassController,
                                    notifyParent: () {
                                      validate();
                                    },
                                    textFocusNode: _repassNode,
                                  ),
                                ],
                              ),
                            ),
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
                                      : DefaultButton(
                                          "continue".tr().toString(), () {
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
        ),
        CheckConnection(),
      ],
    );
  }
}
