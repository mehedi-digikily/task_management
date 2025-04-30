
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_managemnt/app.dart';
import 'package:task_managemnt/ui/controlar/auth_controlar.dart';
import 'package:task_managemnt/ui/screens/onBoardingScreen/login_screen.dart';

import '../model/network_response.dart';


class NetworkClient {
  static final Logger _logger = Logger();

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String,String> header = {
        'Content-Type': 'application/json',
        'token': AuthController.token ?? ''
      };
      _preRequestLog(url,header);
      Response response = await get(uri,headers: header);
      _postRequestLog(url, response.statusCode,
          headers: response.headers, responseBody: response.body);
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            data: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        String errorMessage = decodedJson['message'] ?? decodedJson['error'] ?? decodedJson['data'] ?? 'Something went wrong';
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessage);
      }
    } catch (e) {
      _postRequestLog(url, -1);
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest({required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String,String> header = {
        'Content-Type': 'application/json',
        'token': AuthController.token ?? ''
      };

      _preRequestLog(url, body: body,header);

      Response response = await post(
        uri,
        headers: header,
        body: body != null ? jsonEncode(body) : null,
      );
      _postRequestLog(url, response.statusCode, headers: response.headers, responseBody: response.body);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            data: decodedJson);
      }else if(response.statusCode == 401){
        _moveToLoginScreen();
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode,errorMessage: 'Unauthorized');
      } else {
        final decodedJson = jsonDecode(response.body);
        String errorMessage = decodedJson['message'] ?? decodedJson['error'] ?? decodedJson['data'] ?? 'Something went wrong';
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessage);
      }
    } catch (e) {
      _postRequestLog(url, -1, errorMessage: e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void _preRequestLog(String url,Map<String, dynamic> headers,{Map<String, dynamic>? body}) {
    _logger.i(
        'URL => $url\n'
        'Headers => $headers\n'
        'Body: $body');
  }

  static void _postRequestLog(String url, int statusCode,
      {Map<String, dynamic>? headers,
        dynamic responseBody,
        dynamic errorMessage}) {
    if (errorMessage != null) {
      _logger.e(''
          'Url: $url\n'
          'Status code: $statusCode\n'
          'headers: $headers\n'
          'Error Message: $errorMessage');
    } else {
      _logger.i(''
          'Url: $url\n'
          'Status code: $statusCode\n'
          'Headers: $headers\n'
          'Response: $responseBody');
    }
  }
  static Future<void> _moveToLoginScreen() async {
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (predicate) => false);
  }


}


