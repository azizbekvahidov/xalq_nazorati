import 'dart:io';
import 'dart:convert';
import 'package:xalq_nazorati/globals.dart' as globals;

class HttpGet {
  Future methodPost(Map map, String url) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    request.headers.set('Content-type', 'application/json');
    if (globals.token != null) {
      request.headers.set("Authorization", "token ${globals.token}");
    }
    request.add(utf8.encode(json.encode(map)));

    HttpClientResponse response = await request.close();

    return response;
  }

  Future methodGet(String url) async {
    HttpClient client = new HttpClient();

    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    if (globals.token != null) {
      request.headers.set("Authorization", "token ${globals.token}");
    }
    // request.add(utf8.encode(json.encode(map)));

    HttpClientResponse response = await request.close();

    return response;
  }
}
