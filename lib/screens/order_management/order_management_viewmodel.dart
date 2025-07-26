import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/models/analytical_data.dart';
import 'package:service_app_admin_panel/models/order.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../helpers/scroll_controller_funcs.dart';
import '../../helpers/stop_loader_and_show_snackbar.dart';
import '../../utils/api_base_helper.dart';
import '../../utils/constants.dart';
import '../../utils/url_paths.dart';

class OrderManagementViewModel extends GetxController with GetSingleTickerProviderStateMixin{

  /// Controller(s) & Form keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
    /// All Orders Tab
    TextEditingController allOrderSearchController = TextEditingController();

    /// Pending Orders Tab
    TextEditingController pendingOrdersSearchController = TextEditingController();

    /// Accepted Orders Tab
    TextEditingController acceptedOrdersSearchController = TextEditingController();

    /// Ongoing Orders Tab
    TextEditingController ongoingOrdersSearchController = TextEditingController();

    /// Completed Orders Tab
    TextEditingController completedOrdersSearchController = TextEditingController();

    /// Cancelled Orders Tab
    TextEditingController cancelledOrdersSearchController = TextEditingController();

    /// Disputed Orders Tab
    TextEditingController disputedOrdersSearchController = TextEditingController();

  /// Controller(s) and Form keys End ///

  /// Lists Data
    /// All Orders Tab Lists
    List<Order> allOrdersList = <Order>[];
    RxList<Order> visibleAllOrdersList = <Order>[].obs;

    /// Pending Orders Tab Lists
    List<Order> allPendingOrdersList = <Order>[];
    RxList<Order> visiblePendingOrdersList = <Order>[].obs;

    /// Accepted Orders Tab Lists
    RxList<Order> visibleAcceptedOrdersList = <Order>[].obs;
    List<Order> allAcceptedOrdersList = <Order>[];

    /// Ongoing orders Tab Lists
    RxList<Order> visibleOngoingOrdersList = <Order>[].obs;
    List<Order> allOngoingOrdersList = <Order>[];
    
    /// Completed Orders Tab Lists
    RxList<Order> visibleCompletedOrdersList = <Order>[].obs;
    List<Order> allCompletedOrdersList = <Order>[];
    
    /// Cancelled Orders Tab Lists
    RxList<Order> visibleCancelledOrdersList = <Order>[].obs;
    List<Order> allCancelledOrdersList = <Order>[];
  
    /// Disputed Orders Tab Lists
    RxList<Order> visibleDisputedOrdersList = <Order>[].obs;
    List<Order> allDisputedOrdersList = <Order>[];

    /// Pagination Variables
    RxInt allOrdersTabPage = 0.obs;
    int allOrdersTabLimit = 10;

    RxInt pendingTabPage = 0.obs;
    int pendingTabLimit = 10;

    RxInt acceptedTabPage = 0.obs;
    int acceptedTabLimit = 10;

    RxInt ongoingTabPage = 0.obs;
    int ongoingTabLimit = 10;

    RxInt completedTabPage = 0.obs;
    int completedTabLimit = 10;

    RxInt cancelledTabPage = 0.obs;
    int cancelledTabLimit = 10;

    RxInt disputedTabPage = 0.obs;
    int disputedTabLimit = 10;

    Rx<AnalyticalData> orderStats = AnalyticalData().obs;

  @override
  void onInit() {
    tabController = TabController(length: 7, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchAllOrders();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void fetchAllOrders() async {
    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    final fetchAllOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$allOrdersTabLimit&page=${allOrdersTabPage.value}");
    final fetchPendingOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$pendingTabLimit&page=${pendingTabPage.value}&status=pending");
    final fetchAcceptedOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$acceptedTabLimit&page=${acceptedTabPage.value}&status=accepted");
    final fetchOnGoingOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$ongoingTabLimit&page=${ongoingTabPage.value}&status=ongoing");
    final fetchCompletedOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$completedTabLimit&page=${completedTabPage.value}&status=completed");
    final fetchCancelledOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$cancelledTabLimit&page=${cancelledTabPage.value}&status=cancelled");
    final fetchDisputedOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$disputedTabLimit&page=${disputedTabPage.value}&status=disputed");
    final fetchOrdersAnalytics = ApiBaseHelper.getMethod(url: Urls.getOrdersStats);

    final responses = await Future.wait([
      fetchAllOrders,
      fetchPendingOrders,
      fetchAcceptedOrders,
      fetchOnGoingOrders,
      fetchCompletedOrders,
      fetchCancelledOrders,
      fetchDisputedOrders,
      fetchOrdersAnalytics,
    ]);

    if(responses[0].success!) populateLists<Order, dynamic>(allOrdersList, responses[0].data, visibleAllOrdersList, (dynamic json) => Order.fromJson(json));
    if(responses[1].success!) populateLists<Order, dynamic>(allPendingOrdersList, responses[1].data, visiblePendingOrdersList, (dynamic json) => Order.fromJson(json));
    if(responses[2].success!) populateLists<Order, dynamic>(allAcceptedOrdersList, responses[2].data, visibleAcceptedOrdersList, (dynamic json) => Order.fromJson(json));
    if(responses[3].success!) populateLists<Order, dynamic>(allOngoingOrdersList, responses[3].data, visibleOngoingOrdersList, (dynamic json) => Order.fromJson(json));
    if(responses[4].success!) populateLists<Order, dynamic>(allCompletedOrdersList, responses[4].data, visibleCompletedOrdersList, (dynamic json) => Order.fromJson(json));
    if(responses[5].success!) populateLists<Order, dynamic>(allCancelledOrdersList, responses[5].data, visibleCancelledOrdersList, (dynamic json) => Order.fromJson(json));
    if(responses[6].success!) populateLists<Order, dynamic>(allDisputedOrdersList, responses[6].data, visibleDisputedOrdersList, (dynamic json) => Order.fromJson(json));
    if(responses[7].success!) orderStats.value = AnalyticalData.fromJson(responses[7].data);

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }

    GlobalVariables.showLoader.value = false;
  }
  
  void fetchSingleStatusOrders(OrderStatus? status, int limit, RxInt page, List<Order> allList, RxList<Order> visibleList) async {
    
    GlobalVariables.showLoader.value = true;
    
    if(status == null || status == '') {
      final fetchAllOrders = ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$limit&page=${page.value}");
      final fetchStats = ApiBaseHelper.getMethod(url: Urls.getOrdersStats);
      
      final responses = await Future.wait([fetchAllOrders, fetchStats]);

      if(responses[0].success!) populateLists<Order, dynamic>(allOrdersList, responses[0].data, visibleAllOrdersList, (dynamic json) => Order.fromJson(json));
      if(responses[1].success!) orderStats.value = AnalyticalData.fromJson(responses[1].data);

      if(responses.isEmpty || responses.every((element) => !element.success!)) {
        showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
      }
      
      GlobalVariables.showLoader.value = false;
    } else {
      ApiBaseHelper.getMethod(url: "${Urls.getOrders}?limit=$limit&page=${page.value}&status=${status.name.toLowerCase().trim()}").then((value) {
        GlobalVariables.showLoader.value = false;
        
        if(value.success!) {
          populateLists(allList, value.data, visibleList, (dynamic json) => Order.fromJson(json));
        } else {
          showSnackBar(message: value.message!, success: false);
        }
      });
    }
  }

  void searchList(String? value, List<Order> allList, RxList<Order> visibleList) {
    if(value == null || value.isEmpty || value == '') {
      addDataToVisibleList(allList, visibleList);
    } else {
      addDataToVisibleList(
          allList.where((element) => element.customerDetails!.name!.toLowerCase().contains(value.toLowerCase().trim())
              || element.serviceManDetails!.name!.toLowerCase().trim().contains(value.toLowerCase().trim())
          ).toList(), visibleList
      );
    }
  }
}