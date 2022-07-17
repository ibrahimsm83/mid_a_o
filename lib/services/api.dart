import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mao/utils/index_utils.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<Dio> dio() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  return Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: {
        "Accept": "application/json",
        "Authorization": 'Bearer ${_prefs.getString(PreferencesKeys.token)}'
      },
    ),
  );
}

String getParams(Map body) {
  return body.keys.map((key) => '$key=${body[key]}').toList().join("&");
}

class Api {
  static Future<dynamic> get(String url,
      {Map? body, Function(dynamic)? onError}) async {
    try {
      var response = await (await dio()).get('$url?${getParams(body ?? {})}');

      return response.data;
    } catch (e) {
      throw handleError(e);
    }
  }

  static Future<dynamic> post(String url, {Object? body}) async {
    try {
      var response = await (await dio()).post(url, data: body);
      return response.data;
    } catch (error) {
      throw handleError(error);
    }
  }

  static Future<dynamic> postwithToken(String url, {Object? body}) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();

      var dio = Dio();
      var response = await dio.post(Constants.baseUrl + url,
          options: Options(headers: {
            "requiresToken": true,
            "Authorization": 'Bearer ${_prefs.getString(PreferencesKeys.token)}'
          }),
          data: body);
      return response.data;
    } catch (error) {
      throw handleError(error);
    }
  }
}

class ApiErrorRepsonse {
  late bool status;
  late String? code;
  late Object? data;
  late int? timestamp;
  late String message;

  ApiErrorRepsonse({
    this.data,
    this.code,
    this.timestamp,
    this.message = "",
    this.status = false,
  });

  ApiErrorRepsonse.fromJson(Map<String, dynamic> json) {
    data = json["data"];
    code = json["code"];
    status = json["status"];
    message = json["message"];
    timestamp = json["timestamp"];
  }
}

Future<ApiErrorRepsonse> handleError(error) async {
  //MyController myController = Get.put(MyController());
  if (error is DioError) {
    if (error.error is SocketException) {
      throw ApiErrorRepsonse(
        code: ResponseCodes.networkConnection,
        message: "Internet not found try to change your network or try again",
      );
    } else if (error.error is TimeoutException) {
      throw ApiErrorRepsonse(
        code: ResponseCodes.timeout,
        message:
            "Taking too much time try to change your network or try again!",
      );
    } else if (error.response!.statusCode! == 401) {
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // await preferences.clear();
      // myController.calfList.value = [];
      // GetStorage().remove('currenuserdata');
      // Navigator.of(MyApp.globalkey.currentState!.context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const LoginScreen()),
      //     (Route<dynamic> route) => false);
      throw ApiErrorRepsonse.fromJson(error.response?.data ?? {});
    } else if (error.response!.statusCode! >= 402 &&
        error.response!.statusCode! < 500) {
      throw ApiErrorRepsonse.fromJson(error.response?.data ?? {});
    } else if (error.response!.statusCode! >= 500 &&
        error.response!.statusCode! < 600) {
      throw ApiErrorRepsonse(
        code: ResponseCodes.unknown,
        message: "Undetected issue found, kindly try again!",
      );
    } else {
      throw ApiErrorRepsonse(
        code: ResponseCodes.unknown,
        message: "Undetected issue found, kindly try again!",
      );
    }
  } else {
    throw ApiErrorRepsonse(
      code: ResponseCodes.unknown,
      message: "Undetedcted issue found, kindly try again!",
    );
  }
}
