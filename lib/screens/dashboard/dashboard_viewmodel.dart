import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/custom_widgets/custom_dropdown.dart';
import 'package:service_app_admin_panel/helpers/global_variables.dart';

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
  Rx<IconData> zoneWiseStatsSuffixIcon = Icons.keyboard_arrow_down_rounded.obs;
  Rx<IconData> adminEarningTimePeriodSuffixIcon = Icons.keyboard_arrow_down_rounded.obs;
  Rx<IconData> adminEarningZoneSelectionSuffixIcon = Icons.keyboard_arrow_down_rounded.obs;

  /// Zones order volume result list
  RxList<ZoneWiseOrderVolume> zoneWiseOrderVolumeList = <ZoneWiseOrderVolume>[
    ZoneWiseOrderVolume(
      id: 0,
      zoneName: 'USA',
      percentage: 0.3,
    )
  ].obs;

  /// List to perform functions collectively on all dropdowns and suffix icons
  List<Map<OverlayPortalController, Rx<IconData>>> overlayPortalControllersAndIcons = [];

  @override
  void onReady() {
    overlayPortalControllersAndIcons = [
      {zoneWiseStatOverlayPortalController: zoneWiseStatsSuffixIcon},
      {adminEarningTimePeriodOverlayPortalController: adminEarningTimePeriodSuffixIcon},
      {adminEarningZoneSelectionOverlayPortalController: adminEarningZoneSelectionSuffixIcon}
    ];
    super.onReady();
  }

  void toggleOverlayPortalController({
    required OverlayPortalController overlayPortalController,
    required Rx<IconData> suffixIcon
  }) {
    hideOtherOverlayPortalControllers(overlayPortalController);
    overlayPortalController.toggle();
    if(overlayPortalController.isShowing) {
      suffixIcon.value = Icons.keyboard_arrow_up_rounded;
    } else {
      suffixIcon.value = Icons.keyboard_arrow_down_rounded;
    }
  }

  /// Hide other overlay portal controllers except the given one
  void hideOtherOverlayPortalControllers(OverlayPortalController overlayController) {
    GlobalVariables.openProfileDropdown.value = false;
    for (var controllerAndIcon in overlayPortalControllersAndIcons) {
      if(controllerAndIcon.keys.first == overlayController) continue;
      controllerAndIcon.keys.first.hide();
      controllerAndIcon.values.first.value = Icons.keyboard_arrow_down_rounded;
    }
  }

  /// Hide all dropdowns and change the suffix icons
  void hideAllOverlayPortalControllers() {
    GlobalVariables.openProfileDropdown.value = false;
    for(var controllerAndIcon in overlayPortalControllersAndIcons) {
      controllerAndIcon.keys.first.hide();
      controllerAndIcon.values.first.value = Icons.keyboard_arrow_down_rounded;
    }
  }
}