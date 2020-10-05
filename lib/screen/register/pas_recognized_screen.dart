import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../widget/app_bar/custom_appBar.dart';
import './register_personaldata_screen.dart';
import '../../widget/card_list.dart';
import '../../widget/default_button.dart';

class PasRecognizedScreen extends StatefulWidget {
  static const routeName = "/register-pas-recognized";
  final dynamic data;

  PasRecognizedScreen({this.data, Key key}) : super(key: key);

  @override
  _PasRecognizedScreenState createState() => _PasRecognizedScreenState();
}

class _PasRecognizedScreenState extends State<PasRecognizedScreen> {
  @override
  Widget build(BuildContext context) {
    var user = widget.data["data"]["user_data"];
    DateFormat formatter = DateFormat('dd.MM.yyyy');

    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: CustomAppBar(title: "Подтверждение данных"),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: mediaQuery.size.height - mediaQuery.size.height * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardList("Имя", user["first_name"]),
                    CardList("Фамилия", user["last_name"]),
                    CardList("Отчество", user["patronymic"]),
                    CardList("Дата рождения",
                        formatter.format(DateTime.parse(user["birth_date"]))),
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
                          child: DefaultButton("Продолжить", () {
                            Navigator.of(context).pushNamed(
                                RegisterPersonalDataScreen.routeName);
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
    );
  }
}
