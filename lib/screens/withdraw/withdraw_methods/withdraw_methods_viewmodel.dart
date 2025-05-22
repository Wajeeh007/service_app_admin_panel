import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/drop_down_entry.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../utils/helper_functions/scroll_controller_funcs.dart';

class WithdrawMethodsViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s), Layer Link & Form Keys

  late TabController tabController;
  ScrollController scrollController = ScrollController();

  OverlayPortalController fieldTypeOverlayPortalController = OverlayPortalController();
  LayerLink fieldTypeLink = LayerLink();

    /// For field type dropdown
    TextEditingController fieldTypeTextController = TextEditingController();

    /// New Method Information
    TextEditingController newMethodNameController = TextEditingController();
    TextEditingController newMethodFieldNameController = TextEditingController();
    TextEditingController newMethodPlaceholderTextController = TextEditingController();
    GlobalKey<FormState> newMethodInfoFormKey = GlobalKey<FormState>();

    /// For Methods list searching
    TextEditingController allMethodsSearchController = TextEditingController();
    TextEditingController activeMethodsSearchController = TextEditingController();
    TextEditingController inActiveMethodsSearchController = TextEditingController();

    GlobalKey<FormState> allMethodsFormKey = GlobalKey<FormState>();
    GlobalKey<FormState> activeMethodsFormKey = GlobalKey<FormState>();
    GlobalKey<FormState> inActiveMethodsFormKey = GlobalKey<FormState>();

  /// New Method field type dropdown entries
  List<DropDownEntry> newMethodFieldTypeDropdownEntries = [
    DropDownEntry(value: NewMethodFieldType.text, label: lang_key.text.tr),
    DropDownEntry(value: NewMethodFieldType.number, label: lang_key.number.tr),
    DropDownEntry(value: NewMethodFieldType.email, label: lang_key.email.tr),
  ];

  /// Checkbox value variable
  RxBool makeMethodFieldDefaultValue = false.obs;

  /// Show Dropdown value
  RxBool showDropDown = false.obs;

  /// Dropdown Selected Value
  dynamic dropDownSelectedValue;

  /// Tabs Names list
  List<String> tabsNames = [
    lang_key.all.tr,
    lang_key.active.tr,
    lang_key.inactive.tr,
  ];

  @override
  void onInit() {
    ever(showDropDown, (value) {
      if(value) {
        fieldTypeOverlayPortalController.show();
      } else {
        fieldTypeOverlayPortalController.hide();
      }
    });
    tabController = TabController(length: tabsNames.length, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController,sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'withdraws').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

}