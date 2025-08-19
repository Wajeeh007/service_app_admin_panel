import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/order.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/custom_google_map/models_and_libraries/map_controller.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

class OrderDetailsViewModel extends GetxController {

  /// Controller(s)
  ScrollController scrollController = ScrollController();
  ScrollController activityLogsScrollController = ScrollController();
  CustomGoogleMapController mapController = CustomGoogleMapController();

  Rx<Order> orderDetails = Order().obs;

  @override
  void onReady() {
    _fetchOrderDetails();
    super.onReady();
  }

  void _fetchOrderDetails() {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: Urls.getOrder(orderDetails.value.id ?? '1')).then((value) {
      GlobalVariables.showLoader.value = false;
    });
  }

}