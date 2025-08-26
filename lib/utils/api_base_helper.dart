import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:service_app_admin_panel/helpers/local_storage_functions.dart';
import 'package:service_app_admin_panel/models/api_response.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/errors.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import 'global_variables.dart';

class ApiBaseHelper {

  /// Function for HTTP GET method
  static Future<ApiResponse> getMethod({
    required String url,
    bool withBearer = true,
    bool withAuthorization = true,
    Object? body,
  }) async {
    try {

      print(GlobalVariables.token);
      Map<String, String> header = {
        'Content-Type': 'application/json',
        // 'Cookie': 'XSRF-token=${GlobalVariables.token}'
      };
      if (withAuthorization) {
        header.addAll({'Authorization': withBearer
            ? 'Bearer ${GlobalVariables.token}'
            : GlobalVariables.token.toString()});
      }
      Uri urlValue = Uri.parse(Urls.baseURL + url);
      if (kDebugMode) {
        print('*********************** Request ********************************');
        print(urlValue);
        print(header);
      }

      http.Response response = await http.get(
          urlValue,
          headers: header,

      ).timeout(Duration(seconds: 50));

      if(kDebugMode){
        print(
            '*********************** Response ********************************');
        print(urlValue);
        print(response.body);
      }

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(parsedJSON);

      if(apiResponse.statusCode == 401 && apiResponse.message == 'Expired Token') {
        LocalStorageFunctions.removeKey(key: tokenKey);
        LocalStorageFunctions.removeKey(key: adminDetailsKey);
        Get.offAllNamed(Routes.login);
        return Errors().showExpiredTokenError();
      } else {
        return apiResponse;
      }
    } on SocketException {
      return Errors().showSocketExceptionError();
    } on TimeoutException {
      return Errors().showTimeOutExceptionError();
    } on http.ClientException {
      return Errors().showClientExceptionError();
    } on FormatException {
      return Errors().showFormatExceptionError();
    } catch (e) {
      return Errors().showGeneralApiError();
    }
  }

  /// Function for HTTP POST method
  static Future<ApiResponse> postMethod({
    required String url,
    required Object body,
    bool withBearer = true,
    bool withAuthorization = true,
  }) async {
    try {
      Map<String, String> header = {'Content-Type': 'application/json'};
      if (withAuthorization) {
        header.addAll({'Authorization': withBearer
            ? 'Bearer ${GlobalVariables.token}'
            : GlobalVariables.token.toString()});
      }
      body = jsonEncode(body);

      Uri urlValue = Uri.parse(Urls.baseURL + url);
      if(kDebugMode) {
        print(
            '*********************** Request ********************************');
        print(urlValue);
        print(body);
      }

      http.Response response = await http
          .post(urlValue, headers: header, body: body)
          .timeout(Duration(seconds: 30));

      if(kDebugMode){
        print(
            '*********************** Response ********************************');
        print(urlValue);
        print(response.body);
      }

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(parsedJSON);

      if(apiResponse.statusCode == 401 && apiResponse.message == 'Expired Token') {
        Get.offAllNamed(Routes.login);
        return Errors().showExpiredTokenError();
      } else {
        return apiResponse;
      }
    } on SocketException catch (_) {
      return Errors().showSocketExceptionError();
    } on FormatException catch (_) {
      return Errors().showFormatExceptionError();
    } catch (e) {
      return Errors().showGeneralApiError();
    }
  }

  /// Function for HTTP PUT method
  static Future<ApiResponse> putMethod({
    required String url,
    Object? body,
    bool withBearer = true,
    bool withAuthorization = true,
  }) async {
    try {
      Map<String, String> header = {'Content-Type': 'application/json'};
      if (withAuthorization) {
        header.addAll({'Authorization': withBearer
            ? 'Bearer ${GlobalVariables.token}'
            : GlobalVariables.token.toString()});
      }
      if (body != null) {
        body = jsonEncode(body);
      }
      Uri urlValue = Uri.parse(Urls.baseURL + url);
      if(kDebugMode) {
        print(
            '*********************** Request ********************************');
        print(urlValue);
        print(body);
      }

      http.Response response = await http
          .put(urlValue, headers: header, body: body)
          .timeout(Duration(seconds: 30));

      if(kDebugMode) {
        print(
            '*********************** Response ********************************');
        print(urlValue);
        print(response.body);
      }

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(parsedJSON);

      if(apiResponse.statusCode == 401 && apiResponse.message == 'Expired Token') {
        Get.offAllNamed(Routes.login);
        return Errors().showExpiredTokenError();
      } else {
        return apiResponse;
      }
    } on SocketException catch (_) {
      return Errors().showSocketExceptionError();
    } on TimeoutException catch (_) {
      return Errors().showTimeOutExceptionError();
    } on FormatException catch (_) {
      return Errors().showFormatExceptionError();
    } catch (e) {
      return Errors().showGeneralApiError();
    }
  }

  /// Function for HTTP PATCH method
  static Future<ApiResponse> patchMethod({
    required String url,
    Object? body,
    bool withBearer = true,
    bool withAuthorization = true,
  }) async {
    try {
      Map<String, String> header = {'Content-Type': 'application/json'};
      if (withAuthorization) {
        header.addAll({'Authorization': withBearer
            ? 'Bearer ${GlobalVariables.token}'
            : GlobalVariables.token.toString()});
      }
      if (body != null) {
        body = jsonEncode(body);
      }
      Uri urlValue = Uri.parse(Urls.baseURL + url);
      if(kDebugMode){
        print(
            '*********************** Request ********************************');
        print(urlValue);
        print(body);
      }

      http.Response response = await http
          .patch(urlValue, headers: header, body: body)
          .timeout(Duration(seconds: 30));

      if(kDebugMode){
        print(
            '*********************** Response ********************************');
        print(urlValue);
        print(response.body);
      }

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(parsedJSON);

      if(apiResponse.statusCode == 401 && apiResponse.message == 'Expired Token') {
        Get.offAllNamed(Routes.login);
        return Errors().showExpiredTokenError();
      } else {
        return apiResponse;
      }
    } on SocketException catch (_) {
      return Errors().showSocketExceptionError();
    } on TimeoutException catch (_) {
      return Errors().showTimeOutExceptionError();
    } on FormatException catch (_) {
      return Errors().showFormatExceptionError();
    } catch (e) {
      return Errors().showGeneralApiError();
    }
  }

  /// Function for HTTP DELETE method
  static Future<ApiResponse> deleteMethod({
    required String url,
    bool withBearer = true,
    bool withAuthorization = true,
  }) async {
    try {
      Map<String, String> header = {'Content-Type': 'application/json'};
      if (withAuthorization) {
        header.addAll({'Authorization': withBearer
            ? 'Bearer ${GlobalVariables.token}'
            : GlobalVariables.token.toString()});
      }
      Uri urlValue = Uri.parse(Urls.baseURL + url);
      if(kDebugMode){
        print(
            '*********************** Request ********************************');
        print(urlValue);
      }

      http.Response response = await http
          .delete(urlValue, headers: header)
          .timeout(Duration(seconds: 50));

      if(kDebugMode){
        print(
            '*********************** Response ********************************');
        print(urlValue);
        print(response.body);
      }

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      final apiResponse = ApiResponse.fromJson(parsedJSON);

      if(apiResponse.statusCode == 401 && apiResponse.message == 'Expired Token') {
        Get.offAllNamed(Routes.login);
        return Errors().showExpiredTokenError();
      } else {
        return apiResponse;
      }
    } on SocketException {
      return Errors().showSocketExceptionError();
    } on TimeoutException {
      return Errors().showGeneralApiError();
    }
  }

  /// Function for HTTP POST method which includes images
  static Future<ApiResponse> postMethodForImage({
    required String url,
    required List<http.MultipartFile> files,
    required Map<String, String> fields,
    bool withBearer = true,
    bool withAuthorization = true,
  }) async {
    try {
      Map<String, String> header = {'Content-Type': 'multipart/form-data'};
      if (withAuthorization) {
        header.addAll({'Authorization': withBearer
            ? 'Bearer ${GlobalVariables.token}'
            : GlobalVariables.token.toString()});
      }
      Uri urlValue = Uri.parse(Urls.baseURL + url);
      if(kDebugMode){
        print(
            '*********************** Request ********************************');
        print(urlValue);
      }

      http.MultipartRequest request = http.MultipartRequest('POST', urlValue);
      request.headers.addAll(header);
      request.fields.addAll(fields);
      request.files.addAll(files);
      http.StreamedResponse response = await request.send();
      Map<String, dynamic> parsedJSON = await jsonDecode(await response.stream.bytesToString());

      if(kDebugMode){
        print(
            '*********************** Response ********************************');
        print(urlValue);
        print(parsedJSON.toString());
      }
      final apiResponse = ApiResponse.fromJson(parsedJSON);

      if(apiResponse.statusCode == 401 && apiResponse.message == 'Expired Token') {
        Get.offAllNamed(Routes.login);
        return Errors().showExpiredTokenError();
      } else {
        return apiResponse;
      }
    } on SocketException catch (_) {
      return Errors().showSocketExceptionError();
    } on TimeoutException catch (_) {
      return Errors().showTimeOutExceptionError();
    } on FormatException catch (_) {
      return Errors().showFormatExceptionError();
    } catch (e) {
      return Errors().showGeneralApiError();
    }
  }

  /// Function for HTTP PATCH method which includes images
  static Future<ApiResponse> patchMethodForImage({
    required String url,
    required List<http.MultipartFile> files,
    required Map<String, String> fields,
    bool withBearer = true,
    bool withAuthorization = true,
  }) async {
    try {
      Map<String, String> header = {'Content-Type': 'multipart/form-data'};

      if (withAuthorization) {
        header.addAll({'Authorization': withBearer
            ? 'Bearer ${GlobalVariables.token}'
            : GlobalVariables.token.toString()});
      }
      Uri urlValue = Uri.parse(Urls.baseURL + url);
      if(kDebugMode){
        print(
            '*********************** Request ********************************');
        print(urlValue);
      }

      http.MultipartRequest request = http.MultipartRequest('PATCH', urlValue);

      request.headers.addAll(header);
      request.fields.addAll(fields);
      request.files.addAll(files);
      http.StreamedResponse response = await request.send();
      Map<String, dynamic> parsedJSON =
      await jsonDecode(await response.stream.bytesToString());

      if(kDebugMode){
        print(
            '*********************** Response ********************************');
        print(urlValue);
        print(parsedJSON.toString());
      }
      final apiResponse = ApiResponse.fromJson(parsedJSON);

      if(apiResponse.statusCode == 401 && apiResponse.message == 'Expired Token') {
        Get.offAllNamed(Routes.login);
        return Errors().showExpiredTokenError();
      } else {
        return apiResponse;
      }
    } on SocketException catch (_) {
      return Errors().showSocketExceptionError();
    } on TimeoutException catch (_) {
      return Errors().showTimeOutExceptionError();
    } on FormatException catch (_) {
      return Errors().showFormatExceptionError();
    } catch (e) {
      return Errors().showGeneralApiError();
    }
  }
}
