import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';

/// Виджет, отображающий наличие сети или её отстутствие
class NetworkStatus extends StatefulWidget {
  /// Отображать в случае наличия сети
  final Widget onlineWidget;

  /// Отображать в случае отсутствия сети
  final Widget offlineWidget;

  /// Адрес для проверки наличия соединения
  final String pingUrl;

  const NetworkStatus({
    Key key,
    @required this.onlineWidget,
    @required this.offlineWidget,
    this.pingUrl = 'https://google.com',
  }) : super(key: key);

  @override
  _NetworkStatusState createState() => _NetworkStatusState();
}

class _NetworkStatusState extends State<NetworkStatus> {
  @override
  void initState() {
    super.initState();
    ConnectivityUtils.instance.setServerToPing(widget.pingUrl);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityUtils.instance.isPhoneConnectedStream,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return widget.onlineWidget ?? Icon(Icons.network_wifi);
        } else {
          return widget.onlineWidget ?? Icon(Icons.airplanemode_active);
        }
      },
    );
  }
}
