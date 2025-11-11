import 'dart:developer';

import 'package:dio/dio.dart';

class Response {
  final int statusCode;
  final dynamic data;

  Response({required this.statusCode, required this.data});
}

class ApiConstant {
  static const String apiURL = 'https://staging.chamberofsecrets.8club.co/v1/experiences?active=true';

  static String prettyJson(dynamic data) {
    return "";
  }

  static final dio = Dio();

  static Future<Response> get({
    required String url,
    var data,
    bool sendToken = false,
    bool sendAsData = false,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getStringList('tokens') != null
    //     ? prefs.getStringList('tokens')![0]
    //     : "";
    try {
      var response = await dio.get(
        url,
        queryParameters: sendAsData ? null : data,
        data: sendAsData ? data : null,
        options: Options(
          headers: sendToken
              ? {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer token',
                }
              : {'Content-Type': 'application/json'},
          validateStatus: (status) {
            return status! < 600;
          },
        ),
      );

      log(
        url,
        error: prettyJson(response.data),
        name: "GET/${response.statusCode}",
      );
      return Response(statusCode: response.statusCode!, data: response.data);
    } catch (e) {
      // print("API Error: $e");
      log(url, error: e, name: "EXCEPTION");
      return Response(statusCode: 500, data: e);
    }
  }

  static Future<Response> post({
    required String url,
    var data,
    bool sendToken = false,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getStringList('tokens') != null
    //     ? prefs.getStringList('tokens')![0]
    //     : "";

    try {
      var response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: sendToken
              ? {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer token',
                }
              : {'Content-Type': 'application/json'},
          validateStatus: (status) {
            return status! < 600;
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      log(
        url,
        error: prettyJson(response.data),
        name: "POST/${response.statusCode}",
      );

      return Response(statusCode: response.statusCode!, data: response.data);
    } catch (e) {
      print("Exception occurred: $e");
      log(url, error: e, name: "EXCEPTION");
      return Response(statusCode: 500, data: e.toString());
    }
  }
}
