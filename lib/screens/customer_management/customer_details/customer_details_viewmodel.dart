import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/customer.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../utils/routes.dart';

class CustomerDetailsViewModel extends GetxController {

  /// Controller(s) & Form keys ///
  ScrollController scrollController = ScrollController();

  /// Controller(s) & Form Keys End ///

  /// String for customer ID ///
  String customerId = '';

  /// Customer Object
  Rx<Customer> customerDetails = Customer().obs;

  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;
    // if(args == null || args.isEmpty) {
    //   Get.offAllNamed(Routes.customersList);
    // } else {
    //   GlobalVariables.showLoader.value = true;
      // customerId = args['customerId'];
      // _fetchCustomer();
      animateSidePanelScrollController(scrollController, routeName: Routes.customersList);
    // }
    super.onReady();
  }

  void _fetchCustomer() async {
    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: Urls.getCustomer(customerId)).then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        customerDetails.value = Customer.fromJson(value.data);
      }
    });
  }
}