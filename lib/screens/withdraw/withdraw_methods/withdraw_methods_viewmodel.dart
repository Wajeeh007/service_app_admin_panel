import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/drop_down_entry.dart';
import 'package:service_app_admin_panel/models/withdraw_method.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/scroll_controller_funcs.dart';

class WithdrawMethodsViewModel extends GetxController with GetSingleTickerProviderStateMixin {

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

  /// New Method field type dropdown entries
  List<DropDownEntry> newMethodFieldTypeDropdownEntries = [
    DropDownEntry(value: WithdrawMethodFieldType.text, label: lang_key.text.tr),
    DropDownEntry(value: WithdrawMethodFieldType.number, label: lang_key.number.tr),
    DropDownEntry(value: WithdrawMethodFieldType.email, label: lang_key.email.tr),
  ];

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
  int allMethodsPage = 0;
  int allMethodsLimit = 10;

  /// Active Tabs pagination variables
  int activeMethodsPage = 0;
  int activeMethodsLimit = 10;

  /// In-Active Tabs pagination variables
  int inActiveMethodsPage = 0;
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
    fetchAllMethods();
    tabController = TabController(length: tabsNames.length, vsync: this);
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

    final fetchAllMethods = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$allMethodsLimit&page=$allMethodsPage");
    final fetchActiveMethods = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$activeMethodsLimit&page=$activeMethodsPage&status=1");
    final fetchInActiveMethods = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$inActiveMethodsLimit&page=$inActiveMethodsPage&status=0");

    final response = await Future.wait([fetchAllMethods, fetchActiveMethods, fetchInActiveMethods]);

    if(response[0].success!) populateMethodsList(response[0].data as List, allMethodsList, visibleAllMethodsList);
    if(response[1].success!) populateMethodsList(response[1].data as List, activeMethodsList, visibleActiveMethodsList);
    if(response[2].success!) populateMethodsList(response[2].data as List, inActiveMethodsList, visibleInActiveMethodsList);

    if(!response[0].success! && !response[1].success! && !response[2].success!) {
      stopLoaderAndShowSnackBar(
          message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}",
          success: false
      );
    }

    GlobalVariables.showLoader.value = false;
  }

  /// Fetch only active methods
  void fetchActiveMethods() {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$activeMethodsLimit&page=$activeMethodsPage&status=1").then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        populateMethodsList(value.data as List, activeMethodsList, visibleActiveMethodsList);
      }
    });
  }

  /// Fetch only in-active methods
  void fetchInActiveMethods() {

    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: "${Urls.getWithdrawMethods}?limit=$inActiveMethodsLimit&page=$inActiveMethodsPage&status=0").then((value) {
      stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

      if(value.success!) {
        populateMethodsList(value.data as List, inActiveMethodsList, visibleInActiveMethodsList);
      }
    });

  }

  populateMethodsList(List<dynamic> data, List<WithdrawMethod> allList, RxList<WithdrawMethod> visibleList) {
    allList.clear();
    allList.addAll(data.map((e) => WithdrawMethod.fromJson(e)));
    addDataToVisibleMethodsList(allList, visibleList);
  }

  addDataToVisibleMethodsList(List<WithdrawMethod> allList, RxList<WithdrawMethod> visibleList) {
    visibleList.clear();
    visibleList.addAll(allList);
    visibleList.refresh();
  }
}