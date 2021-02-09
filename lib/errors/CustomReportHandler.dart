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
    print(error.error);
    if (error.error is NoSuchMethodError) {
      //   /// Обрабатывать ошибку с типом Type
      //   /// Но тогда потребуется четко управлять ветвлением в случае ошибок,
      //   /// и определять какие типы ошибок отслеживать, а какие нет, допустим,
      //   /// наследуясь от [Exception] и покрывать всё throw с этим ошибками
      //   /// например abstract class TrackedException implements Exception и остальные
      //   /// ошибки наследовать от TrackedException и указать в условии выше is TrackedException
    } else {
      //   // Игнорировать ошибку с этим типом
      //   // Пропуск к следующему обработчику, если указан
      return Future.value(true);
    }
    throw UnimplementedError();
  }
}
