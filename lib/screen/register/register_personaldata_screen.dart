import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/login_screen.dart';
import 'package:xalq_nazorati/widget/input/pass_input.dart';
import '../rule_page.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/shadow_box.dart';
import '../home_page.dart';
import '../../widget/default_button.dart';
import '../../widget/input/default_input.dart';
import '../../widget/text/main_text.dart';

class RegisterPersonalDataScreen extends StatefulWidget {
  static const routeName = "/register-personal-data";

  @override
  _RegisterPersonalDataScreenState createState() =>
      _RegisterPersonalDataScreenState();
}

class _RegisterPersonalDataScreenState
    extends State<RegisterPersonalDataScreen> {
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passController = TextEditingController();
  final repassController = TextEditingController();
  bool _value = false;
  Future sendData() async {
    String email = emailController.text;
    String address = addressController.text;
    String pass = passController.text;
    String repass = repassController.text;
    if (_value && email != "" && address != "") {
      try {
        String url = '${globals.api_link}/users/signup';
        Map map = {
          "email": email,
          'address_str': address,
          'password': pass,
          'password2': repass,
          'agreement': _value,
        };
        // String url = '${globals.api_link}/users/get-phone';
        var r1 = await Requests.post(url,
            body: map, verify: false, persistCookies: true);

        if (r1.statusCode == 201) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName, (Route<dynamic> route) => false);
        } else {
          var json = r1.json();
          Map<String, dynamic> res = json['detail'];
          print(json);
          res.forEach((key, value) {
            Fluttertoast.showToast(
                msg: res[key][0],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 15.0);
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appbar = CustomAppBar(
      title: "Подтверждение данных",
    );
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
    print(dWith);
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appbar,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: mediaQuery.size.height - mediaQuery.size.height * 0.12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShadowBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText("Адрес фактического проживания"),
                        DefaultInput(
                          hint: "Введите адрес",
                          textController: addressController,
                          notifyParent: () {},
                        ),
                        MainText("Электронная почта"),
                        DefaultInput(
                          hint: "Введите адрес почты",
                          textController: emailController,
                          notifyParent: () {},
                          inputType: TextInputType.emailAddress,
                        ),
                        MainText("Пароль"),
                        PassInput("Придумайте пароль", passController),
                        MainText("Подтвердите пароль"),
                        PassInput("Подтвердите пароль", repassController),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _value = !_value;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        style: BorderStyle.solid,
                                        color: Theme.of(context).primaryColor),
                                    shape: BoxShape.circle,
                                    color: _value
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: _value
                                      ? Icon(
                                          Icons.check,
                                          size: 15.0,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.check_box_outline_blank,
                                          size: 15.0,
                                          color: Colors.transparent,
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: dWith * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Я принимаю условия ",
                                    style: TextStyle(
                                      fontSize: dWith < 392 ? 10 : 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(RulePage.routeName);
                                    },
                                    child: Text(
                                      "пользовательского соглашения",
                                      style: TextStyle(
                                        fontSize: dWith < 392 ? 10 : 12,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
                            child: !_value
                                ? DefaultButton(
                                    "Продолжить",
                                    () {},
                                    Color(0xffB2B7D0),
                                  )
                                : DefaultButton("Продолжить", () {
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
    );
  }
}
