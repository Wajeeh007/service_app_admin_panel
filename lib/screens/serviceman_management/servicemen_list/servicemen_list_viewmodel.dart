import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/analytical_data.dart';

import '../../../helpers/populate_lists.dart';
import '../../../helpers/scroll_controller_funcs.dart';
import '../../../helpers/stop_loader_and_show_snackbar.dart';
import '../../../models/serviceman.dart';
import '../../../utils/api_base_helper.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class ServiceMenListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();

    /// All ServiceMen List
    TextEditingController allServiceMansSearchController = TextEditingController();

    /// Active ServiceMen List
    TextEditingController activeServiceMansSearchController = TextEditingController();

    /// InActive ServiceMen List
    TextEditingController inActiveServiceMansSearchController = TextEditingController();

  /// All ServiceMen data list
  List<Serviceman> allServiceMenList = <Serviceman>[];
  RxList<Serviceman> visibleAllServiceMenList = <Serviceman>[].obs;

  /// Active servicemen list
  List<Serviceman> allActiveServiceMenList = <Serviceman>[];
  RxList<Serviceman> visibleActiveServicemenList = <Serviceman>[].obs;

  /// In-Active Servicemen list
  List<Serviceman> allInActiveServiceMenList = <Serviceman>[];
  RxList<Serviceman> visibleInActiveServicemenList = <Serviceman>[].obs;

  /// All Tab pagination variables
  RxInt allTabPage = 0.obs;
  int allTabLimit = 10;
  
  /// Active Tab pagination variables
  RxInt activeTabPage = 0.obs;
  int activeTabLimit = 10;
  
  /// All Tab pagination variables
  RxInt inActiveTabPage = 0.obs;
  int inActiveTabLimit = 10;
  
  /// Analytical data variable
  Rx<AnalyticalData> serviceMenAnalyticalData = AnalyticalData().obs;
  
  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchServicemenLists();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    allServiceMansSearchController.dispose();
    activeServiceMansSearchController.dispose();
    inActiveServiceMansSearchController.dispose();
    tabController.dispose();
    super.onClose();
  }

  /// Fetch customers list for each tab
  void fetchServicemenLists() async {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    final fetchAllServicemen = ApiBaseHelper.getMethod(url: "${Urls.getServicemen}?limit=$allTabLimit&page=${allTabPage.value}");
    final fetchActiveServicemen = ApiBaseHelper.getMethod(url: "${Urls.getServicemen}?limit=$activeTabLimit&page=${activeTabPage.value}&status=1");
    // final fetchInActiveServicemen = ApiBaseHelper.getMethod(url: "${Urls.getServicemen}?limit=$inActiveTabLimit&page=${inActiveTabPage.value}&status=0");
    final fetchServicemenAnalyticalData = ApiBaseHelper.getMethod(url: Urls.getServicemenStats);

    final responses = await Future.wait([
      fetchAllServicemen,
      fetchActiveServicemen,
      // fetchInActiveServicemen,
      fetchServicemenAnalyticalData]);

    if(responses[0].success!) populateLists<Serviceman, dynamic>(allServiceMenList, responses[0].data, visibleAllServiceMenList, (dynamic json) => Serviceman.fromJson(json));
    if(responses[1].success!) populateLists<Serviceman, dynamic>(allActiveServiceMenList, responses[1].data, visibleActiveServicemenList, (dynamic json) => Serviceman.fromJson(json));
    // if(responses[2].success!) populateLists<Serviceman, dynamic>(allInActiveServiceMenList, responses[2].data, visibleInActiveServicemenList, (dynamic json) => Serviceman.fromJson(json));
    if(responses[2].success!) populateAnalyticalData(responses[2].data);

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }

    GlobalVariables.showLoader.value = false;
  }
  
  /// Fetch servicemen based on status
  void fetchServicemenWithStatus(bool status) {
    GlobalVariables.showLoader.value = true;
    
    ApiBaseHelper.getMethod(url: "${Urls.getServicemen}?limit=$activeTabLimit&page=${activeTabPage.value}&status=${status ? 1 : 0}").then((value) {
      
      GlobalVariables.showLoader.value = false;
      
      if(value.success!) {
        populateLists(
            status ? allActiveServiceMenList : allInActiveServiceMenList,
            value.data as List,
            status ? visibleActiveServicemenList : visibleInActiveServicemenList,
            (dynamic json) => Serviceman.fromJson(json)
        );
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }
    });
  }

  /// Add data to the analytical data map variable.
  void populateAnalyticalData(Map<String, dynamic> data) {
    serviceMenAnalyticalData.value = AnalyticalData.fromJson(data);
  }

  /// Search customers by name.
  void searchList(String? value, List<Serviceman> list, RxList<Serviceman> visibleList) {
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