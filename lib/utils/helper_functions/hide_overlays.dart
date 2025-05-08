import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_variables.dart';

/// Hide all dropdowns and change the suffix icons
void hideAllOverlayPortalControllers({required List<Map<OverlayPortalController, Rx<IconData>>> overlayPortalControllersAndIcons}) {
  GlobalVariables.openProfileDropdown.value = false;
  for(var controllerAndIcon in overlayPortalControllersAndIcons) {
    controllerAndIcon.keys.first.hide();
    controllerAndIcon.values.first.value = Icons.keyboard_arrow_down_rounded;
  }
}