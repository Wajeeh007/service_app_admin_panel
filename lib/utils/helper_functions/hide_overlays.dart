import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_variables.dart';

/// Hide all dropdowns and change the suffix icons
void hideAllOverlayPortalControllers({
  List<Map<OverlayPortalController, RxBool>>? overlayPortalControllersAndIcons
}) {
  GlobalVariables.openProfileDropdown.value = false;
  if(overlayPortalControllersAndIcons != null && overlayPortalControllersAndIcons.isNotEmpty){
    for (var controllerAndIcon in overlayPortalControllersAndIcons) {
      controllerAndIcon.keys.first.hide();
      controllerAndIcon.values.first.value = false;
    }
  }
}