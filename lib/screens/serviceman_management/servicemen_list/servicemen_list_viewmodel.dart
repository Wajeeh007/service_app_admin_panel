import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/analytical_data.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';

import '../../../helpers/populate_lists.dart';
import '../../../helpers/scroll_controller_funcs.dart';
import '../../../helpers/stop_loader_and_show_snackbar.dart';
import '../../../models/serviceman.dart';
import '../../../utils/api_base_helper.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class ServicemenListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();

  TextEditingController suspensionNoteController = TextEditingController();
  GlobalKey<FormState> suspensionNoteFormKey = GlobalKey<FormState>();

    /// All ServiceMen List
    TextEditingController allServiceMansSearchController = TextEditingController();

    /// Active ServiceMen List
    TextEditingController activeServiceMansSearchController = TextEditingController();

    /// InActive ServiceMen List
    TextEditingController inActiveServiceMansSearchController = TextEditingController();

  /// All ServiceMen data list
  List<Serviceman> allServicemenList = <Serviceman>[];
  RxList<Serviceman> visibleAllServicemenList = <Serviceman>[].obs;

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
  Rx<AnalyticalData> servicemenAnalyticalData = AnalyticalData().obs;
  
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
    suspensionNoteController.dispose();
    super.onClose();
  }

  /// Fetch customers list for each tab
  void fetchServicemenLists() async {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    // final fetchAllServicemen = ApiBaseHelper.getMethod(url: "${Urls.getServicemen}?limit=$allTabLimit&page=${allTabPage.value}");
    final fetchActiveServicemen = ApiBaseHelper.getMethod(url: "${Urls.getServicemen}?limit=$activeTabLimit&page=${activeTabPage.value}&status=${UserStatuses.active.name}");
    // final fetchInActiveServicemen = ApiBaseHelper.getMethod(url: "${Urls.getServicemen}?limit=$inActiveTabLimit&page=${inActiveTabPage.value}&status=0");
    final fetchServicemenAnalyticalData = ApiBaseHelper.getMethod(url: Urls.getServicemenStats);

    final responses = await Future.wait([
      // fetchAllServicemen,
      fetchActiveServicemen,
      // fetchInActiveServicemen,
      fetchServicemenAnalyticalData]);

    // if(responses[0].success!) populateLists<Serviceman, dynamic>(allServiceMenList, responses[0].data, visibleAllServiceMenList, (dynamic json) => Serviceman.fromJson(json));
    if(responses[0].success!) populateLists<Serviceman, dynamic>(allServicemenList, responses[0].data, visibleAllServicemenList, (dynamic json) => Serviceman.fromJson(json));
    // if(responses[2].success!) populateLists<Serviceman, dynamic>(allInActiveServiceMenList, responses[2].data, visibleInActiveServicemenList, (dynamic json) => Serviceman.fromJson(json));
    if(responses[1].success!) populateAnalyticalData(responses[1].data);

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
    servicemenAnalyticalData.value = AnalyticalData.fromJson(data);
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

  /// Suspension note for serviceman dialog
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
                onPressed: () => _suspendServiceman(index),
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

  /// API call for suspending the serviceman
  void _suspendServiceman(int index) {
    if(suspensionNoteFormKey.currentState!.validate()) {
      GlobalVariables.showLoader.value = true;
      
      ApiBaseHelper.patchMethod(
          url: Urls.changeServicemanStatus(visibleAllServicemenList[index].id!),
          body: {
            'status': UserStatuses.suspended.name,
            'suspension_note': suspensionNoteController.text
          }
      ).then((value) {
        GlobalVariables.showLoader.value = false;

        if(value.success!) {
          allServicemenList.removeAt(allServicemenList.indexWhere((element) => element.id == visibleAllServicemenList[index].id));
          visibleAllServicemenList.removeAt(index);
          servicemenAnalyticalData.value..active = servicemenAnalyticalData.value.active! - 1
            ..inActive = servicemenAnalyticalData.value.inActive! + 1;

          servicemenAnalyticalData.value = AnalyticalData.fromJson(servicemenAnalyticalData.value.toJson());
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