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

  static Future<NetworkResponse> postRequest({required String url, Map<String, dynamic>? body}) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      Uri uri = Uri.parse(url);

      print("🔹 Sending Request to: $url");
      print("📤 Request Body (Before Encoding): $body");

      final Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body ?? {}), // এখানে `null` হলে খালি object পাঠাবে
      );

      print(" Response Status Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: jsonDecode(response.body)['message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      print(" Error in Request: $e");
      return NetworkResponse(
        isSuccess: false, statusCode: -1, errorMessage: e.toString(),
      );
    }
  }






  static _preRequestLogger(String url, {Map<String, dynamic>? body}) {
    _logger.i('URL => $url\nBody: ${jsonEncode(body)}');
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
