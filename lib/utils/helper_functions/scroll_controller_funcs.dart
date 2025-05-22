
import 'package:flutter/material.dart';

import '../constants.dart';

void animateSidePanelScrollController(ScrollController scrollController, double offset) {
  scrollController.animateTo(
      offset,
      duration: sidePanelAnimationDuration,
      curve: sidePanelAnimationCurve
  );
}
