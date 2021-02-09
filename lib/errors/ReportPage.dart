import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/errors/CustomPageReportMode.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

/// Страница с выводом сообщения об ошибке
class ReportPage extends StatefulWidget {
  final CustomPageReportMode reportMode;
  final Report report;

  const ReportPage({
    Key key,
    @required this.reportMode,
    @required this.report,
  }) : super(key: key);
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  /// Подтверждение вызова последующих обработчиков отчета об ошибке
  void _onSendReport() {
    widget.reportMode.onActionConfirmed(widget.report);
  }

  /// Отклонение отчета об ошибке
  void _onRejectReport() {
    widget.reportMode.onActionRejected(widget.report);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заголовок страницы ошибки'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              ShadowBox(
                child: Text(widget.report.errorDetails.toString()),
              ),
              ShadowBox(
                child: Text(widget.report.error.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
