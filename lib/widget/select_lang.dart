import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      height: 325,
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "choose_lang".tr().toString(),
              style: Theme.of(context).textTheme.display2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          RadioListTile<String>(
            activeColor: Theme.of(context).primaryColor,
            title: const Text(
              'Русский',
              style: TextStyle(
                color: Color(0xff050505),
                fontFamily: "Gilroy",
                fontSize: 18,
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
            title: const Text(
              'O‘zbekcha',
              style: TextStyle(
                color: Color(0xff050505),
                fontFamily: "Gilroy",
                fontSize: 18,
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
            title: const Text(
              'Ўзбекча',
              style: TextStyle(
                color: Color(0xff050505),
                fontFamily: "Gilroy",
                fontSize: 18,
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
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: DefaultButton("use".tr().toString(), () {
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
            }, Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
