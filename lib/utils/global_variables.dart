import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GlobalVariables {

  /// Profile Dropdown visibility variable
  static RxBool openProfileDropdown = false.obs;

  /// Loader visibility variable
  static RxBool showLoader = false.obs;

  static String token = '';

  /// Scroll Controller for Side panel
  //TODO: Remove this controller and assign a new controller to the [ScreensBaseWidget] on every call.
  static ScrollController scrollController = ScrollController(
    keepScrollOffset: true,
  );
}