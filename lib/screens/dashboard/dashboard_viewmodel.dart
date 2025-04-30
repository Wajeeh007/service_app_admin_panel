import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/custom_widgets/custom_dropdown.dart';

import 'models/zone_wise_order_volume.dart';

class DashboardViewModel extends GetxController {

  /// Variables for dropdown
  TextEditingController controller = TextEditingController();
  OverlayPortalController overlayPortalController = OverlayPortalController();
  LayerLink link = LayerLink();

  /// Dropdown list options
  List<DropDownEntry> dropDownList = [
    DropDownEntry(value: 'Today', label: 'Today'),
    DropDownEntry(value: 'Yesterday', label: 'Yesterday'),
    DropDownEntry(value: 'This Week', label: 'This Week'),
    DropDownEntry(value: 'This Month', label: 'This Month'),
  ];

  /// Selected dropdown value
  RxString selectedItem = ''.obs;

  /// Suffix Icon for custom dropdown
  Rx<IconData> suffixIcon = Icons.keyboard_arrow_down_rounded.obs;

  /// Zones order volume result list
  RxList<ZoneWiseOrderVolume> zoneWiseOrderVolumeList = <ZoneWiseOrderVolume>[
    ZoneWiseOrderVolume(
      id: 0,
      zoneName: 'USA',
      percentage: 0.3,
    )
  ].obs;

  @override
  void onReady() {
    selectedItem.value = dropDownList.first.value;
    controller.text = selectedItem.value;
    super.onReady();
  }

  toggleOverlayPortalController() {
    overlayPortalController.toggle();
    if(overlayPortalController.isShowing) {
      suffixIcon.value = Icons.keyboard_arrow_up_rounded;
    } else {
      suffixIcon.value = Icons.keyboard_arrow_down_rounded;
    }
  }
}