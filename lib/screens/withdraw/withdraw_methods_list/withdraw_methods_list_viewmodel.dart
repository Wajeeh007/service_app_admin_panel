import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_snackbar.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/withdraw_method.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/populate_lists.dart';
import '../../../helpers/scroll_controller_funcs.dart';

class WithdrawMethodsListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form Key(s)

  late TabController tabController;
  ScrollController scrollController = ScrollController();

  OverlayPortalController fieldTypeOverlayPortalController = OverlayPortalController();

    /// For field type dropdown
    TextEditingController fieldTypeTextController = TextEditingController();

    /// New Method Information
    TextEditingController newMethodNameController = TextEditingController();
    TextEditingController newMethodFieldNameController = TextEditingController();
    TextEditingController newMethodPlaceholderTextController = TextEditingController();
    GlobalKey<FormState> newMethodInfoFormKey = GlobalKey<FormState>();

    /// For Methods list searching
    TextEditingController allMethodsSearchController = TextEditingController();
    TextEditingController activeMethodsSearchController = TextEditingController();
    TextEditingController inActiveMethodsSearchController = TextEditingController();

  /// Checkbox value variable
  RxBool makeMethodFieldDefaultValue = false.obs;

  /// Show Dropdown value
  RxBool showDropDown = false.obs;

  /// Dropdown Selected Value
  RxString dropDownSelectedValue = ''.obs;

  /// Tabs Names list
  List<String> tabsNames = [
    lang_key.all.tr,
    lang_key.active.tr,
    lang_key.inactive.tr,
  ];

  /// All Tabs pagination variables
  RxInt allMethodsPage = 0.obs;
  int allMethodsLimit = 10;

  /// Active Tabs pagination variables
  RxInt activeMethodsPage = 0.obs;
  int activeMethodsLimit = 10;

  /// In-Active Tabs pagination variables
  RxInt inActiveMethodsPage = 0.obs;
  int inActiveMethodsLimit = 10;

  /// Lists for all, active and in-active methods
  List<WithdrawMethod> allMethodsList = <WithdrawMethod>[];
  List<WithdrawMethod> activeMethodsList = <WithdrawMethod>[];
  List<WithdrawMethod> inActiveMethodsList = <WithdrawMethod>[];

  RxList<WithdrawMethod> visibleAllMethodsList = <WithdrawMethod>[].obs;
  RxList<WithdrawMethod> visibleActiveMethodsList = <WithdrawMethod>[].obs;
  RxList<WithdrawMethod> visibleInActiveMethodsList = <WithdrawMethod>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: tabsNames.length, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchAllMethods();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    tabController.dispose();
    newMethodNameController.dispose();
    newMethodFieldNameController.dispose();
    newMethodPlaceholderTextController.dispose();
    fieldTypeTextController.dispose();
    allMethodsSearchController.dispose();
    activeMethodsSearchController.dispose();
    inActiveMethodsSearchController.dispose();
    super.onClose();
  }

  /// Fetch all, active and in-active methods
  void fetchAllMethods() async {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    final fetchAllMethods = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$allMethodsLimit&page=${allMethodsPage.value}");
    final fetchActiveMethods = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$activeMethodsLimit&page=${activeMethodsPage.value}&status=1");
    final fetchInActiveMethods = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$inActiveMethodsLimit&page=${inActiveMethodsPage.value}&status=0");

    final response = await Future.wait([fetchAllMethods, fetchActiveMethods, fetchInActiveMethods]);

    if(response[0].success!) populateLists<WithdrawMethod, dynamic>(allMethodsList, response[0].data as List, visibleAllMethodsList, (dynamic json) => WithdrawMethod.fromJson(json));
    if(response[1].success!) populateLists<WithdrawMethod, dynamic>(activeMethodsList,response[1].data as List, visibleActiveMethodsList, (dynamic json) => WithdrawMethod.fromJson(json));
    if(response[2].success!) populateLists<WithdrawMethod, dynamic>(inActiveMethodsList, response[2].data as List, visibleInActiveMethodsList, (dynamic json) => WithdrawMethod.fromJson(json));

    if(!response[0].success! && !response[1].success! && !response[2].success!) {
      stopLoaderAndShowSnackBar(
          message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}",
          success: false
      );
    }

    GlobalVariables.showLoader.value = false;
  }

  /// Fetch methods based on their status, i.e., active or in-active
  void fetchStatusBasedMethods(bool status) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=${status ? activeMethodsLimit : inActiveMethodsLimit}&page=${status ? activeMethodsPage.value : inActiveMethodsPage.value}&status=${status ? 1 : 0}").then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        populateLists<WithdrawMethod, dynamic>(status ? activeMethodsList : inActiveMethodsList, value.data, status ? visibleActiveMethodsList : visibleInActiveMethodsList, (dynamic json) => WithdrawMethod.fromJson(json));
      }
    });
  }

  /// API call to add a new Withdraw Method
  void addWithdrawMethod() {
    if(newMethodInfoFormKey.currentState!.validate()) {

      GlobalVariables.showLoader.value = true;

      ApiBaseHelper.postMethod(url: Urls.addWithdrawMethod, body: {
        'name': newMethodNameController,
        'field_type': fieldTypeTextController.text,
        'field_name': newMethodFieldNameController.text,
        'placeholder_text': newMethodPlaceholderTextController.text,
        'is_default': makeMethodFieldDefaultValue.value ? 1 : 0,
      }).then((value) {
        stopLoaderAndShowSnackBar(success: value.success!, message: value.message!);

        if(value.success!) {
          allMethodsList.add(WithdrawMethod.fromJson(value.data));
          activeMethodsList.add(WithdrawMethod.fromJson(value.data));
          visibleAllMethodsList.add(WithdrawMethod.fromJson(value.data));
          visibleActiveMethodsList.add(WithdrawMethod.fromJson(value.data));
          visibleActiveMethodsList.refresh();
          visibleAllMethodsList.refresh();
          clearControllersAndVariables();
        }
      });
    }
  }

  /// API call to change the status of a method from All methods list
  void changeWithdrawMethodStatusFromAllList(int index) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.patchMethod(url: Urls.changeWithdrawMethodStatus(visibleAllMethodsList[index].id!)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        int allMethodsListIndex = allMethodsList.indexWhere((element) => element.id == visibleAllMethodsList[index].id);
        final status = allMethodsList[allMethodsListIndex].status!;
        allMethodsList[allMethodsListIndex].status = !allMethodsList[allMethodsListIndex].status!;

        if(status) {
          int allActiveMethodsListIndex = activeMethodsList.indexWhere((element) => element.id == visibleAllMethodsList[index].id!);
          if(allActiveMethodsListIndex != -1) {
            activeMethodsList.removeAt(allActiveMethodsListIndex);
            visibleActiveMethodsList.removeAt(allActiveMethodsListIndex);
            visibleActiveMethodsList.refresh();
          }
          inActiveMethodsList.add(allMethodsList[allMethodsListIndex]);
          visibleInActiveMethodsList.add(allMethodsList[allMethodsListIndex]);
          visibleInActiveMethodsList.refresh();
          addDataToVisibleList(allMethodsList, visibleAllMethodsList);
        } else {
          int allInActiveMethodsListIndex = inActiveMethodsList.indexWhere((element) => element.id == visibleAllMethodsList[index].id!);
          if(allInActiveMethodsListIndex != -1) {
            inActiveMethodsList.removeAt(allInActiveMethodsListIndex);
            visibleInActiveMethodsList.removeAt(allInActiveMethodsListIndex);
            visibleInActiveMethodsList.refresh();
          }
          activeMethodsList.add(allMethodsList[allMethodsListIndex]);
          visibleActiveMethodsList.add(allMethodsList[allMethodsListIndex]);
          visibleActiveMethodsList.refresh();
          addDataToVisibleList(allMethodsList, visibleAllMethodsList);
        }

      }
    });
  }

  /// API call to change the status of a method from either active or in-active list.
  void changeWithdrawMethodStatusFromActiveOrInActiveList(int index, bool status) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.patchMethod(url: Urls.changeWithdrawMethodStatus(
        status ? activeMethodsList[index].id! : inActiveMethodsList[index].id!
    )).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {

        final allMethodsListIndex = allMethodsList.indexWhere((element) => element.id == (status ? visibleActiveMethodsList[index].id! : visibleInActiveMethodsList[index].id!));
        if(allMethodsListIndex != -1) {
          allMethodsList[allMethodsListIndex].status = !allMethodsList[allMethodsListIndex].status!;

          addDataToVisibleList(allMethodsList, visibleAllMethodsList);
        }
        if(status) {
          int allActiveMethodsListIndex = activeMethodsList.indexWhere((element) => element.id == visibleActiveMethodsList[index].id!);
          activeMethodsList[allActiveMethodsListIndex].status = !activeMethodsList[allActiveMethodsListIndex].status!;

          inActiveMethodsList.add(activeMethodsList[allActiveMethodsListIndex]);
          visibleInActiveMethodsList.add(activeMethodsList[allActiveMethodsListIndex]);
          visibleInActiveMethodsList.refresh();

          activeMethodsList.removeAt(allActiveMethodsListIndex);
          visibleActiveMethodsList.removeAt(index);
          visibleActiveMethodsList.refresh();
        } else {
          int allInActiveMethodsListIndex = inActiveMethodsList.indexWhere((element) => element.id == visibleInActiveMethodsList[index].id!);
          inActiveMethodsList[allInActiveMethodsListIndex].status = !inActiveMethodsList[allInActiveMethodsListIndex].status!;

          activeMethodsList.add(inActiveMethodsList[allInActiveMethodsListIndex]);
          visibleActiveMethodsList.add(inActiveMethodsList[allInActiveMethodsListIndex]);
          visibleActiveMethodsList.refresh();

          inActiveMethodsList.removeAt(allInActiveMethodsListIndex);
          visibleInActiveMethodsList.removeAt(index);
          visibleInActiveMethodsList.refresh();
        }
      }
    });
  }

  /// API call to delete a Withdraw Method
  void deleteWithdrawMethodFromAllList(String id) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.deleteMethod(url: Urls.deleteWithdrawMethod(id)).then((value) {

      GlobalVariables.showLoader.value = false;

      if(value.success!) {

        int index = allMethodsList.indexWhere((element) => element.id == id);
        final status = allMethodsList[index].status!;

        allMethodsList.removeAt(allMethodsList.indexWhere((element) => element.id == id));

        addDataToVisibleList(allMethodsList, visibleAllMethodsList);

        if(status) {
          activeMethodsList.removeAt(activeMethodsList.indexWhere((element) => element.id == id));

          addDataToVisibleList(activeMethodsList, visibleActiveMethodsList);
        } else {
          inActiveMethodsList.removeAt(inActiveMethodsList.indexWhere((element) => element.id == id));

          addDataToVisibleList(inActiveMethodsList, visibleInActiveMethodsList);
        }
        Get.back();
        showSnackBar(message: value.message!, success: value.success!);
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }
    });
  }

  /// API call to delete a Withdraw Method from Active or In-active list
  void deleteWithdrawMethodFromActiveOrInActiveList(String id, bool status) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.deleteMethod(url: Urls.deleteWithdrawMethod(id)).then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!, goBack: value.success! ? true : false);

      if(value.success!) {
        if (status) {
          activeMethodsList.removeAt(activeMethodsList.indexWhere((element) => element.id == id));
          addDataToVisibleList(activeMethodsList, visibleActiveMethodsList);
        } else {
          inActiveMethodsList.removeAt(inActiveMethodsList.indexWhere((element) => element.id == id));
          addDataToVisibleList(inActiveMethodsList, visibleInActiveMethodsList);
        }
      }
    });
  }

  /// Search and populate the lists accordingly.
  void searchListForMethod(TextEditingController controller, RxList<WithdrawMethod> visibleList, List<WithdrawMethod> allList) {
    if(controller.text.isEmpty || controller.text == '') {
        addDataToVisibleList(allList, visibleList);
    } else {
      addDataToVisibleList(allList.where((element) => element.name!.toLowerCase().contains(controller.text.toLowerCase())).toList(), visibleList);
    }
  }

  /// Clear controllers once the method is added
  void clearControllersAndVariables() {
    newMethodNameController.clear();
    newMethodPlaceholderTextController.clear();
    newMethodFieldNameController.clear();
    fieldTypeTextController.clear();
    makeMethodFieldDefaultValue.value = false;
    showDropDown.value = false;
    dropDownSelectedValue.value = '';
  }
}