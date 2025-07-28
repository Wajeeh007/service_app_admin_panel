import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/models/sub_service.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../../helpers/scroll_controller_funcs.dart';
import '../../../../helpers/stop_loader_and_show_snackbar.dart';
import '../../../../models/drop_down_entry.dart';
import '../../../../utils/api_base_helper.dart';
import '../../../../utils/global_variables.dart';
import '../../../../utils/url_paths.dart';

class SubServicesListViewModel extends GetxController {

  /// Controller(s), LinkOverlay & Form Keys
  ScrollController scrollController = ScrollController();
  OverlayPortalController serviceTypeController = OverlayPortalController();
  LayerLink serviceTypeLink = LayerLink();

    /// For Service Type dropdown
    TextEditingController serviceTypeTextController = TextEditingController();

    /// For Search field
    TextEditingController searchController = TextEditingController();

    /// For Service Addition
    TextEditingController subServiceNameController = TextEditingController();
    GlobalKey<FormState> subServiceAdditionFormKey = GlobalKey<FormState>();

  /// Controller(s) & Form Keys End ///

  /// Sub-Services list data
  List<SubService> allSubServicesList = <SubService>[];
  RxList<SubService> visibleSubServicesList = <SubService>[].obs;

  /// Service types list ///
  RxList<DropDownEntry> servicesList = <DropDownEntry>[].obs;

  /// Added Service image variable
  Rx<Uint8List> addedServiceImage = Uint8List(0).obs;

  /// Show Dropdown bool variables
  RxBool showServiceTypeDropDown = false.obs;

  /// Variable to control auto validation mode.
  RxBool autoValidate = false.obs;

  /// Selected Item index variables
  RxString serviceTypeSelectedId = ''.obs;

  /// Variables for pagination
  int page = 0;
  int limit = 10;
  
  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchServicesAndSubServices();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    subServiceNameController.dispose();
    serviceTypeTextController.dispose();
    searchController.dispose();
    addedServiceImage.value = Uint8List(0);
    super.onClose();
  }

  /// API calls to fetch Sub-services list and services type for selection
  void fetchServicesAndSubServices() async {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    final fetchServices = ApiBaseHelper.getMethod(url: Urls.getServices);
    final fetchSubServices = ApiBaseHelper.getMethod(url: "${Urls.getSubServices}?limit=$limit&page=$page");

    final responses = await Future.wait([fetchServices, fetchSubServices]);

    if (responses[0].success!) populateServiceTypeList(responses[0].data as List);
    if (responses[1].success!) populateLists<SubService, dynamic>(allSubServicesList, responses[1].data, visibleSubServicesList, (dynamic json) => SubService.fromJson(json));

    if(responses[0].success == false && responses[1].success == false) {
      stopLoaderAndShowSnackBar(
          message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}",
          success: false
      );
    }

    GlobalVariables.showLoader.value = false;
  }

  /// API call to only fetch sub-services
  void fetchSubServices() {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.getMethod(url: "${Urls.getSubServices}?limit=$limit&page=$page").then((value) {
      GlobalVariables.showLoader.value = false;
      populateLists<SubService, dynamic>(allSubServicesList, value.data, visibleSubServicesList, (dynamic json) => SubService.fromJson(json));
    });

  }

  /// API call to fetch service types
  void populateServiceTypeList(List<dynamic> data) {
    servicesList.clear();
    servicesList.addAll(data.map((e) => DropDownEntry.fromJson(e)));
    servicesList.refresh();
  }

  /// API call to add a new sub-service
  void addNewSubService() {
    autoValidate.value = true;
    if (subServiceAdditionFormKey.currentState!.validate()) {
      autoValidate.value = false;
      // if (addedServiceImage.value.isNotEmpty && addedServiceImage.value != Uint8List(0)) {

          GlobalVariables.showLoader.value = true;

          ApiBaseHelper.postMethod(url: Urls.addNewSubService, body: {
            'name': subServiceNameController.text,
            'service_id': serviceTypeSelectedId.value,
          }).then((value) {
            stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
            if(value.success!) {
              final subService = SubService.fromJson(value.data);
              allSubServicesList.add(subService);
              addDataToVisibleList(allSubServicesList, visibleSubServicesList);
              clearControllersAndVariables();
            }
          });
        } else {
          showSnackBar(
              message: lang_key.addSubServiceImage.tr,
              success: false
          );
        // }
    }
  }

  /// Delete sub-service by ID.
  void deleteService(String serviceId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.deleteMethod(url: Urls.deleteSubService(serviceId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        final allSubServicesListIndex = allSubServicesList.indexWhere((element) => element.id == serviceId);
        final visibleSubServicesListIndex = visibleSubServicesList.indexWhere((element) => element.id == serviceId);

        allSubServicesList.removeAt(allSubServicesListIndex);
        visibleSubServicesList.removeAt(visibleSubServicesListIndex);
        visibleSubServicesList.refresh();
      }
    });
  }

  /// Change sub-service status to active or in-active.
  void changeServiceStatus(String subServiceId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.patchMethod(url: Urls.changeSubServiceStatus(subServiceId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
      if(value.success!) {
        final index = allSubServicesList.indexWhere((element) => element.id == subServiceId);
        allSubServicesList[index].status = !allSubServicesList[index].status!;
        addDataToVisibleList(allSubServicesList, visibleSubServicesList);
      }
    });
  }

  /// Search table for sub-service by name.
  void searchTableForSubService(String? value) {
    if(value == '' || value == null || value.isEmpty) {
      addDataToVisibleList(allSubServicesList, visibleSubServicesList);
    } else {
      addDataToVisibleList(
          allSubServicesList.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList(),
          visibleSubServicesList
      );
    }
  }

  /// Clear controllers and variables after adding service.
  void clearControllersAndVariables() {
    subServiceNameController.clear();
    serviceTypeTextController.clear();
    serviceTypeSelectedId.value = '';
    addedServiceImage.value = Uint8List(0);
    showServiceTypeDropDown.value = false;
    serviceTypeController.hide();
  }
  
}