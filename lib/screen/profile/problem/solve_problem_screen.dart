import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_solved_rate_screen.dart';
import 'package:xalq_nazorati/widget/problems/image_carousel.dart';
import 'package:xalq_nazorati/widget/problems/problem_solve_desc.dart';
import '../../../widget/app_bar/custom_appBar.dart';
import '../../../widget/default_button.dart';
import '../../../widget/shadow_box.dart';

class SolveProblemScreen extends StatefulWidget {
  bool status = false;
  SolveProblemScreen({this.status});
  @override
  _SolveProblemScreenState createState() => _SolveProblemScreenState();
}

class _SolveProblemScreenState extends State<SolveProblemScreen> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Проблема решена',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ShadowBox(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 19, top: 5, right: 19, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Исполнитель",
                              style: TextStyle(
                                fontFamily: globals.font,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Text(
                              "Пулатов Мавлонбек",
                              style: TextStyle(
                                fontFamily: globals.font,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Дата исполнения",
                              style: TextStyle(
                                fontFamily: globals.font,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Text(
                              "04.08.2020",
                              style: TextStyle(
                                fontFamily: globals.font,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 19),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Описание решении",
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Text(
                          "При получении неудовлетворительных результатов при испытаниях хотя бы по одному из требований настоящей программы проводятся повторные испытания удвоенного числа Комплексов по пунктам",
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 19),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Документы",
                          style: TextStyle(
                            fontFamily: globals.font,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Container(
                          height: 80,
                          child: GridView.builder(
                            padding: EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4,
                            ),
                            itemCount: 4,
                            itemBuilder: (BuildContext ctx, index) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 20,
                                    child: Image.asset("assets/img/pdf.png"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Паспорт проблемы",
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "29.05.2015  0,3 MB",
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: ImageCarousel("Было"),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: ImageCarousel("Стало"),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 19, right: 19),
                    child: Column(
                      children: [
                        ProblemSolveDesc("Заявка", "№00125 от 02.05.2020"),
                        ProblemSolveDesc("Проблема", "Сваленная куча мусора"),
                        ProblemSolveDesc("Место",
                            "Чиланзарский р-н., 11 квартал около дома 5"),
                        ProblemSolveDesc("Выполнено", "02.05.2020"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            !widget.status
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 19),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            color: globals.activeButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return ProblemSolvedRateScreen();
                              }));
                            },
                            child: Text(
                              "Подтвердить",
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            border: Border.all(
                              color: Color(0xffB2B7D0),
                              width: 1,
                            ),
                          ),
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Я не согласен с решением",
                              style: TextStyle(color: Color(0xffB2B7D0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
