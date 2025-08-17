import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/order.dart';
import 'package:service_app_admin_panel/utils/custom_google_map/models_and_libraries/map_controller.dart';

class OrderDetailsViewModel extends GetxController {

  /// Controller(s)
  ScrollController scrollController = ScrollController();
  ScrollController activityLogsScrollController = ScrollController();
  CustomGoogleMapController mapController = CustomGoogleMapController();

  Rx<Order> orderDetails = Order().obs;

  @override
  void onReady() {

    addListener(() {

    });
    super.onReady();
  }


}