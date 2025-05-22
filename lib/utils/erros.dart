import 'package:service_app_admin_panel/models/api_response.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/helper_functions/stop_loader_and_show_snackbar.dart';

class Errors {

  final bool isError = true;

  ApiResponse showSocketExceptionError() {
    stopLoaderAndShowSnackBar(lang_key.noInternetError.tr, isError);
    return ApiResponse(
        message: lang_key.noInternetError.tr,
        success: false,
        statusCode: 400
    );
  }

  ApiResponse showTimeOutExceptionError() {
    stopLoaderAndShowSnackBar(lang_key.timeOutException.tr, isError);
    return ApiResponse(
      message: lang_key.timeOutException.tr,
      success: false,
      statusCode: 408,
    );
  }

  ApiResponse showGeneralApiError() {
    stopLoaderAndShowSnackBar(lang_key.generalApiError.tr, isError);
    return ApiResponse(
      message: lang_key.generalApiError.tr,
      statusCode: 500,
      success: false,
    );
  }

  ApiResponse showFormatExceptionError() {
    stopLoaderAndShowSnackBar(lang_key.formatExceptionError.tr, isError);
    return ApiResponse(
      message: lang_key.formatExceptionError.tr,
      statusCode: 400,
      success: false,
    );
  }
}