import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../helpers/show_snackbar.dart';
import '../../../utils/api_base_helper.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/url_paths.dart';

class SuspendedServicemanListViewModel extends GetxController {

  /// Controller(s) & Form keys
  ScrollController scrollController = ScrollController();

  /// List for servicemen suspended by the admin
  RxList<Serviceman> suspendedServicemen = <Serviceman>[].obs;

  /// Pagination variables
  int limit = 10;
  RxInt page = 0.obs;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchSuspendedServicemen();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// API call to fetch new servicemen requests
  void fetchSuspendedServicemen() {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: "${Urls.getSuspendedServicemen}?limit=$limit&page=${page.value}").then((value) {

      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        suspendedServicemen.clear();
        final data = value.data as List;
        suspendedServicemen.addAll(data.map((e) => Serviceman.fromJson(e)));
        suspendedServicemen.refresh();
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }
    });
  }
}