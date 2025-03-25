import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../model/NetworkResponse.dart';

class NetWorkClint {
  static final Logger _logger = Logger();

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {

      Uri uri = Uri.parse(url);
      _preRequestLogger(url);

      final Response response = await get(uri);
      final decodedJson = jsonDecode(response.body);

      _postRequestLog(url, response.statusCode, jsonBody: response.body,headers: response.headers,);

      if (response.statusCode == 200) {
        return NetworkResponse(
            isSuccess: true, statusCode: response.statusCode, data: decodedJson);
      } else {
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: '-1');
      }
    } catch (e) {
    _postRequestLog(url, -1);
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? bodys}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var body = jsonEncode(bodys);
      Uri uri = Uri.parse(url);
      _preRequestLogger(url);

      final Response response = await post(Uri.parse(uri as String), headers: headers, body: body,);
      _postRequestLog(url, response..statusCode,headers: response.headers,jsonBody: response.body,);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static _preRequestLogger(String url, {Map<String, double>? body}) {
    _logger.i('URL => $url\n' 'Body: $body');
  }

  static _postRequestLog(String url, statusCode, {Map<String, dynamic>? headers, dynamic jsonBody, dynamic errorMessage,}) {

    if(errorMessage != null){
      _logger.e(
          'URL=> $url,\n StatusCode: $statusCode,\n Headers: $headers,\n JsonBody: $jsonBody,\n ErrorMessage: $errorMessage,'
      );
    } else{
    _logger.i(
        'URL=> $url,\n StatusCode: $statusCode,\n Headers: $headers,\n JsonBody: $jsonBody,\n ErrorMessage: $errorMessage,'
    );
    }
  }
}
