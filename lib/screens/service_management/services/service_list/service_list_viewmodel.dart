import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/service_category.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../../helpers/scroll_controller_funcs.dart';

class ServiceListViewModel extends GetxController {

  /// Controller(s) & Form Keys
  ScrollController scrollController = ScrollController();
    /// For Search field
    TextEditingController searchController = TextEditingController();

    /// For Service Addition
    TextEditingController serviceNameController = TextEditingController();
    TextEditingController serviceDescController = TextEditingController();
    GlobalKey<FormState> serviceAdditionFormKey = GlobalKey<FormState>();

  /// Controller(s) & Form Keys End ///

  /// Services list data
  List<ServiceCategory> allServicesList = <ServiceCategory>[];
  RxList<ServiceCategory> visibleServicesList = <ServiceCategory>[].obs;

  /// Added Service image variable
  Rx<Uint8List> addedServiceImage = Uint8List(0).obs;

  /// Variables for pagination
  int page = 0;
  int limit = 10;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchServices();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    serviceNameController.dispose();
    serviceDescController.dispose();
    super.onClose();
  }

  /// API Call to fetch services
  void fetchServices() {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: "${Urls.getServices}?limit=$limit&page=$page").then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        populateLists<ServiceCategory, dynamic>(allServicesList, value.data, visibleServicesList, (dynamic json) => ServiceCategory.fromJson(json));
      } else {
        showSnackBar(message: value.message!, success: false);
      }
    });
  }

  /// API call to add a new service.
  void addNewService() {
    if(serviceAdditionFormKey.currentState!.validate()) {
      final body = {
        'name': serviceNameController.text,
        'desc': serviceDescController.text,
      };

      GlobalVariables.showLoader.value = true;

      ApiBaseHelper.postMethod(url: Urls.addNewService, body: body).then((value) {

        stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

        if(value.success!) {
          allServicesList.add(ServiceCategory.fromJson(value.data));
          addServicesToVisibleList();
          clearControllersAndVariables();
        }
      });
    }
  }

  /// Delete service by ID.
  void deleteService(String serviceId) {
    GlobalVariables.showLoader.value = true;
    
    ApiBaseHelper.deleteMethod(url: Urls.deleteService(serviceId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        final allServicesListIndex = allServicesList.indexWhere((element) => element.id == serviceId);
        final visibleServicesListIndex = visibleServicesList.indexWhere((element) => element.id == serviceId);

        allServicesList.removeAt(allServicesListIndex);
        visibleServicesList.removeAt(visibleServicesListIndex);
        visibleServicesList.refresh();
      }
    });
  }
  
  /// Change Service status to active or in-active.
  void changeServiceStatus(String serviceId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.patchMethod(url: Urls.changeServiceStatus(serviceId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
      if(value.success!) {
        final index = allServicesList.indexWhere((element) => element.id == serviceId);
        allServicesList[index].status = !allServicesList[index].status!;
        addServicesToVisibleList();
      }
    });
  }

  /// Search table for service by name.
  void searchTableForService(String? value) {
    if(value == '' || value == null || value.isEmpty) {
      addServicesToVisibleList();
    } else {
      visibleServicesList.clear();
      for (var element in allServicesList) {
        if(element.name!.toLowerCase().trim().contains(value.toLowerCase().trim())) {
          visibleServicesList.add(element);
          visibleServicesList.refresh();
        }
      }
    }
  }

  /// Add services data to visible list. The data shown on the table will be shown from this list.
  void addServicesToVisibleList() {
    visibleServicesList.clear();
    visibleServicesList.addAll(allServicesList);
    visibleServicesList.refresh();
  }

  /// Clear controllers and any other variables
  void clearControllersAndVariables() {
    serviceNameController.clear();
    serviceDescController.clear();
    addedServiceImage.value = Uint8List(0);
  }
}