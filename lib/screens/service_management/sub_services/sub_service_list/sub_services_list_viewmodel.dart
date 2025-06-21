import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app_admin_panel/models/sub_service_category.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../../helpers/scroll_controller_funcs.dart';
import '../../../../helpers/show_snackbar.dart';
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
  List<SubServiceCategory> allSubServicesList = <SubServiceCategory>[];
  RxList<SubServiceCategory> visibleSubServicesList = <SubServiceCategory>[].obs;

  /// Service types list ///
  RxList<DropDownEntry> servicesList = <DropDownEntry>[].obs;

  /// Added Service image variable
  Rx<Uint8List> addedServiceImage = Uint8List(0).obs;

  /// Show Dropdown bool variables
  RxBool showServiceTypeDropDown = false.obs;

  /// Selected Item index variables
  RxInt? serviceTypeSelectedIndex;

  /// Variables for pagination
  int page = 0;
  int limit = 10;

  @override
  void onInit() {
    fetchSubServices();
    super.onInit();
  }
  
  @override
  void onReady() {
    GlobalVariables.showLoader.value = true;
    animateSidePanelScrollController(scrollController);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Toggle dropdown and it's value
  void toggleOverlay({required OverlayPortalController overlayPortalController, required RxBool showDropDown}) {
    overlayPortalController.toggle();
    if(overlayPortalController.isShowing) {
      showDropDown.value = true;
    } else {
      showDropDown.value = false;
    }
  }

  /// API Call to fetch sub-services
  void fetchSubServices() {

    ApiBaseHelper.getMethod(url: "${Urls.getSubServices}?limit=$limit&page=$page").then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        allSubServicesList.clear();
        final data = value.data! as List;
        allSubServicesList.addAll(data.map((e) => SubServiceCategory.fromJson(e)));
        addSubServicesToVisibleList();
      } else {
        showSnackBar(message: value.message!, success: false);
      }
    });
  }

  void addNewSubService() {
    if (subServiceAdditionFormKey.currentState!.validate()) {
      if (serviceTypeSelectedIndex != null) {
        if (addedServiceImage.value.isNotEmpty && addedServiceImage.value != Uint8List(0)) {

        } else {
          showSnackBar(
              message: lang_key.addSubServiceImage.tr,
              success: true
          );
        }
      } else {
        showSnackBar(
            message: lang_key.addServiceError.tr,
            success: true
        );
      }
    }
  }

  /// Delete sub-service by ID.
  void deleteService(String serviceId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.deleteMethod(url: Urls.deleteService(serviceId)).then((value) {
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

    ApiBaseHelper.patchMethod(url: Urls.changeServiceStatus(subServiceId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
      if(value.success!) {
        final index = allSubServicesList.indexWhere((element) => element.id == subServiceId);
        allSubServicesList[index].status = !allSubServicesList[index].status!;
        final index2 = visibleSubServicesList.indexWhere((element) => element.id == subServiceId);
        visibleSubServicesList[index2].status = !visibleSubServicesList[index2].status!;
        visibleSubServicesList.refresh();
      }
    });
  }

  /// Search table for service by name.
  void searchTableForSubService(String? value) {
    if(value == '' || value == null || value.isEmpty) {
      addSubServicesToVisibleList();
    } else {
      visibleSubServicesList.clear();
      for (var element in allSubServicesList) {
        if(element.name!.toLowerCase().trim().contains(value.toLowerCase().trim())) {
          visibleSubServicesList.add(element);
          visibleSubServicesList.refresh();
        }
      }
    }
  }
  
  addSubServicesToVisibleList() {
    visibleSubServicesList.clear();
    visibleSubServicesList.addAll(allSubServicesList);
    visibleSubServicesList.refresh();
  }
  
  
}