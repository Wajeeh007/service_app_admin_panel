import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/serviceman.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions/scroll_controller_funcs.dart';

class ActiveServiceManListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();

    /// All ServiceMen List
    TextEditingController allServiceMansSearchController = TextEditingController();
    GlobalKey<FormState> allServiceMansFormKey = GlobalKey<FormState>();

    /// Active ServiceMen List
    TextEditingController activeServiceMansSearchController = TextEditingController();
    GlobalKey<FormState> activeServiceMansFormKey = GlobalKey<FormState>();

    /// InActive ServiceMen List
    TextEditingController inActiveServiceMansSearchController = TextEditingController();
    GlobalKey<FormState> inActiveServiceMansFormKey = GlobalKey<FormState>();

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
    animateSidePanelScrollController(scrollController, sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'serviceManManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}