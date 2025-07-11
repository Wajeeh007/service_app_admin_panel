import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/models/service_item.dart';
import 'package:service_app_admin_panel/screens/service_management/items/items_list/items_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../../helpers/scroll_controller_funcs.dart';
import '../../../../helpers/stop_loader_and_show_snackbar.dart';
import '../../../../models/drop_down_entry.dart';
import '../../../../utils/global_variables.dart';
import '../../../../utils/routes.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class EditItemViewModel extends GetxController {

  /// Controller(s) & Form Keys
  ScrollController scrollController = ScrollController();

  OverlayPortalController overlayPortalController = OverlayPortalController();

  /// For Service Type Dropdown
  TextEditingController subServiceTypeController = TextEditingController();

  /// For Search field
  TextEditingController searchController = TextEditingController();

  /// For Service Addition
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Controller(s) & Form Keys End ///

  /// Variable to store Item details
  ServiceItem serviceItem = ServiceItem();
  
  /// List to store sub-services dropdown entry items.
  RxList<DropDownEntry> subServicesList = <DropDownEntry>[].obs;
  
  /// Variable to store new image Uint8List bytes
  Rx<Uint8List> addedServiceImage = Uint8List(0).obs;

  /// Variable to store the sub-service ID chosen from the dropdown
  RxString subServiceTypeSelectedId = ''.obs;

  /// Variable to store the image URL
  RxString imageUrl = ''.obs;
  
  /// Variable for Dropdown value
  RxBool showSubServiceTypeDropDown = false.obs;
  
  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;
    if(args == null || args.isEmpty) {
      Get.offAllNamed(Routes.itemsList);
    } else {
      serviceItem = args['serviceItemDetails'];
      subServicesList.addAll(args['subServicesList']);
      subServicesList.refresh();
      animateSidePanelScrollController(scrollController, routeName: Routes.itemsList);
      initializeControllers();
    }
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    itemNameController.dispose();
    itemPriceController.dispose();
    searchController.dispose();
    subServiceTypeController.dispose();
    addedServiceImage.value = Uint8List(0);
    super.onClose();
  }

  /// Initialize values of controllers
  void initializeControllers() {
    itemNameController.text = serviceItem.name!;
    itemPriceController.text = serviceItem.price.toString();
    subServiceTypeController.text = serviceItem.subServiceName!;
    subServiceTypeSelectedId.value = serviceItem.subServiceId!;
    imageUrl.value = serviceItem.image!;
  }
  
  /// API call to edit the item details
  void editItem() {
    if(formKey.currentState!.validate()) {
      GlobalVariables.showLoader.value = true;

      var body = {};

      if(itemNameController.text != serviceItem.name) body.addAll({'name': itemNameController.text});
      if(itemPriceController.text != serviceItem.price.toString()) body.addAll({'price': itemPriceController.text});
      if(subServiceTypeSelectedId.value != serviceItem.subServiceId) body.addAll({'sub_service_id': subServiceTypeSelectedId.value});

      if(body.isEmpty) {
        showSnackBar(message: lang_key.noInfoChanged.tr, success: false);
      } else {
        ApiBaseHelper.patchMethod(url: Urls.editItem(serviceItem.id!)).then((value) {
          GlobalVariables.showLoader.value = false;
          if(value.success!) {
            ItemsListViewModel itemsListViewModel = Get.find();
            itemsListViewModel.allItemsList[itemsListViewModel.allItemsList.indexWhere((element) => element.id == serviceItem.id)] = ServiceItem.fromJson(value.data);
            addDataToVisibleList(itemsListViewModel.allItemsList, itemsListViewModel.visibleItemsList);
            Get.back();
            showSnackBar(message: value.message!, success: true);
          } else {
            showSnackBar(message: value.message!, success: false);
          }
        });
      }
    }
  }
}