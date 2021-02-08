import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xalq_nazorati/errors/ReportPage.dart';

class CustomPageReportMode extends ReportMode {
  @override
  bool isContextRequired() {
    return true;
  }

  @override
  void requestAction(Report report, BuildContext context) {
    _navigateToPageWidget(report, context);
  }

  /// Переход на страницу с выбором варианта обработки ошибки
  void _navigateToPageWidget(Report report, BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ReportPage(reportMode: this, report: report),
      ),
    );
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.android, PlatformType.iOS];
}
