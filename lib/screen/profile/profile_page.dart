import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/profile/change_password.dart';
import 'package:xalq_nazorati/screen/profile/change_personal_data.dart';
import 'package:xalq_nazorati/screen/profile/delete_profile.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/card_list.dart';
import '../../widget/custom_card_list.dart';
import '../../widget/shadow_box.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = "/profile-page";
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String birthDate =
        formatter.format(DateTime.parse(globals.userData['birth_date']));
    return Scaffold(
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
                      CardList("name".tr().toString(),
                          "${globals.userData['first_name']}"),
                      CardList("surname".tr().toString(),
                          "${globals.userData['last_name']}"),
                      CardList("lastname".tr().toString(),
                          "${globals.userData['patronymic']}"),
                      CardList("birthday".tr().toString(), "${birthDate}"),
                      CardList("gender".tr().toString(),
                          "${globals.userData['gender']}".tr().toString()),
                      CardList("fact_accress".tr().toString(),
                          "${globals.userData['address_str']}"),
                    ],
                  ),
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
                    // CustomCardList("id", "Изменить личные данные", null, true),
                    CustomCardList("id", "change_pass".tr().toString(),
                        ChangePassword(), true),
                    CustomCardList("id", "change_profile".tr().toString(),
                        ChangePersonalData(), true),
                    CustomCardList("id", "delete_profile".tr().toString(),
                        DeleteProfile(), false),
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
    );
  }
}
