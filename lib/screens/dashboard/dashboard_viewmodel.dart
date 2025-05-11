import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';

import '../../models/drop_down_entry.dart';
import 'models/zone_wise_order_volume.dart';

class DashboardViewModel extends GetxController {

  /// Variables for dropdown(s)
    /// Zone-wise stat dropdown variables
    TextEditingController zoneWiseStatController = TextEditingController();
    OverlayPortalController zoneWiseStatOverlayPortalController = OverlayPortalController();
    LayerLink zoneWiseStatLink = LayerLink();
    RxInt zoneWiseStatSelectedItemIndex = 0.obs;

    /// Admin earning stats time period dropdown variables
    TextEditingController adminEarningTimePeriodController = TextEditingController();
    OverlayPortalController adminEarningTimePeriodOverlayPortalController = OverlayPortalController();
    LayerLink adminEarningTimePeriodLink = LayerLink();
    RxInt adminEarningTimePeriodSelectedItemIndex = 0.obs;

    /// Admin earning stats zone selection dropdown variables
    TextEditingController adminEarningZoneSelectionController = TextEditingController();
    OverlayPortalController adminEarningZoneSelectionOverlayPortalController = OverlayPortalController();
    LayerLink adminEarningZoneSelectionLink = LayerLink();
    RxInt adminEarningZoneSelectionSelectedItemIndex = 0.obs;

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
    DropDownEntry(value: 0, label: 'USA'),
    DropDownEntry(value: 1, label: 'Canada'),
    DropDownEntry(value: 2, label: 'Pakistan'),
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
  List<Map<OverlayPortalController, RxBool>> overlayPortalControllersAndIcons = [];

  @override
  void onReady() {
    overlayPortalControllersAndIcons = [
      {zoneWiseStatOverlayPortalController: zoneWiseStatsShowDropDown},
      {adminEarningTimePeriodOverlayPortalController: adminEarningTimePeriodShowDropDown},
      {adminEarningZoneSelectionOverlayPortalController: adminEarningZoneSelectionShowDropDown}
    ];
    super.onReady();
  }

  void toggleOverlayPortalController({
    required OverlayPortalController overlayPortalController,
    required RxBool showDropDown
  }) {
    hideOtherOverlayPortalControllers(overlayPortalController);
    overlayPortalController.toggle();
    if(overlayPortalController.isShowing) {
      showDropDown.value = true;
    } else {
      showDropDown.value = false;
    }
  }

  /// Hide other overlay portal controllers except the given one
  void hideOtherOverlayPortalControllers(OverlayPortalController overlayController) {
    GlobalVariables.openProfileDropdown.value = false;
    for (var controllerAndIcon in overlayPortalControllersAndIcons) {
      if(controllerAndIcon.keys.first == overlayController) continue;
      controllerAndIcon.keys.first.hide();
      controllerAndIcon.values.first.value = false;
    }
  }
}