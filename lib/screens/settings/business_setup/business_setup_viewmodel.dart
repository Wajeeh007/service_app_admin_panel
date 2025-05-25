import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../utils/constants.dart';

class BusinessSetupViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();

  /// Tabs Names list
  List<String> tabsNames = [
    lang_key.settings.tr,
  ];

  @override
  void onInit() {
    tabController = TabController(length: tabsNames.length, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController,sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'settings').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}