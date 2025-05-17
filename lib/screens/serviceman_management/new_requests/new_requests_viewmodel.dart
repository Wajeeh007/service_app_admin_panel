import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';

import '../../../utils/constants.dart';
import '../../../utils/helper_functions/scroll_controller_funcs.dart';

class NewRequestsViewModel extends GetxController {

  /// New Servicemen requests received to admin
  RxList<ServiceMan> serviceManNewRequests = <ServiceMan>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'serviceManManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    detachSidePanelScrollController();
    super.onClose();
  }

}