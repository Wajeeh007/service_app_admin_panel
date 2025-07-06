import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/withdraw_request.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../helpers/scroll_controller_funcs.dart';
import '../../../helpers/show_snackbar.dart';

class WithdrawRequestsViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
    /// All Withdraws
    TextEditingController allWithdrawsSearchController = TextEditingController();

    /// Pending Orders Tab
    TextEditingController pendingWithdrawsSearchController = TextEditingController();

    /// Approved Orders Tab
    TextEditingController approvedWithdrawsSearchController = TextEditingController();

    /// Settled Orders Tab
    TextEditingController settledWithdrawSearchController = TextEditingController();

    /// Completed Orders Tab
    TextEditingController deniedWithdrawSearchController = TextEditingController();

  /// Controller(s) and Form keys End ///

  /// Lists Data
  RxList<WithdrawRequest> visibleAllRequestsList = <WithdrawRequest>[].obs;
  List<WithdrawRequest> allRequestsList = <WithdrawRequest>[];
  
  RxList<WithdrawRequest> visiblePendingRequestsList = <WithdrawRequest>[].obs;
  List<WithdrawRequest> allPendingRequestsList = <WithdrawRequest>[];
  
  RxList<WithdrawRequest> visibleApprovedRequestsList = <WithdrawRequest>[].obs;
  List<WithdrawRequest> allApprovedRequestsList = <WithdrawRequest>[];
  
  RxList<WithdrawRequest> visibleSettledRequestsList = <WithdrawRequest>[].obs;
  List<WithdrawRequest> allSettledRequestsList = <WithdrawRequest>[];
  
  RxList<WithdrawRequest> visibleDeniedRequestsList = <WithdrawRequest>[].obs;
  List<WithdrawRequest> allDeniedRequestsList = <WithdrawRequest>[];

  /// Lists Data End ///

  /// Pagination Variables ///
  RxInt allRequestsPage = 0.obs;
  int allRequestsLimit = 10;

  RxInt pendingRequestsPage = 0.obs;
  int pendingRequestsLimit = 10;

  RxInt approvedRequestsPage = 0.obs;
  int approvedRequestsLimit = 10;

  RxInt settledRequestsPage = 0.obs;
  int settledRequestsLimit = 10;

  RxInt deniedRequestsPage = 0.obs;
  int deniedRequestsLimit = 10;
  /// Pagination Variables End ///

  @override
  void onInit() {
    tabController = TabController(length: 5, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchWithdrawRequests();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    tabController.dispose();
    allWithdrawsSearchController.dispose();
    pendingWithdrawsSearchController.dispose();
    approvedWithdrawsSearchController.dispose();
    settledWithdrawSearchController.dispose();
    deniedWithdrawSearchController.dispose();
    super.onClose();
  }
  
  void fetchWithdrawRequests() async {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    final fetchAllRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$allRequestsLimit&page=${allRequestsPage.value}");
    final fetchPendingRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$pendingRequestsLimit&page=${pendingRequestsPage.value}");
    final fetchApprovedRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$approvedRequestsLimit&page=${approvedRequestsPage.value}");
    final fetchSettledRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$settledRequestsLimit&page=${settledRequestsPage.value}");
    final fetchDeniedRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$deniedRequestsLimit&page=${deniedRequestsPage.value}");

    final responses = await Future.wait([fetchAllRequests, fetchPendingRequests, fetchApprovedRequests, fetchSettledRequests, fetchDeniedRequests]);

    if(responses[0].success!) populateLists(allRequestsList, responses[0].data as List, visibleAllRequestsList);
    if(responses[1].success!) populateLists(allPendingRequestsList, responses[1].data as List, visiblePendingRequestsList);
    if(responses[2].success!) populateLists(allApprovedRequestsList, responses[2].data as List, visibleApprovedRequestsList);
    if(responses[3].success!) populateLists(allSettledRequestsList, responses[3].data as List, visibleSettledRequestsList);
    if(responses[4].success!) populateLists(allDeniedRequestsList, responses[4].data as List, visibleDeniedRequestsList);

    GlobalVariables.showLoader.value = false;

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }
  }

  /// Add data to the main list.
  void populateLists(List<WithdrawRequest> list, List<dynamic> data, RxList<WithdrawRequest> visibleList) {
    list.clear();
    list.addAll(data.map((e) => WithdrawRequest.fromJson(e)));
    addDataToVisibleList(list, visibleList);
  }

  /// Add data to the visible lists for each tab
  void addDataToVisibleList(List<WithdrawRequest> allList, RxList<WithdrawRequest> visibleList) {
    visibleList.clear();
    visibleList.addAll(allList);
    visibleList.refresh();
  }

  /// Search customers by name.
  void searchList(String? value, List<WithdrawRequest> list, RxList<WithdrawRequest> visibleList) {
    if(value == null || value.isEmpty || value == '') {
      addDataToVisibleList(list, visibleList);
    } else {
      addDataToVisibleList(
          list.where((element) => element.servicemanName!.toLowerCase().contains(value.toLowerCase())).toList(),
          visibleList
      );
    }
  }
}