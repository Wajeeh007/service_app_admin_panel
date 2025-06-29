import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_snackbar.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/scroll_controller_funcs.dart';

class NewRequestsViewModel extends GetxController {

  ScrollController scrollController = ScrollController();

  /// New Servicemen requests received to admin
  RxList<Serviceman> serviceManNewRequests = <Serviceman>[].obs;

  /// Pagination variables
  RxInt page = 0.obs;
  int limit = 10;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchNewRequests();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// API call to fetch new servicemen requests
  void fetchNewRequests() {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: "${Urls.getNewRequests}?limit=$limit&page=${page.value}").then((value) {

      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        serviceManNewRequests.clear();
        final data = value.data as List;
        serviceManNewRequests.addAll(data.map((e) => Serviceman.fromJson(e)));
        serviceManNewRequests.refresh();
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }
    });
  }

}