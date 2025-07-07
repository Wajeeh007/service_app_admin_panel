import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_snackbar.dart';
import 'package:service_app_admin_panel/models/analytical_data.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../helpers/populate_lists.dart';
import '../../../helpers/scroll_controller_funcs.dart';
import '../../../models/customer.dart';

class CustomerListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) and Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
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

    final fetchAllCustomers = ApiBaseHelper.getMethod(url: "${Urls.getCustomers}?limit=$allTabLimit&page=${allTabPage.value}");
    final fetchActiveCustomers = ApiBaseHelper.getMethod(url: "${Urls.getCustomers}?limit=$activeTabLimit&page=${activeTabPage.value}&status=1");
    final fetchInActiveCustomers = ApiBaseHelper.getMethod(url: "${Urls.getCustomers}?limit=$inActiveTabLimit&page=${inActiveTabPage.value}&status=0");
    final fetchCustomersAnalyticalData = ApiBaseHelper.getMethod(url: Urls.getCustomersStats);
    
    final responses = await Future.wait([fetchAllCustomers, fetchActiveCustomers, fetchInActiveCustomers, fetchCustomersAnalyticalData]);
    
    if(responses[0].success!) populateLists<Customer, dynamic>(allCustomersList, responses[0].data, visibleAllCustomersList, (dynamic json) => Customer.fromJson(json));
    if(responses[1].success!) populateLists<Customer, dynamic>(allActiveCustomersList, responses[1].data as List, visibleActiveCustomersList, (dynamic json) => Customer.fromJson(json));
    if(responses[2].success!) populateLists<Customer, dynamic>(allInActiveCustomersList, responses[2].data as List, visibleInActiveCustomersList, (dynamic json) => Customer.fromJson(json));
    if(responses[3].success!) populateAnalyticalData(responses[3].data);

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }

    GlobalVariables.showLoader.value = false;
  }

  /// Add data to the analytical data map variable.
  void populateAnalyticalData(Map<String, dynamic> data) {
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
}