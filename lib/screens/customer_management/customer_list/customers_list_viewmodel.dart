import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/analytical_data.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../helpers/populate_lists.dart';
import '../../../helpers/scroll_controller_funcs.dart';
import '../../../helpers/stop_loader_and_show_snackbar.dart';
import '../../../models/customer.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import '../../../utils/custom_widgets/custom_text_form_field.dart';

class CustomerListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) and Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  TextEditingController suspensionNoteController = TextEditingController();
  GlobalKey<FormState> suspensionNoteFormKey = GlobalKey<FormState>();
  
    /// All Customers List
    TextEditingController allCustomersSearchController = TextEditingController();
    
    /// Active Customers List
    TextEditingController activeCustomersSearchController = TextEditingController();

    /// InActive Customers List
    TextEditingController inActiveCustomersSearchController = TextEditingController();
    
  /// All Customers data list
  List<Customer> allCustomersList = <Customer>[];
  RxList<Customer> visibleAllCustomersList = <Customer>[].obs;

  /// Active Customers data list
  List<Customer> allActiveCustomersList = <Customer>[];
  RxList<Customer> visibleActiveCustomersList = <Customer>[].obs;

  /// In-Active Customers data list
  List<Customer> allInActiveCustomersList = <Customer>[];
  RxList<Customer> visibleInActiveCustomersList = <Customer>[].obs;

  /// 'All' Tab pagination variables
  int allTabLimit = 10;
  RxInt allTabPage = 0.obs;
  
  /// 'Active' Tab pagination variables
  int activeTabLimit = 10;
  RxInt activeTabPage = 0.obs;

  /// 'In-Active' Tab pagination variables
  int inActiveTabLimit = 10;
  RxInt inActiveTabPage = 0.obs;

  /// Customers Analytical data variable
  Rx<AnalyticalData> customersAnalyticalData = AnalyticalData().obs;
  
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    GlobalVariables.showLoader.value = true;
    animateSidePanelScrollController(scrollController);
    fetchCustomersLists();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  
  /// Fetch customers list for each tab
  void fetchCustomersLists() async {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    // final fetchAllCustomers = ApiBaseHelper.getMethod(url: "${Urls.getCustomers}?limit=$allTabLimit&page=${allTabPage.value}");
    final fetchActiveCustomers = ApiBaseHelper.getMethod(url: "${Urls.getCustomers}?limit=$activeTabLimit&page=${activeTabPage.value}&status=${UserStatuses.active.name}");
    // final fetchInActiveCustomers = ApiBaseHelper.getMethod(url: "${Urls.getCustomers}?limit=$inActiveTabLimit&page=${inActiveTabPage.value}&status=0");
    final fetchCustomersAnalyticalData = ApiBaseHelper.getMethod(url: Urls.getCustomersStats);
    
    final responses = await Future.wait([
      // fetchAllCustomers,
      fetchActiveCustomers,
      // fetchInActiveCustomers,
      fetchCustomersAnalyticalData
    ]);
    
    // if(responses[0].success!) populateLists<Customer, dynamic>(allCustomersList, responses[0].data, visibleAllCustomersList, (dynamic json) => Customer.fromJson(json));
    if(responses[0].success!) populateLists<Customer, dynamic>(allCustomersList, responses[0].data as List, visibleAllCustomersList, (dynamic json) => Customer.fromJson(json));
    // if(responses[2].success!) populateLists<Customer, dynamic>(allInActiveCustomersList, responses[2].data as List, visibleInActiveCustomersList, (dynamic json) => Customer.fromJson(json));
    if(responses[1].success!) _populateAnalyticalData(responses[1].data);

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }

    GlobalVariables.showLoader.value = false;
  }

  /// Add data to the analytical data map variable.
  void _populateAnalyticalData(Map<String, dynamic> data) {
    customersAnalyticalData.value = AnalyticalData.fromJson(data);
  }

  /// Search customers by name.
  void searchList(String? value, List<Customer> list, RxList<Customer> visibleList) {
    if(value == null || value.isEmpty || value == '') {
      addDataToVisibleList(list, visibleList);
    } else {
      addDataToVisibleList(
          list.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList(),
          visibleList
      );
    }
  }

  /// Suspension note for customer dialog
  Future<void> showSuspensionNoteDialog(int index) {
    Get.back();
    return showDialog(
        context: Get.context!,
        barrierColor: Colors.black38,
        builder: (context) {
          return AlertDialog(
            backgroundColor: primaryWhite,
            content: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang_key.enterReasonForSuspension.tr,
                ),
                Form(
                  key: suspensionNoteFormKey,
                  child: CustomTextFormField(
                    controller: suspensionNoteController,
                    title: lang_key.reason.tr,
                    includeAsterisk: true,
                    maxLines: 2,
                    minLines: 1,
                  ),
                )
              ],
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              CustomMaterialButton(
                width: 200,
                onPressed: () => _suspendCustomer(index),
                text: lang_key.yes.tr,
              ),
              CustomMaterialButton(
                width: 200,
                onPressed: () => Get.back(),
                text: lang_key.cancel.tr,
                borderColor: primaryGrey,
                textColor: primaryWhite,
                buttonColor: primaryGrey,
              ),
            ],
          );
        });
  }

  /// API call for suspending the customer
  void _suspendCustomer(int index) {
    if(suspensionNoteFormKey.currentState!.validate()) {
      GlobalVariables.showLoader.value = true;

      ApiBaseHelper.patchMethod(
          url: Urls.changeCustomerStatus(visibleAllCustomersList[index].id!),
          body: {
            'status': UserStatuses.suspended.name,
            'suspension_note': suspensionNoteController.text
          }
      ).then((value) {
        GlobalVariables.showLoader.value = false;

        if(value.success!) {
          allCustomersList.removeAt(allCustomersList.indexWhere((element) => element.id == visibleAllCustomersList[index].id));
          visibleAllCustomersList.removeAt(index);
          customersAnalyticalData.value..active = customersAnalyticalData.value.active! - 1
            ..inActive = customersAnalyticalData.value.inActive! + 1;

          customersAnalyticalData.value = AnalyticalData.fromJson(customersAnalyticalData.value.toJson());
          suspensionNoteController.clear();
          Get.back();
          showSnackBar(message: value.message!, success: true);
        } else {
          showSnackBar(message: value.message!, success: false);
        }
      });
    }

  }
}