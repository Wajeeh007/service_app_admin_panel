import 'package:get/get.dart';

class GlobalVariables {

  /// Profile Dropdown visibility variable
  static RxBool openProfileDropdown = false.obs;

  /// Loader visibility variable
  static RxBool showLoader = false.obs;

  static String token = '';

  static RxDouble listHeight = 0.0.obs;
}