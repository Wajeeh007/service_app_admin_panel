import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app_admin_panel/models/sub_service_category.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../models/drop_down_entry.dart';

class SubServicesListViewModel extends GetxController {

  /// Controller(s), LinkOverlay & Form Keys
  ScrollController scrollController = ScrollController();
  OverlayPortalController serviceTypeController = OverlayPortalController();
  LayerLink serviceTypeLink = LayerLink();

    /// For Service Type dropdown
    TextEditingController serviceTypeTextController = TextEditingController();

    /// For Search field
    TextEditingController searchController = TextEditingController();
    GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();

    /// For Service Addition
    TextEditingController serviceAdditionController = TextEditingController();
    GlobalKey<FormState> serviceAdditionFormKey = GlobalKey<FormState>();

  /// Controller(s) & Form Keys End ///

  /// Sub-Services list data
  RxList<ServiceSubCategory> subCategoriesList = <ServiceSubCategory>[].obs;

  /// Service types list ///
  RxList<DropDownEntry> servicesList = <DropDownEntry>[].obs;

  /// Added Service image variable
  Rx<XFile> addedServiceImage = XFile('').obs;

  /// Show Dropdown bool variables
  RxBool showServiceTypeDropDown = false.obs;

  /// Selected Item index variables
  RxInt? serviceTypeSelectedIndex;

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

  /// Toggle dropdown and it's value
  void toggleOverlay({required OverlayPortalController overlayPortalController, required RxBool showDropDown}) {
    overlayPortalController.toggle();
    if(overlayPortalController.isShowing) {
      showDropDown.value = true;
    } else {
      showDropDown.value = false;
    }
  }
}