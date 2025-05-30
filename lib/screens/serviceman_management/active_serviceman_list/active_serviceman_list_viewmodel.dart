import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../models/serviceman.dart';

class ActiveServiceManListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();

    /// All ServiceMen List
    TextEditingController allServiceMansSearchController = TextEditingController();

    /// Active ServiceMen List
    TextEditingController activeServiceMansSearchController = TextEditingController();

    /// InActive ServiceMen List
    TextEditingController inActiveServiceMansSearchController = TextEditingController();

  /// All ServiceMen data list
  RxList<ServiceMan> allServiceMen = <ServiceMan>[].obs;

  /// Active servicemen list
  RxList<ServiceMan> activeServicemen = <ServiceMan>[].obs;

  /// In-Active Servicemen list
  RxList<ServiceMan> inActiveServicemen = <ServiceMan>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

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