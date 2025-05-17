import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GlobalVariables {

  /// Profile Dropdown visibility variable
  static RxBool openProfileDropdown = false.obs;

  static ScrollController scrollController = ScrollController(
    keepScrollOffset: true,
  );
}