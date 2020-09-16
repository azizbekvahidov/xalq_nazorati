import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: CustomAppBar(title: "Профиль"),
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
                      CardList("Имя", "Мавлонбек"),
                      CardList("Фамилия", "Пулатов"),
                      CardList("Отчество", "Мухтаровичь"),
                      CardList("Дата рождения", "01.02.1980"),
                      CardList("Пол", "Мужчина"),
                      CardList("Адрес фактического проживания",
                          "Файзиобод мфй, Файзиобод кучаси, 796"),
                    ],
                  ),
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
                    // CustomCardList("id", "Изменить личные данные", null, true),
                    CustomCardList(
                        "id", "Изменить пароль", ChangePassword(), true),
                    CustomCardList("id", "Изменить контактные данные",
                        ChangePersonalData(), true),
                    CustomCardList(
                        "id", "Удалить учетную запись", DeleteProfile(), false),
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