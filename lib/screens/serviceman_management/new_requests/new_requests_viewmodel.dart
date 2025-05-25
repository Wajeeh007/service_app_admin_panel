import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../utils/constants.dart';

class NewRequestsViewModel extends GetxController {

  ScrollController scrollController = ScrollController();

  /// New Servicemen requests received to admin
  RxList<ServiceMan> serviceManNewRequests = <ServiceMan>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController,
        sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'serviceManManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

}