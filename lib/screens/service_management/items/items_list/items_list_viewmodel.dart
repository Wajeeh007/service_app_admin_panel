import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
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

    if (responses[0].success!) populateLists<ServiceItem, dynamic>(allItemsList, responses[0].data, visibleItemsList, (dynamic json) => ServiceItem.fromJson(json));
    if (responses[1].success!) populateSubServicesList(responses[1].data as List);

    if(!responses[0].success! && !responses[1].success!) {
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
      populateLists<ServiceItem, dynamic>(allItemsList, value.data, visibleItemsList, (dynamic json) => ServiceItem.fromJson(json));
    });
  }

  /// Populate Sub-services dropdown list.
  void populateSubServicesList(List<dynamic> data) {
    subServicesList.clear();
    subServicesList.addAll(data.map((e) => DropDownEntry.fromJson(e)));
    subServicesList.refresh();
  }

  /// API call for adding a new Item.
  void addNewItem() {
    if(itemAdditionFormKey.currentState!.validate()) {
      if(addedItemImage.value != Uint8List(0) && addedItemImage.value.isNotEmpty) {

        GlobalVariables.showLoader.value = true;

        ApiBaseHelper.postMethod(url: Urls.addItem, body: {
          'name': itemNameController.text,
          'price': int.tryParse(itemPriceController.text),
          'sub_service_id': subServiceTypeSelectedId.value,
        }).then((value) {
          stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

          if(value.success!) {
            final newServiceItem = ServiceItem.fromJson(value.data!);
            allItemsList.add(newServiceItem);
            visibleItemsList.add(newServiceItem);
            visibleItemsList.refresh();
          }
        });
      } else {
        showSnackBar(
            message: lang_key.addItemImage.tr,
            success: false
        );
      }
    }
  }

  /// Delete service item by ID.
  void deleteItem(String serviceItemId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.deleteMethod(url: Urls.deleteItem(serviceItemId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        final allSubServicesListIndex = allItemsList.indexWhere((element) => element.id == serviceItemId);
        final visibleSubServicesListIndex = visibleItemsList.indexWhere((element) => element.id == serviceItemId);

        allItemsList.removeAt(allSubServicesListIndex);
        visibleItemsList.removeAt(visibleSubServicesListIndex);
        visibleItemsList.refresh();
      }
    });
  }

  /// Change service item status to active or in-active.
  void changeItemStatus(String serviceItemId) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.patchMethod(url: Urls.changeItemStatus(serviceItemId)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
      if(value.success!) {
        final index = allItemsList.indexWhere((element) => element.id == serviceItemId);
        allItemsList[index].status = !allItemsList[index].status!;
        addDataToVisibleList(allItemsList, visibleItemsList);
      }
    });
  }

  /// Search table for service item by name.
  void searchTableForServiceItem(String? value) {
    if(value == '' || value == null || value.isEmpty) {
      addDataToVisibleList(allItemsList, visibleItemsList);
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
}