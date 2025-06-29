import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';

import '../../../helpers/scroll_controller_funcs.dart';

class SuspendedServicemanListViewModel extends GetxController {

  /// Controller(s) & Form keys
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();

  /// List for servicemen suspended by the admin
  RxList<Serviceman> suspendedServicemen = <Serviceman>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

}