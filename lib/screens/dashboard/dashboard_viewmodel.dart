import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';

import '../../helpers/scroll_controller_funcs.dart';
import '../../models/drop_down_entry.dart';
import 'models/zone_wise_order_volume.dart';

class DashboardViewModel extends GetxController {

  /// Variables for dropdown(s)
  ScrollController scrollController = ScrollController();
    /// Zone-wise stat dropdown variables
    TextEditingController zoneWiseStatController = TextEditingController();
    OverlayPortalController zoneWiseStatOverlayPortalController = OverlayPortalController();
    RxString zoneWiseStatSelectedId = ''.obs;

    /// Admin earning stats time period dropdown variables
    TextEditingController adminEarningTimePeriodController = TextEditingController();
    OverlayPortalController adminEarningTimePeriodOverlayPortalController = OverlayPortalController();
    RxString adminEarningTimePeriodSelectedId = ''.obs;

    /// Admin earning stats zone selection dropdown variables
    TextEditingController adminEarningZoneSelectionController = TextEditingController();
    OverlayPortalController adminEarningZoneSelectionOverlayPortalController = OverlayPortalController();
    RxString adminEarningZoneSelectionSelectedId = ''.obs;

  /// Zone-wise stats time period Dropdown options
  List<DropDownEntry> zoneWiseStatsDropDownList = [
    DropDownEntry(value: 'Today', label: 'Today'),
    DropDownEntry(value: 'Yesterday', label: 'Yesterday'),
    DropDownEntry(value: 'This Week', label: 'This Week'),
    DropDownEntry(value: 'This Month', label: 'This Month'),
  ];

  /// Admin earning stats time period Dropdown options
  List<DropDownEntry> adminEarningTimePeriodDropdownList = [
    DropDownEntry(value: 'Daily', label: 'Daily'),
    DropDownEntry(value: 'Monthly', label: 'Monthly'),
    DropDownEntry(value: 'Yearly', label: 'Yearly'),
  ];
  
  /// Admin earning stats zone selection options
  List<DropDownEntry> adminEarningZoneSelectionList = [
    DropDownEntry(value: '0', label: 'USA'),
    DropDownEntry(value: '1', label: 'Canada'),
    DropDownEntry(value: '2', label: 'Pakistan'),
  ];

  /// Suffix Icon for custom dropdown(s)
  RxBool zoneWiseStatsShowDropDown = false.obs;
  RxBool adminEarningTimePeriodShowDropDown = false.obs;
  RxBool adminEarningZoneSelectionShowDropDown = false.obs;

  /// Zones order volume result list
  RxList<ZoneWiseOrderVolume> zoneWiseOrderVolumeList = <ZoneWiseOrderVolume>[
    ZoneWiseOrderVolume(
      id: 0,
      zoneName: 'USA',
      percentage: 0.3,
    )
  ].obs;

  /// List to perform functions collectively on all dropdowns and suffix icons
  List<Map<OverlayPortalController, RxBool>> overlayPortalControllersAndDropDownValues = [];

  @override
  void onInit() {
    zoneWiseStatSelectedId.value = zoneWiseStatsDropDownList.first.value;
    adminEarningTimePeriodSelectedId.value = adminEarningTimePeriodDropdownList.first.value;
    adminEarningZoneSelectionSelectedId.value = adminEarningZoneSelectionList.first.value;
    zoneWiseStatController.text = zoneWiseStatsDropDownList.first.label!;
    adminEarningTimePeriodController.text = adminEarningTimePeriodDropdownList.first.label!;
    adminEarningZoneSelectionController.text = adminEarningZoneSelectionList.first.label!;
    super.onInit();
  }

  @override
  void onReady() {
    overlayPortalControllersAndDropDownValues = [
      {zoneWiseStatOverlayPortalController: zoneWiseStatsShowDropDown},
      {adminEarningTimePeriodOverlayPortalController: adminEarningTimePeriodShowDropDown},
      {adminEarningZoneSelectionOverlayPortalController: adminEarningZoneSelectionShowDropDown}
    ];

    for (var controllerAndDropDown in overlayPortalControllersAndDropDownValues) {
      ever(controllerAndDropDown.values.first, (value) {
        if(value) {
          hideOtherOverlayPortalControllers(controllerAndDropDown.keys.first);
        } else {
          controllerAndDropDown.keys.first.hide();
        }
      });
    }

    animateSidePanelScrollController(scrollController);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  toggleOverlayPortalController({
    required OverlayPortalController overlayPortalController,
    required RxBool showDropDown
  }) {
    hideOtherOverlayPortalControllers(overlayPortalController);
    overlayPortalController.toggle();
  }

  /// Hide other overlay portal controllers except the given one
  void hideOtherOverlayPortalControllers(OverlayPortalController overlayController) {
    GlobalVariables.openProfileDropdown.value = false;
    for (var controllerAndDropDownValues in overlayPortalControllersAndDropDownValues) {
      if(controllerAndDropDownValues.keys.first == overlayController) {
        controllerAndDropDownValues.keys.first.show();
        continue;
      }
      controllerAndDropDownValues.values.first.value = false;
    }
  }
}