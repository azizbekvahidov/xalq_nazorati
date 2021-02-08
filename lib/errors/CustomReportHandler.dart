import 'package:catcher/model/report.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report_handler.dart';

class CustomReportHandler extends ReportHandler {
  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.web, PlatformType.android, PlatformType.iOS];

  @override
  Future<bool> handle(Report error) {
    // Здесь реализуется отправка отчета об ошибке на сервер
    // У модели предусмотрен метод toJson() для сериализации
    throw UnimplementedError();
  }
}
