import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/screen/profile/change_password.dart';
import 'package:xalq_nazorati/screen/profile/change_personal_data.dart';
import 'package:xalq_nazorati/screen/profile/change_phone.dart';
import 'package:xalq_nazorati/screen/profile/delete_profile.dart';
import 'package:xalq_nazorati/widget/get_login_dialog.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/card_list.dart';
import '../../widget/custom_card_list.dart';
import '../../widget/shadow_box.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profile-page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _user_address;
  String _user_phone;
  @override
  void initState() {
    super.initState();
    print(globals.userData['gender']);
    _user_address = globals.userData["address"] == null
        ? ""
        : globals.generateAddrStr(globals.userData["address"]);
    _user_phone = "${globals.userData['phone']}";
  }

  String capitalize(String stringVal) {
    if (stringVal == null) {
      throw ArgumentError.notNull('string');
    }

    if (stringVal.isEmpty) {
      return stringVal;
    }
    var res = "";
    for (var i = 0; i < stringVal.length; i++) {
      res += stringVal[i].toLowerCase();
    }

    return res[0].toUpperCase() + res.substring(1);
  }

  customDialog(BuildContext context) {
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
              child: GetLoginDialog(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String birthDate = globals.userData['birth_date'] == null
        ? ""
        : formatter.format(DateTime.parse(globals.userData['birth_date']));
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "profile".tr().toString(),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShadowBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          CardList(
                              "name".tr().toString(),
                              capitalize(
                                  "${globals.userData['first_name'] ?? ""}")),
                          CardList(
                              "surname".tr().toString(),
                              capitalize(
                                  "${globals.userData['last_name'] ?? ""}")),
                          CardList(
                              "lastname".tr().toString(),
                              capitalize(
                                  "${globals.userData['patronymic'] ?? ""}")),
                          CardList("birthday".tr().toString(), "${birthDate}"),
                          CardList(
                              "gender".tr().toString(),
                              "${globals.userData['gender'] ?? ""}"
                                  .tr()
                                  .toString()),
                          CardList(
                              "fact_accress".tr().toString(), _user_address),
                          CardList(
                              "tel_number_hint".tr().toString(), _user_phone),
                        ],
                      ),
                    ),
                  ),
                  ShadowBox(
                    child: Column(
                      children: [
                        // CustomCardList("id", "Изменить личные данные", null, true),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: (mediaQuery.size.width -
                                                  mediaQuery.padding.left -
                                                  mediaQuery.padding.right) *
                                              0.82,
                                          child: Container(
                                              child: RichText(
                                            text: TextSpan(
                                              text: "change_address"
                                                  .tr()
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff050505),
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        globals.fontSize18,
                                              ),
                                            ),
                                          ))),
                                      Container(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  if (globals.token != null) {
                                    var res = await Navigator.of(context,
                                            rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return ChangePersonalData();
                                        },
                                      ),
                                    );
                                    if (res != null) {
                                      setState(() {
                                        _user_address = res;
                                      });
                                    }
                                  } else {
                                    customDialog(context);
                                  }
                                },
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        // CustomCardList(
                        //   "id",
                        //   "change_pass".tr().toString(),
                        //   ChangePassword(),
                        //   true,
                        //   "",
                        //   false,
                        // ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: (mediaQuery.size.width -
                                                  mediaQuery.padding.left -
                                                  mediaQuery.padding.right) *
                                              0.82,
                                          child: Container(
                                              child: RichText(
                                            text: TextSpan(
                                              text:
                                                  "change_pass".tr().toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff050505),
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        globals.fontSize18,
                                              ),
                                            ),
                                          ))),
                                      Container(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  if (globals.token != null) {
                                    await Navigator.of(context,
                                            rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return ChangePassword();
                                        },
                                      ),
                                    );
                                  } else {
                                    customDialog(context);
                                  }
                                },
                              ),
                              Divider(),
                              // Divider(),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: (mediaQuery.size.width -
                                                  mediaQuery.padding.left -
                                                  mediaQuery.padding.right) *
                                              0.82,
                                          child: Container(
                                              child: RichText(
                                            text: TextSpan(
                                              text: "change_phone"
                                                  .tr()
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff050505),
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        globals.fontSize18,
                                              ),
                                            ),
                                          ))),
                                      Container(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  if (globals.token != null) {
                                    var res = await Navigator.of(context,
                                            rootNavigator: true)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return ChangePhone();
                                        },
                                      ),
                                    );
                                    if (res != null) {
                                      setState(() {
                                        _user_phone = res;
                                      });
                                    }
                                  } else {
                                    customDialog(context);
                                  }
                                },
                              ),
                              // Divider(),
                            ],
                          ),
                        ),
                        // CustomCardList(
                        //   "id",
                        //   "delete_profile".tr().toString(),
                        //   DeleteProfile(),
                        //   false,
                        //   "",
                        //   false,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  )
                ],
              ),
            ),
          ),
        ),
        CheckConnection(),
      ],
    );
  }
}
