import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_radio_button/group_radio_button.dart';
import '../../screen/profile/delete_profile.dart';
import '../../screen/profile/info_page.dart';
import '../../screen/profile/profile_page.dart';
import '../../widget/custom_card_list.dart';
import '../../widget/default_button.dart';
import '../../widget/icon_card_list.dart';
import '../../widget/shadow_box.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  String _singleValue = "Text alignment right";
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(4, 6), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            title: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    "Пулатов Мавлонбек",
                    style: Theme.of(context).textTheme.display2,
                  ),
                  Text(
                    "+998 97 904 5005",
                    style: TextStyle(
                        color: Color(0xff66676C),
                        fontSize: 14,
                        fontFamily: "Gilroy"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  "Мои сообщения",
                  style: TextStyle(
                    color: Color(0xff66676C),
                    fontFamily: "Gilroy",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ShadowBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCardList(
                        "subcat1", "Нерешенные проблемы", null, true),
                    CustomCardList("subcat2", "Решенные проблемы", null, true),
                    CustomCardList(
                        "subcat3", "Отклоненные проблемы", null, false),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  "Общие",
                  style: TextStyle(
                    color: Color(0xff66676C),
                    fontFamily: "Gilroy",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
                    IconCardList("id", "assets/img/profile_icon.svg", "Профиль",
                        ProfilePage(), true, Icons.arrow_forward_ios),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: (mediaQuery.size.width -
                                              mediaQuery.padding.left -
                                              mediaQuery.padding.right) *
                                          0.84,
                                      child: Container(
                                          child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(right: 13),
                                            child: SvgPicture.asset(
                                                "assets/img/lang_icon.svg"),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "Изменить язык",
                                              style: TextStyle(
                                                fontFamily: "Gilroy",
                                                color: Color(0xff050505),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))),
                                  Container(
                                    child: Icon(
                                      Icons.more_horiz,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      height: 260,
                                      padding: const EdgeInsets.all(25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Выберите язык",
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 15),
                                            child: RadioButton(
                                              description: "Русский",
                                              value: "Русский",
                                              groupValue: _singleValue,
                                              onChanged: (value) => setState(
                                                () => _singleValue = value,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: RadioButton(
                                              description: "O‘zbek",
                                              value: "O‘zbek",
                                              groupValue: _singleValue,
                                              onChanged: (value) => setState(
                                                () => _singleValue = value,
                                              ),
                                            ),
                                          ),
                                          DefaultButton("Применять", () {},
                                              Theme.of(context).primaryColor),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    IconCardList(
                        "id",
                        "assets/img/info_icon.svg",
                        "О приложении",
                        InfoPage(),
                        true,
                        Icons.arrow_forward_ios),
                    IconCardList(
                        "id",
                        "assets/img/quit_icon.svg",
                        "Выйти из аккаунта",
                        Container(),
                        false,
                        Icons.arrow_forward_ios),
                  ],
                ),
              ),
              ShadowBox(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "У тебя есть идея?",
                        style: TextStyle(
                          color: Color(0xff313B6C),
                          fontFamily: "Gilroy",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Перейти на сайт, в разделе «Идеи» Вы можете отправить свои предложения по улучшению городской инфраструктуры, а также оценить идеи, поданные другими пользователями.",
                          style: TextStyle(
                            color: Color(0xff050505),
                            fontFamily: "Gilroy",
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: DefaultButton(
                          "Перейти на сайт",
                          () {},
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(7),
              )
            ],
          ),
        ),
      ),
    );
  }
}
