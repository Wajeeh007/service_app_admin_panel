import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app_admin_panel/models/service_category.dart';

import '../../../utils/constants.dart';
import '../../../utils/helper_functions/scroll_controller_funcs.dart';

class ServiceListViewModel extends GetxController {

  /// Controller(s) & Form Keys
    /// For Search field
    TextEditingController searchController = TextEditingController();
    GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();

    /// For Service Addition
    TextEditingController serviceAdditionController = TextEditingController();
    GlobalKey<FormState> serviceAdditionFormKey = GlobalKey<FormState>();

  /// Controller(s) & Form Keys End ///

  /// Services list data
  RxList<ServiceCategory> servicesList = <ServiceCategory>[].obs;

  /// Added Service image variable
  Rx<XFile> addedServiceImage = XFile('').obs;

  @override
  void onReady() {
    animateSidePanelScrollController(sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'serviceManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    detachSidePanelScrollController();
    super.onClose();
  }
}