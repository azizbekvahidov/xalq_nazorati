import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import '../widget/default_button.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

typedef void MyFormCallback(String result, String result2);

class SelectLang extends StatefulWidget {
  final MyFormCallback callBack;
  final String lang;
  SelectLang({this.lang, this.callBack});
  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  String _lang;

  @override
  void initState() {
    super.initState();
    _lang = widget.lang;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double dHeight = mediaQuery.size.height;
    double dWidth = mediaQuery.size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      height: 290,
      padding: EdgeInsets.symmetric(vertical: dHeight * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "choose_lang".tr().toString(),
              style: Theme.of(context)
                  .textTheme
                  .display2
                  .copyWith(fontSize: dWidth * globals.fontSize20),
            ),
          ),
          RadioListTile<String>(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Русский',
              style: TextStyle(
                color: Color(0xff050505),
                fontFamily: "Gilroy",
                fontSize: dWidth * globals.fontSize18,
                fontWeight: FontWeight.w600,
              ),
            ),
            value: "ru",
            groupValue: _lang,
            onChanged: (value) {
              setState(() {
                _lang = value;
              });
            },
          ),
          RadioListTile<String>(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'O‘zbek',
              style: TextStyle(
                color: Color(0xff050505),
                fontFamily: "Gilroy",
                fontSize: dWidth * globals.fontSize18,
                fontWeight: FontWeight.w600,
              ),
            ),
            value: "uz",
            groupValue: _lang,
            onChanged: (value) {
              setState(() {
                _lang = value;
              });
            },
          ),
          RadioListTile<String>(
            activeColor: Theme.of(context).primaryColor,
            title: Text(
              'Ўзбек',
              style: TextStyle(
                color: Color(0xff050505),
                fontFamily: "Gilroy",
                fontSize: dWidth * globals.fontSize18,
                fontWeight: FontWeight.w600,
              ),
            ),
            value: "en",
            groupValue: _lang,
            onChanged: (value) {
              setState(() {
                _lang = value;
              });
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: DefaultButton("use".tr().toString(), () async {
              if (globals.token != null) {
                var url =
                    '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/switch-lang';
                Map map = {
                  "fcm_token": globals.deviceToken,
                  "lang": _lang.tr().toString()
                };
                Map<String, String> headers = {
                  "Authorization": "token ${globals.token}"
                };
                var response = await Requests.post(
                  url,
                  headers: headers,
                  body: map,
                );
                // request.methodPost(map, url);
                if (response.statusCode == 200) {
                  String country;
                  switch (_lang) {
                    case 'uz':
                      country = 'UZ';
                      break;
                    case 'ru':
                      country = 'RU';
                      break;
                    case 'en':
                      country = 'US';
                      break;
                  }
                  EasyLocalization.of(context).locale = Locale(_lang, country);
                  Navigator.pop(context);
                  widget.callBack(_lang, country);
                } else {
                  var responseBody = response.json();
                  print(responseBody);
                }
              } else {
                String country;
                switch (_lang) {
                  case 'uz':
                    country = 'UZ';
                    break;
                  case 'ru':
                    country = 'RU';
                    break;
                  case 'en':
                    country = 'US';
                    break;
                }
                EasyLocalization.of(context).locale = Locale(_lang, country);
                Navigator.pop(context);
                widget.callBack(_lang, country);
              }
            }, Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
