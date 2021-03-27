import 'package:flutter/material.dart';
import 'package:system_settings/system_settings.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class PermissionModal extends StatelessWidget {
  const PermissionModal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "permission_text".tr().toString(),
                style: TextStyle(
                  fontFamily: globals.font,
                  fontSize: dWidth * globals.fontSize16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: FlatButton(
                child: Container(
                    width: dWidth,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "go_settings".tr().toString(),
                        style: TextStyle(
                            fontSize: dWidth * globals.fontSize16,
                            color: Colors.white),
                      ),
                    )),
                onPressed: () {
                  SystemSettings.app();
                  // Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
