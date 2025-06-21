import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/scroll_controller_funcs.dart';
import 'package:service_app_admin_panel/helpers/show_snackbar.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/sub_service_category.dart';
import 'package:service_app_admin_panel/screens/service_management/sub_services/sub_service_list/sub_services_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../../models/drop_down_entry.dart';

class EditSubServiceViewModel extends GetxController {

  /// Controller(s) & Form Key(s)
  ScrollController scrollController = ScrollController();
  GlobalKey<FormState> subServiceEditFormKey = GlobalKey<FormState>();
  OverlayPortalController serviceTypeController = OverlayPortalController();
  TextEditingController nameController = TextEditingController();
  TextEditingController serviceTypeTextController = TextEditingController();

  /// Dropdown Entries list
  RxList<DropDownEntry> servicesList = <DropDownEntry>[].obs;

  /// Show Dropdown bool variables
  RxBool showServiceTypeDropDown = false.obs;

  /// Variable to store the service ID chosen from the dropdown
  RxString serviceTypeSelectedId = ''.obs;

  /// Variable to store the image URL
  RxString imageUrl = ''.obs;

  /// Variable to control auto validation mode.
  RxBool autoValidate = false.obs;

  /// New Added Service image variable
  Rx<Uint8List> addedServiceImage = Uint8List(0).obs;

  /// Variable to hold Sub-Service details
  SubServiceCategory subServiceDetails = SubServiceCategory();

  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;
    if(args == null || args.isEmpty) {
      Get.offAllNamed(Routes.subServicesList);
    } else {
      subServiceDetails = args['subServiceDetails'];
      servicesList.addAll(args['servicesList']);
      animateSidePanelScrollController(scrollController, routeName: Routes.subServicesList);
      initializeControllers();
    }
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    nameController.dispose();
    serviceTypeTextController.dispose();
    addedServiceImage.value = Uint8List(0);
    super.onClose();
  }

  /// Edit service API call
  void editService() {

    GlobalVariables.showLoader.value = true;

    var body = {};

    if(nameController.text != subServiceDetails.name) body.addAll({'name': nameController.text});
    if(serviceTypeSelectedId.value != subServiceDetails.serviceId) body.addAll({'service_id': serviceTypeSelectedId.value});

    ApiBaseHelper.patchMethod(
      url: Urls.editSubService(subServiceDetails.id!),
      body: body
    ).then((value) {
      GlobalVariables.showLoader.value = false;
      if(value.success!) {
        SubServicesListViewModel subServicesListViewModel = Get.find();
        subServicesListViewModel.allSubServicesList[subServicesListViewModel.allSubServicesList.indexWhere((element) => element.id == subServiceDetails.id)] = SubServiceCategory.fromJson(value.data);
        subServicesListViewModel.addSubServicesToVisibleList();
        Get.back();
        showSnackBar(message: value.message!, success: true);
      } else {
        showSnackBar(message: value.message!, success: false);
      }
    });

  }

  /// Initialize values of controllers
  void initializeControllers() {
    nameController.text = subServiceDetails.name!;
    serviceTypeTextController.text = subServiceDetails.serviceName!;
    serviceTypeSelectedId.value = subServiceDetails.serviceId!;
    imageUrl.value = subServiceDetails.image!;
  }
}