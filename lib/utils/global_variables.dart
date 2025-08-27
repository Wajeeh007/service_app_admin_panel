import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/admin.dart';

class GlobalVariables {

  /// Profile Dropdown visibility variable
  static RxBool openProfileDropdown = false.obs;

  /// Loader visibility variable
  static RxBool showLoader = false.obs;

  /// JWT token
  static String token = '';

  /// Variable to control the lists height in UI
  static RxDouble listHeight = 0.0.obs;

  static Rx<Admin> userDetails = Admin().obs;
}