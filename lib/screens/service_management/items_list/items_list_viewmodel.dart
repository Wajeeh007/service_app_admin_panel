import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app_admin_panel/models/service_item.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../models/drop_down_entry.dart';
import '../../../utils/constants.dart';

class ItemsListViewModel extends GetxController {

  /// Controller(s), LinkOverlay & Form Keys
  ScrollController scrollController = ScrollController();

  OverlayPortalController subServiceTypeController = OverlayPortalController();
  LayerLink subServiceTypeLink = LayerLink();

    /// For Service Type Dropdown
    TextEditingController serviceTypeController = TextEditingController();

    /// For Search field
    TextEditingController searchController = TextEditingController();
    GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();
  
    /// For Service Addition
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemPriceController = TextEditingController();
    GlobalKey<FormState> itemAdditionFormKey = GlobalKey<FormState>();

  /// Controller(s) & Form Keys End ///

  /// Items list data
  RxList<ServiceItem> itemsList = <ServiceItem>[].obs;

  /// Sub-Services list for dropdown ///
  RxList<DropDownEntry> subServicesList = <DropDownEntry>[].obs;

  /// Added Service image variable
  Rx<XFile> addedItemImage = XFile('').obs;

  /// Show Dropdown bool variables
  RxBool showSubServiceTypeDropDown = false.obs;

  /// Selected Item index variables
  RxInt? subServiceTypeSelectedIndex;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController,sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'serviceManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Toggle dropdown and it's value
  void toggleOverlay({
    required OverlayPortalController overlayPortalController,
    required RxBool showDropDown
  }) {
    overlayPortalController.toggle();
    if(overlayPortalController.isShowing) {
      showDropDown.value = true;
    } else {
      showDropDown.value = false;
    }
  }

}