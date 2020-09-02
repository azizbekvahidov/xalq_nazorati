import 'package:flutter/material.dart';
import './register_personaldata_screen.dart';
import '../../widget/card_list.dart';
import '../../widget/default_button.dart';

class PasRecognizedScreen extends StatefulWidget {
  static const routeName = "/register-pas-recognized";

  @override
  _PasRecognizedScreenState createState() => _PasRecognizedScreenState();
}

class _PasRecognizedScreenState extends State<PasRecognizedScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: AppBar(
        title: Text(
          "Подтверждение данных",
          style: Theme.of(context).textTheme.display2,
        ),
      ),
      body: SingleChildScrollView(
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
                    CardList("Имя", "Мавлонбек"),
                    CardList("Фамилия", "Пулатов"),
                    CardList("Отчество", "Мухтаровичь"),
                    CardList("Дата рождения", "01.02.1980"),
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
