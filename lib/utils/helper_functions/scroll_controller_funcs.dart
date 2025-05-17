
import '../constants.dart';
import '../global_variables.dart';

void animateSidePanelScrollController(double offset) {
  GlobalVariables.scrollController.animateTo(
      offset,
      duration: sidePanelAnimationDuration,
      curve: sidePanelAnimationCurve
  );
}

void detachSidePanelScrollController() {
  GlobalVariables.scrollController.detach(GlobalVariables.scrollController.positions.first);
}