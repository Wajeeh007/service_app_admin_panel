import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/order.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/custom_google_map/models_and_libraries/map_controller.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/stop_loader_and_show_snackbar.dart';

class OrderDetailsViewModel extends GetxController {

  /// Controller(s)
  ScrollController scrollController = ScrollController();
  ScrollController activityLogsScrollController = ScrollController();
  CustomGoogleMapController mapController = CustomGoogleMapController();

  Rx<Order> orderDetails = Order().obs;

  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;

    if(args != null && args.containsKey('orderDetails')) {
      orderDetails.value = args['orderDetails'];
      _fetchOrderDetails();
    } else {
      Get.offNamed(Routes.ordersListing);
    }
    super.onReady();
  }

  void _fetchOrderDetails() {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(
        url: Urls.getOrder(orderDetails.value.id!)
    ).then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        orderDetails.value = Order.fromJson(value.data);
        orderDetails.refresh();
        Future.delayed(Duration(milliseconds: 500), () => mapController.moveCamera!(orderDetails.value.addressDetails!.latitude!, orderDetails.value.addressDetails!.longitude!));
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }

      if(value.statusCode == 404) {
        Get.close(1);
      }
    });
  }
}