
import 'package:flutter/material.dart';

import '../utils/constants.dart';

void animateSidePanelScrollController(ScrollController scrollController, double offset) {
  Future.delayed(Duration(seconds: 1), () => scrollController.animateTo(
      offset,
      duration: sidePanelAnimationDuration,
      curve: sidePanelAnimationCurve
  ));
}
