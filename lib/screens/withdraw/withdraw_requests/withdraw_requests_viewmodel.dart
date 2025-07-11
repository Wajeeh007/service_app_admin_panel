import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_app_admin_panel/helpers/pick_single_image.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/overlay_icon.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/withdraw_request.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/validators.dart';
import '../../../helpers/populate_lists.dart';
import '../../../helpers/scroll_controller_funcs.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import '../../../utils/images_paths.dart';

class WithdrawRequestsViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  TextEditingController adminNoteController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController transactionDateController = TextEditingController();
  GlobalKey<FormState> settleWithdrawFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> deniedWithdrawFormKey = GlobalKey<FormState>();

    /// All Withdraws
    TextEditingController allWithdrawsSearchController = TextEditingController();

    /// Pending Orders Tab
    TextEditingController pendingWithdrawsSearchController = TextEditingController();

    /// Approved Orders Tab
    TextEditingController approvedWithdrawsSearchController = TextEditingController();

    /// Settled Orders Tab
    TextEditingController settledWithdrawsSearchController = TextEditingController();

    /// Completed Orders Tab
    TextEditingController deniedWithdrawsSearchController = TextEditingController();

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

  /// Variable to upload Receipt image
  Rx<Uint8List> receiptImage = Uint8List(0).obs;

  /// Variable to store transfer date
  DateTime transferDate = DateTime.now();

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
    settledWithdrawsSearchController.dispose();
    deniedWithdrawsSearchController.dispose();
    super.onClose();
  }
  
  void fetchWithdrawRequests() async {

    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;

    final fetchAllRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$allRequestsLimit&page=${allRequestsPage.value}");
    final fetchPendingRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$pendingRequestsLimit&page=${pendingRequestsPage.value}&status=${WithdrawRequestStatus.pending.name}");
    final fetchApprovedRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$approvedRequestsLimit&page=${approvedRequestsPage.value}&status=${WithdrawRequestStatus.approved.name}");
    final fetchSettledRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$settledRequestsLimit&page=${settledRequestsPage.value}&status=${WithdrawRequestStatus.settled.name}");
    final fetchDeniedRequests = ApiBaseHelper.getMethod(url: "${Urls.getWithdrawRequests}?limit=$deniedRequestsLimit&page=${deniedRequestsPage.value}&status=${WithdrawRequestStatus.denied.name}");

    final responses = await Future.wait([fetchAllRequests, fetchPendingRequests, fetchApprovedRequests, fetchSettledRequests, fetchDeniedRequests]);

    if(responses[0].success!) populateLists<WithdrawRequest, dynamic>(allRequestsList, responses[0].data, visibleAllRequestsList, (dynamic json) => WithdrawRequest.fromJson(json));
    if(responses[1].success!) populateLists<WithdrawRequest, dynamic>(allPendingRequestsList, responses[1].data, visiblePendingRequestsList, (dynamic json) => WithdrawRequest.fromJson(json));
    if(responses[2].success!) populateLists<WithdrawRequest, dynamic>(allApprovedRequestsList, responses[2].data, visibleApprovedRequestsList, (dynamic json) => WithdrawRequest.fromJson(json));
    if(responses[3].success!) populateLists<WithdrawRequest, dynamic>(allSettledRequestsList, responses[3].data, visibleSettledRequestsList, (dynamic json) => WithdrawRequest.fromJson(json));
    if(responses[4].success!) populateLists<WithdrawRequest, dynamic>(allDeniedRequestsList, responses[4].data, visibleDeniedRequestsList, (dynamic json) => WithdrawRequest.fromJson(json));

    GlobalVariables.showLoader.value = false;

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }
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

  /// API call to approve withdraw request
  void approveRequest(WithdrawRequest request) async {
    final transferDate = await showDatePicker(
        context: Get.context!,
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 7))
    );

    if(transferDate != null) {
      ApiBaseHelper.patchMethod(
          url: Urls.updateWithdrawRequest(request.id!),
          body: {
            'status': WithdrawRequestStatus.approved.name,
            'transfer_date': transferDate.toIso8601String(),
          }).then((value) {

            stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

            if(value.success!) {
              final allRequestsListIndex = allRequestsList.indexWhere((element) => element.id == request.id);
              if(allRequestsListIndex != -1) {
                allRequestsList[allRequestsListIndex].status = WithdrawRequestStatus.approved;
                allRequestsList[allRequestsListIndex].transferDate = transferDate;
                addDataToVisibleList(allRequestsList, visibleAllRequestsList);
              }

              final pendingRequestsListIndex = allPendingRequestsList.indexWhere((element) => element.id == request.id);
              if(pendingRequestsListIndex != -1) {
                allPendingRequestsList.removeAt(pendingRequestsListIndex);
                addDataToVisibleList(allPendingRequestsList, visiblePendingRequestsList);
              }

              request.status = WithdrawRequestStatus.approved;
              request.transferDate = transferDate;

              allApprovedRequestsList.add(request);
              addDataToVisibleList(allApprovedRequestsList, visibleApprovedRequestsList);
            }
          });
    }
  }

  /// Show dialog to add settled request details
  Future<void> showSettleRequestDialog(WithdrawRequest request) async {
    return showDialog(
        context: Get.context!,
        barrierColor: Colors.black38,
        builder: (context) {

          transactionDateController.text = DateFormat('dd/MM/yyyy').format(transferDate);

          return AlertDialog(
            scrollable: true,
            iconColor: primaryGrey,
            iconPadding: EdgeInsets.symmetric(vertical: 8),
            icon: Icon(CupertinoIcons.exclamationmark_circle_fill, size: 80,),
            title: Text(lang_key.thisActionIsIrreversible.tr),
            backgroundColor: primaryWhite,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    lang_key.provideDetailsOfTransaction.tr
                ),
                Form(
                  key: settleWithdrawFormKey,
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        controller: transactionIdController,
                        includeAsterisk: true,
                        title: lang_key.transactionId.tr,
                        validator: (value) => Validators.validateEmptyField(value),
                      ),
                      CustomTextFormField(
                        controller: transactionDateController,
                        includeAsterisk: true,
                        title: lang_key.transferDate.tr,
                        validator: (value) => Validators.validateEmptyField(value),
                        readOnly: true,
                        suffixIcon: Icon(Icons.calendar_month, color: primaryGrey,),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(Duration(days: 14)),
                              lastDate: DateTime.now()
                          );

                          if(date != null) {
                            transactionDateController.text = DateFormat('dd/MM/yyyy').format(date);
                            transferDate = date;
                          }
                        },
                      )
                    ],
                  ),
                ),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    strokeWidth: 1.5,
                      color: primaryGrey,
                      dashPattern: [20,10],
                      radius: Radius.circular(20),
                  ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => pickSingleImage(imageToUpload: receiptImage),
                            child: Obx(() => receiptImage.value.isNotEmpty && receiptImage.value != Uint8List(0) ? Stack(
                              children: [
                                Image.memory(receiptImage.value, fit: BoxFit.fitHeight,),
                                OverlayIcon(iconData: Icons.close, top: 5, right: 5, onPressed: () => receiptImage.value = Uint8List(0),),
                              ],
                            ) : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ImagesPaths.uploadFile,
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  '${lang_key.uploadReceipt.tr}...',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: primaryGrey
                                  ),
                                )
                              ],
                            ),
                            ),
                          )
                      ),
                    )
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomMaterialButton(
                        onPressed: () => settleWithdrawRequest(request),
                        text: lang_key.cont.tr,
                      ),
                    ),
                    Expanded(
                      child: CustomMaterialButton(
                        width: 200,
                        onPressed: () {
                          receiptImage.value = Uint8List(0);
                          Get.back();
                        },
                        text: lang_key.cancel.tr,
                        borderColor: primaryGrey,
                        textColor: primaryWhite,
                        buttonColor: primaryGrey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  /// API call to settle withdraw request
  void settleWithdrawRequest(WithdrawRequest request) async {
    if(settleWithdrawFormKey.currentState!.validate()) {
      if(receiptImage.value.isNotEmpty && receiptImage.value != Uint8List(0)) {
        GlobalVariables.showLoader.value = true;

        ApiBaseHelper.patchMethodForImage(
          url: Urls.updateWithdrawRequest(request.id!), 
          files: [http.MultipartFile.fromBytes('receipt', receiptImage.value)],
          fields: {
            'status': WithdrawRequestStatus.settled.name,
            'transaction_id': transactionIdController.text,
          }).then((value) {

            if(value.success!) {
              final allRequestsListIndex = allRequestsList.indexWhere((element) => element.id == request.id);
              if(allRequestsListIndex != -1) {
                allRequestsList[allRequestsListIndex].status = WithdrawRequestStatus.approved;
                allRequestsList[allRequestsListIndex].transferDate = transferDate;
                addDataToVisibleList(allRequestsList, visibleAllRequestsList);
              }

              final approvedRequestsListIndex = allApprovedRequestsList.indexWhere((element) => element.id == request.id);
              if(approvedRequestsListIndex != -1) {
                allApprovedRequestsList.removeAt(approvedRequestsListIndex);
                addDataToVisibleList(allApprovedRequestsList, visibleApprovedRequestsList);
              }
              request.transactionId = transactionIdController.text;
              request.status = WithdrawRequestStatus.settled;
              request.receiptUrl = value.data['receipt'];
              allSettledRequestsList.add(request);
              addDataToVisibleList(allSettledRequestsList, visibleSettledRequestsList);
              transactionIdController.clear();
              receiptImage.value = Uint8List(0);
              stopLoaderAndShowSnackBar(success: value.success!, message: value.message!);
            } else {
              stopLoaderAndShowSnackBar(success: value.success!, message: value.message!);
            }
          });
        } else {
          showSnackBar(message: lang_key.addReceiptImageToProceed.tr, success: false);
        }
    }
  }

  /// Show dialog to decline a withdraw request
  Future<void> dialogToDeclineWithdrawRequest(WithdrawRequest request) async {
    return showDialog(
        context: Get.context!,
        barrierColor: Colors.black38,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            iconColor: primaryGrey,
            iconPadding: EdgeInsets.symmetric(vertical: 8),
            icon: Icon(CupertinoIcons.exclamationmark_circle_fill, size: 80,),
            title: Text(lang_key.areYouSure.tr),
            backgroundColor: primaryWhite,
            content: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    lang_key.provideReasonForDecliningRequest.tr
                ),
                Form(
                  key: deniedWithdrawFormKey,
                  child: CustomTextFormField(
                    minLines: 1,
                    maxLines: 2,
                    includeAsterisk: true,
                    title: lang_key.reason.tr,
                    controller: adminNoteController,
                    validator: (value) => Validators.validateEmptyField(value),
                  ),
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomMaterialButton(
                        onPressed: () => declineWithdrawRequest(request),
                        text: lang_key.cont.tr,
                      ),
                    ),
                    Expanded(
                      child: CustomMaterialButton(
                        onPressed: () {
                          adminNoteController.clear();
                          Get.back();
                        },
                        text: lang_key.cancel.tr,
                        borderColor: primaryGrey,
                        textColor: primaryWhite,
                        buttonColor: primaryGrey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
  
  /// API call to decline a withdraw request
  void declineWithdrawRequest(WithdrawRequest request) {
    if(deniedWithdrawFormKey.currentState!.validate()) {
      GlobalVariables.showLoader.value = true;

      ApiBaseHelper.patchMethod(
          url: Urls.updateWithdrawRequest(request.id!),
          body: {
            'status': WithdrawRequestStatus.denied.name,
            'note': adminNoteController.text,
          }).then((value) {

            if(value.success!) {
              final allRequestsListIndex = allRequestsList.indexWhere((element) => element.id == request.id);
              if(allRequestsListIndex != -1) {
                allRequestsList[allRequestsListIndex].status = WithdrawRequestStatus.denied;
                allRequestsList[allRequestsListIndex].note = adminNoteController.text;
                addDataToVisibleList(allRequestsList, visibleAllRequestsList);
              }

              final approvedRequestsListIndex = allApprovedRequestsList.indexWhere((element) => element.id == request.id);
              if(approvedRequestsListIndex != -1) {
                allApprovedRequestsList.removeAt(approvedRequestsListIndex);
                addDataToVisibleList(allApprovedRequestsList, visibleApprovedRequestsList);
              }

              request.status = WithdrawRequestStatus.denied;
              request.note = adminNoteController.text;
              allDeniedRequestsList.add(request);
              addDataToVisibleList(allDeniedRequestsList, visibleDeniedRequestsList);
              adminNoteController.clear();
              Get.back();
              stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
            } else {
              stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);
            }
          });
    }
  }

  /// Fetch only pending withdraw requests
  void fetchSingleStatusRequests(
      WithdrawRequestStatus status,
      RxInt page,
      int limit,
      List<WithdrawRequest> allRequestsList,
      RxList<WithdrawRequest> visibleRequestsList
      ) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(
        url: "${Urls.getWithdrawRequests}?limit=$limit&page=${page.value}&status=${status.name}"
    ).then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        populateLists<WithdrawRequest, dynamic>(allRequestsList, value.data, visibleRequestsList, (dynamic json) => WithdrawRequest.fromJson(json));
      }
    });
  }
}