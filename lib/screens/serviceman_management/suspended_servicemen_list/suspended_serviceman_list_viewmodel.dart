import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';

import '../../../utils/constants.dart';
import '../../../utils/helper_functions/scroll_controller_funcs.dart';

class SuspendedServicemanListViewModel extends GetxController {

  /// Controller(s) & Form keys
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();

  /// List for servicemen suspended by the admin
  RxList<ServiceMan> suspendedServicemen = <ServiceMan>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'serviceManManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    detachSidePanelScrollController();
    super.onClose();
  }

}