
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

void animateSidePanelScrollController(ScrollController scrollController, {String? routeName}) {
  Future.delayed(Duration(seconds: 1), () => scrollController.animateTo(
      routeName == null || routeName == '' ? sidePanelScrollPositions.firstWhere((element) => element.keys.first == Get.currentRoute).values.first : sidePanelScrollPositions.firstWhere((element) => element.keys.first == routeName).values.first,
      duration: sidePanelAnimationDuration,
      curve: sidePanelAnimationCurve
  ));
}
