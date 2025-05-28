
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

void animateSidePanelScrollController(ScrollController scrollController) {
  Future.delayed(Duration(seconds: 1), () => scrollController.animateTo(
      sidePanelScrollPositions.firstWhere((element) => element.keys.first == Get.currentRoute).values.first,
      duration: sidePanelAnimationDuration,
      curve: sidePanelAnimationCurve
  ));
}
