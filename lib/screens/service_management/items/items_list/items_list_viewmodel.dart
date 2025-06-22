import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/service_item.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../../helpers/scroll_controller_funcs.dart';
import '../../../../helpers/show_snackbar.dart';
import '../../../../helpers/stop_loader_and_show_snackbar.dart';
import '../../../../models/drop_down_entry.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../../../../utils/global_variables.dart';

class ItemsListViewModel extends GetxController {

  /// Controller(s), LinkOverlay & Form Keys
  ScrollController scrollController = ScrollController();

  OverlayPortalController overlayPortalController = OverlayPortalController();

    /// For Service Type Dropdown
    TextEditingController subServiceTypeController = TextEditingController();

    /// For Search field
    TextEditingController searchController = TextEditingController();
  
    /// For Service Addition
    TextEditingController itemNameController = TextEditingController();
    TextEditingController itemPriceController = TextEditingController();
    GlobalKey<FormState> itemAdditionFormKey = GlobalKey<FormState>();

  /// Controller(s) & Form Keys End ///

  /// Items list data
  List<ServiceItem> allItemsList = <ServiceItem>[];
  RxList<ServiceItem> visibleItemsList = <ServiceItem>[].obs;

  /// Sub-Services list for dropdown ///
  RxList<DropDownEntry> subServicesList = <DropDownEntry>[].obs;

  /// Added Service image variable
  Rx<Uint8List> addedItemImage = Uint8List(0).obs;

  /// Show Dropdown bool variables
  RxBool showSubServiceTypeDropDown = false.obs;

  /// Selected Item index variables
  RxString subServiceTypeSelectedId = ''.obs;

  /// Variables for pagination
  int page = 0;
  int limit = 10;

  @override
  void onInit() {
    fetchSubServicesAndItems();
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

  /// Fetch both sub-services and items simultaneously.
  Future<void> fetchSubServicesAndItems() async {
    
    final fetchItems = ApiBaseHelper.getMethod(url: "${Urls.getItems}?limit=$limit&page=$page");
    final fetchSubServices = ApiBaseHelper.getMethod(url: Urls.getSubServices);

    final responses = await Future.wait([fetchItems, fetchSubServices]);

    if (responses[0].success!) populateItemsList(responses[0].data as List);
    if (responses[1].success!) populateSubServicesList(responses[1].data as List);

    if(responses[0].success == false && responses[1].success == false) {
      stopLoaderAndShowSnackBar(
          message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}",
          success: false
      );
    }

    GlobalVariables.showLoader.value = false;
  }

  /// API call to only fetch service items.
  void fetchServiceItems() {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.getMethod(url: "${Urls.getItems}?limit=$limit&page=$page").then((value) {
      GlobalVariables.showLoader.value = false;
      populateItemsList(value.data as List);
    });
  }

  /// Populate Sub-services dropdown list.
  void populateSubServicesList(List<dynamic> data) {
    subServicesList.clear();
    subServicesList.addAll(data.map((e) => DropDownEntry.fromJson(e)));
    subServicesList.refresh();
  }

  /// Populate Items list.
  void populateItemsList(List<dynamic> data) {
    allItemsList.clear();
    allItemsList.addAll(data.map((e) => ServiceItem.fromJson(e)));
    addItemsToVisibleList();
  }

  /// API call for adding a new Item.
  void addNewItem() {
    if(itemAdditionFormKey.currentState!.validate()) {
      if(addedItemImage.value != Uint8List(0) && addedItemImage.value.isNotEmpty) {

      } else {
        showSnackBar(
            message: lang_key.addItemImage.tr,
            success: false
        );
      }
    }
  }

  /// Delete sub-service by ID.
  void deleteItem(String serviceId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.deleteMethod(url: Urls.deleteSubService(serviceId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        final allSubServicesListIndex = allItemsList.indexWhere((element) => element.id == serviceId);
        final visibleSubServicesListIndex = visibleItemsList.indexWhere((element) => element.id == serviceId);

        allItemsList.removeAt(allSubServicesListIndex);
        visibleItemsList.removeAt(visibleSubServicesListIndex);
        visibleItemsList.refresh();
      }
    });
  }

  /// Change sub-service status to active or in-active.
  void changeItemStatus(String subServiceId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.patchMethod(url: Urls.changeSubServiceStatus(subServiceId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
      if(value.success!) {
        final index = allItemsList.indexWhere((element) => element.id == subServiceId);
        allItemsList[index].status = !allItemsList[index].status!;
        addItemsToVisibleList();
      }
    });
  }

  /// Search table for service item by name.
  void searchTableForServiceItem(String? value) {
    if(value == '' || value == null || value.isEmpty) {
      addItemsToVisibleList();
    } else {
      visibleItemsList.clear();
      for (var element in allItemsList) {
        if(element.name!.toLowerCase().trim().contains(value.toLowerCase().trim())) {
          visibleItemsList.add(element);
          visibleItemsList.refresh();
        }
      }
    }
  }

  /// Function to clear and add items to the visible list
  addItemsToVisibleList() {
    visibleItemsList.clear();
    visibleItemsList.addAll(allItemsList);
    visibleItemsList.refresh();
  }
}