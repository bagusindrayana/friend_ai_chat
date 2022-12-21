import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

class ApiProvider {
  static final BaseOptions _options = BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: 30 * 1000, // 30 seconds
    receiveTimeout: 30 * 1000, // 30 seconds
    sendTimeout: 30 * 1000, // 30 seconds
  );
  static final Dio _dio = Dio(_options);

  //link api local
  static const String base_url = 'http://192.168.8.217:3000?url=';

  static Future<Response> get({String? url, dynamic? header}) async {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.options.headers = header ?? {};
    String _url = '${base_url}${url}';
    return await _dio.get(_url);
  }

  static Future<Response> post(
      {String? url, dynamic? data, dynamic? header}) async {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    print(header);
    String _url = '${base_url}${url}';
    _dio.options.headers = header ?? {};
    print(data);
    return await _dio.post(_url, data: data);
  }

  static Future<Response<ResponseBody>> stream(
      {String? url, dynamic? data, dynamic? header}) async {
    BaseOptions _c_options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 30 * 1000, // 30 seconds
      receiveTimeout: 30 * 1000, // 30 seconds
      sendTimeout: 30 * 1000, // 30 seconds
    );

    _c_options.headers = header ?? {};
    _c_options.responseType = ResponseType.stream;
    Dio dio = Dio(_c_options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String _url = '${base_url}${url}';

    Response<ResponseBody> rs;
    rs = await dio.post<ResponseBody>(_url, data: data);
    return rs;
  }
}
