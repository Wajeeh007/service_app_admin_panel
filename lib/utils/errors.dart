import 'package:service_app_admin_panel/models/api_response.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:get/get.dart';

class Errors {

  final bool isError = true;

  ApiResponse showSocketExceptionError() {
    return ApiResponse(
        message: lang_key.unableToReachClient.tr,
        success: false,
        statusCode: 400
    );
  }

  ApiResponse showTimeOutExceptionError() {
    return ApiResponse(
      message: lang_key.timeOutException.tr,
      success: false,
      statusCode: 408,
    );
  }

  ApiResponse showGeneralApiError() {
    return ApiResponse(
      message: lang_key.generalApiError.tr,
      statusCode: 500,
      success: false,
    );
  }

  ApiResponse showFormatExceptionError() {
    return ApiResponse(
      message: lang_key.formatExceptionError.tr,
      statusCode: 400,
      success: false,
    );
  }
}