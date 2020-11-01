import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';
import 'package:xalq_nazorati/screen/rule_page.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/support/support.dart';
import '../../widget/icon_card_list.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/shadow_box.dart';

class InfoPage extends StatefulWidget {
  static const routeName = "/info-page";

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  _share_app(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(
        "https://play.google.com/store/apps/details?id=com.apple.android.music&hl=ru&gl=US",
        subject: "",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "about_app".tr().toString(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/img/Frame.svg"),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "about_desc".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: globals.font,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
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
                                                "assets/img/share_icon.svg"),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "share_app".tr().toString(),
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
                                      null,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              _share_app(context);
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    IconCardList("id", "assets/img/rate_icon.svg",
                        "rate_app".tr().toString(), null, true, null),
                    IconCardList(
                        "id",
                        "assets/img/support_icon.svg",
                        "technical_support".tr().toString(),
                        Support(),
                        true,
                        null),
                    IconCardList(
                        "id",
                        "assets/img/rule_icon.svg",
                        "rule_of_moderation".tr().toString(),
                        RulePage(),
                        false,
                        null),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    "v1.0.0 (beta)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff66676C),
                      fontFamily: globals.font,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
