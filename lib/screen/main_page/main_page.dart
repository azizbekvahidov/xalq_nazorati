import 'package:flutter/material.dart';
import '../../widget/idea-widget/list_view.dart';
import '../../widget/search_input.dart';
import '../../widget/category/category_card.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 40, left: 20, right: 20),
              height: 253,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff12B79B),
                    Color(0xff00AC8A),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Привет, Мавлонбек",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Добро пожаловать",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: SearchtInput("Поиск категории"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
              child: Text(
                "Сообщить о проблемы",
                style: TextStyle(
                    color: Color(0xff313B6C),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    CategoryCard("cat1", "Мой дом", 'assets/img/house.svg'),
                    CategoryCard("cat2", "Мой двор", 'assets/img/field.svg'),
                    CategoryCard("cat3", "Моя дорога", 'assets/img/road.svg'),
                  ],
                ),
                Row(
                  children: [
                    CategoryCard("cat4", "Городское пространство",
                        'assets/img/citySpace.svg'),
                    CategoryCard("cat5", "Общественный транспорт",
                        'assets/img/transport.svg'),
                    CategoryCard(
                        "cat6", "Торовля и реклама", 'assets/img/selling.svg'),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Предложенные идеи",
                        style: TextStyle(
                            color: Color(0xff313B6C),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        child: Text(
                          "Смотреть все",
                          style: TextStyle(
                              color: Color(0xff66676C),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 360, child: IdeaList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
