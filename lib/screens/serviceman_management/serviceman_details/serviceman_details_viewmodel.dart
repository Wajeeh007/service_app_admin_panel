import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/helpers/show_confirmation_dialog.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/order.dart';
import 'package:service_app_admin_panel/models/review.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_list/customers_list_viewmodel.dart';
import 'package:service_app_admin_panel/screens/customer_management/suspended_customers_list/suspended_customers_list_viewmodel.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/servicemen_list/servicemen_list_viewmodel.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/suspended_servicemen_list/suspended_serviceman_list_viewmodel.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../languages/translation_keys.dart' as lang_key;
import '../../../models/review_stats.dart';
import '../../../models/service_item.dart';
import '../../../models/transaction.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import '../../../utils/custom_widgets/custom_text_form_field.dart';
import '../../../utils/routes.dart';

class ServicemanDetailsViewModel extends GetxController with GetTickerProviderStateMixin {

  /// Controller(s) & Form keys ///
  ScrollController scrollController = ScrollController();
  late TabController mainTabController;
  late TabController reviewsTabController;

  TextEditingController ordersSearchController = TextEditingController();
  TextEditingController _suspensionNoteController = TextEditingController();

  GlobalKey<FormState> _suspensionNoteFormKey = GlobalKey<FormState>();
  /// Controller(s) & Form Keys End ///
  
  /// Customer Object
  Rx<Serviceman> servicemanDetails = Serviceman().obs;

  /// Customer Orders lists
  List<Order> allServicemanOrders = <Order>[];
  RxList<Order> visibleServicemanOrders = <Order>[].obs;

  /// Reviews Lists
  RxList<Review> reviewsByServiceman = <Review>[].obs;
  RxList<Review> reviewsToCustomer = <Review>[].obs;

  /// Transactions List
  RxList<Transaction> transactions = <Transaction>[].obs;

  /// Reviews tab view section height
  RxDouble reviewsVisibilityHeight = 0.0.obs;

  /// Customer activity stats data
  RxMap<String, dynamic> activityStats = <String, dynamic>{}.obs;

  /// Serviceman Services
  RxList<ServiceItem> servicemanServices = <ServiceItem>[].obs;

  List<String> ratingPercentageBarTexts = [
    'Excellent',
    'Good',
    'Average',
    'Below Average',
    'Poor'
  ];

  /// Map variable for storing review stats
  Rx<ReviewStats> reviewStats = ReviewStats().obs;
  
  /// Pagination variables for reviews
  int reviewsByCustomerLimit = 10;
  int reviewsToCustomerLimit = 10;
  int ordersLimit = 10;
  int transactionsLimit = 10;
  int servicesLimit = 10;
  RxInt reviewsByCustomerPage = 0.obs;
  RxInt reviewsToCustomerPage = 0.obs;
  RxInt transactionsPage = 0.obs;
  RxInt ordersPage = 0.obs;
  RxInt servicesPage = 0.obs;

  /// String for storing the previous screen name, for correct selection of sidepanel item
  RxString sidePanelItem = ''.obs;
  String sidePanelRouteName = '';

  @override
  void onInit() {
    mainTabController = TabController(length: 5, vsync: this);
    reviewsTabController = TabController(length: 2, vsync: this);
    reviewsVisibilityHeight.value = 270 + (reviewsByServiceman.length * 40);
    GlobalVariables.listHeight.value = 200;
    super.onInit();
  }

  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;
    if(args == null || args.isEmpty) {
      Get.offAllNamed(Routes.servicemenList);
    } else {
      GlobalVariables.showLoader.value = true;
      servicemanDetails.value = args['servicemanDetails'];
      sidePanelItem.value = args['sidePanelItem'];
      sidePanelRouteName = args['sidePanelRouteName'];
      _fetchServicemanData();
      animateSidePanelScrollController(scrollController, routeName: sidePanelRouteName);
    }
    super.onReady();
  }

  /// Main API function to fetch all the data at once.
  void _fetchServicemanData() async {
    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;
    final getServicemanDetails = ApiBaseHelper.getMethod(url: Urls.getServiceman(servicemanDetails.value.id!));
    final getServicemanActivity = ApiBaseHelper.getMethod(url: Urls.getServicemanActivityStats(servicemanDetails.value.id!));
    final getServicemanOrders = ApiBaseHelper.getMethod(url: "${Urls.getUserOrders(servicemanDetails.value.id!)}?limit=$ordersLimit&page=${ordersPage.value}");
    // final getCustomerTransactions = ApiBaseHelper.getMethod(url: "${Urls.getCustomerTransactions(customerDetails.value.id!)}?limit=$transactionsLimit&page=${transactionsPage.value}");
    final getServicemanReviewsByCustomer = ApiBaseHelper.getMethod(url: "${Urls.getServicemanReviewsByCustomer(servicemanDetails.value.id!)}?limit=$reviewsByCustomerLimit&page=${reviewsByCustomerPage.value}");
    final getServicemanReviewsToCustomer = ApiBaseHelper.getMethod(url: "${Urls.getServicemanReviewsToCustomer(servicemanDetails.value.id!)}?limit=$reviewsToCustomerLimit&page=${reviewsToCustomerPage.value}");
    final getServicemanRatingStats = ApiBaseHelper.getMethod(url: Urls.getServicemanRatingStats(servicemanDetails.value.id!));
    // final getServicemanServices = ApiBaseHelper.getMethod(url: "${Urls.getServicemanServices(servicemanDetails.value.id!)}?limit=$servicesLimit&page=${servicesPage.value}");

    final responses = await Future.wait([
      getServicemanDetails,
      getServicemanActivity,
      getServicemanOrders,
      // getCustomerTransactions,
      getServicemanReviewsByCustomer,
      getServicemanReviewsToCustomer,
      getServicemanRatingStats,
    ]);

    if(responses[0].success! && responses[0].data != null) {
      servicemanDetails.value = Serviceman.fromJson(responses[0].data!);
      servicemanServices.clear();
      servicemanServices.addAll(servicemanDetails.value.services ?? []);
    }
    if(responses[1].success! && responses[1].data != null) activityStats.value = responses[1].data!;
    if(responses[2].success! && responses[2].data != null) populateLists(allServicemanOrders, responses[2].data, visibleServicemanOrders, (dynamic json) => Order.fromJson(json));
    // if(responses[3].success! && responses[3].data != null) {
    //   final data = responses[3].data as List;
    //   transactions.addAllIf(data.isNotEmpty, data.map((e)=> Transaction.fromJson(e)));
    //   transactions.refresh();
    // }
    if(responses[3].success! && responses[3].data != null) {
      final data = responses[3].data as List;
      reviewsByServiceman.addAllIf(data.isNotEmpty, data.map((e) => Review.fromJson(e)));
    }

    if(responses[4].success! && responses[4].data != null) {
      final data = responses[4].data as List;
      reviewsToCustomer.addAllIf(data.isNotEmpty, data.map((e) => Review.fromJson(e)));
    }

    if(responses[5].success! && responses[5].data != null) reviewStats.value = ReviewStats.fromJson(responses[5].data!);

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }

    GlobalVariables.showLoader.value = false;
  }

  /// API to fetch serviceman orders on pressing the refresh button on the orders list.
  void fetchServicemanOrders() {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.getMethod(url: Urls.getUserOrders(servicemanDetails.value.id!)).then((value) {
      GlobalVariables.showLoader.value = false;
      if(value.success!) populateLists(allServicemanOrders, value.data, visibleServicemanOrders, (dynamic json) => Order.fromJson(json));
    });
  }

  /// Fetch serviceman details including services offered
  void fetchServiceman() {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.getMethod(url: Urls.getServiceman(servicemanDetails.value.id!)).then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        servicemanDetails.value = Serviceman.fromJson(value.data);
        servicemanServices.clear();
        servicemanServices.addAll(servicemanDetails.value.services ?? []);
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }
    });
  }
  /// API to fetch serviceman transactions on pressing the refresh button on the transactions list.
  void fetchServicemanTransactions() {

    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: Urls.getCustomerTransactions(servicemanDetails.value.id!)).then((value) {
      if(value.success!) {
        GlobalVariables.showLoader.value = false;
        transactions.clear();
        final data = value.data as List;
        transactions.addAll(data.map((e) => Transaction.fromJson(e)));
        transactions.refresh();
      }
    });
  }

  /// API to fetch reviews related to serviceman
  void fetchReviews(bool reviewsByCustomer) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(
        url: reviewsByCustomer ?
        "${Urls.getServicemanReviewsByCustomer(servicemanDetails.value.id!)}?limit=$reviewsToCustomerLimit&page=${reviewsToCustomerPage.value}"
            : "${Urls.getServicemanReviewsToCustomer(servicemanDetails.value.id!)}?limit=$reviewsByCustomerLimit&page=${reviewsByCustomerPage.value}"
    ).then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        if(reviewsByCustomer) {
          reviewsToCustomer.clear();
          final data = value.data as List;
          reviewsToCustomer.addAll(data.map((e) => Review.fromJson(e)));
          reviewsToCustomer.refresh();
        } else {
          reviewsByServiceman.clear();
          final data = value.data as List;
          reviewsByServiceman.addAll(data.map((e) => Review.fromJson(e)));
          reviewsByServiceman.refresh();
        }
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }
    });
  }

  /// Function to either show the dialog for declining or suspending the serviceman or call the API to update the status of the serviceman.
  void updateUserStatus(UserStatuses newStatus) {
    showConfirmationDialog(
      message: newStatus == UserStatuses.declined ? lang_key.declineServicemanRequestDialogText.tr : newStatus == UserStatuses.suspended ? lang_key.suspendServicemanAccountDialogText.tr : lang_key.activateServicemanAccountDialogText.tr,
        onPressed: newStatus == UserStatuses.active ? () => _changeServicemanStatus(newStatus) : () {
          if(newStatus == UserStatuses.suspended || newStatus == UserStatuses.declined) Get.back();
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
                        key: _suspensionNoteFormKey,
                        child: CustomTextFormField(
                          controller: _suspensionNoteController,
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
                      onPressed: () => _changeServicemanStatus(newStatus),
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
    );
  }

  /// API call to update customer's status
  void _changeServicemanStatus(UserStatuses newStatus) {

    late ServicemenListViewModel servicemanListViewModel;
    late SuspendedServicemanListViewModel suspendedServicemanListViewModel;

    if(newStatus == UserStatuses.declined || newStatus == UserStatuses.suspended) {
      if(_suspensionNoteFormKey.currentState!.validate()) {
          GlobalVariables.showLoader.value = true;

          ApiBaseHelper.patchMethod(
              url: Urls.changeCustomerStatus(servicemanDetails.value.id!),
              body: {
                'status': newStatus.name,
                'suspension_note': _suspensionNoteController.text
              }
          ).then((value) {
            GlobalVariables.showLoader.value = false;

            if(value.success!) {
              servicemanDetails.value.status = newStatus;
              servicemanDetails.refresh();
              Get.back();
              showSnackBar(message: value.message!, success: true);
            } else {
              showSnackBar(message: value.message!, success: false);
            }

            if(Get.isRegistered<CustomerListViewModel>() && newStatus == UserStatuses.suspended){
              servicemanListViewModel = Get.find<ServicemenListViewModel>();
              final servicemenListIndex = servicemanListViewModel.allServicemenList.indexWhere((element) => element.id == servicemanDetails.value.id);
              if(servicemenListIndex != -1) {
                servicemanListViewModel.allServicemenList.removeAt(servicemenListIndex);
                servicemanListViewModel.visibleAllServicemenList.clear();
                servicemanListViewModel.visibleAllServicemenList.addAll(servicemanListViewModel.allServicemenList);
                servicemanListViewModel.visibleAllServicemenList.refresh();
                servicemanListViewModel.servicemenAnalyticalData.value..inActive = servicemanListViewModel.servicemenAnalyticalData.value.inActive! + 1
                  ..active = servicemanListViewModel.servicemenAnalyticalData.value.active! - 1;
              }
            }

            if(Get.isRegistered<SuspendedCustomersListViewModel>() && newStatus == UserStatuses.suspended) {
              suspendedServicemanListViewModel = Get.find<SuspendedServicemanListViewModel>();
              final servicemenListIndex = suspendedServicemanListViewModel.suspendedServicemen.indexWhere((element) => element.id == servicemanDetails.value.id);
              if(servicemenListIndex != -1) {
                suspendedServicemanListViewModel.suspendedServicemen.add(servicemanDetails.value);
                suspendedServicemanListViewModel.suspendedServicemen.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
                suspendedServicemanListViewModel.suspendedServicemen.refresh();
              }
            }
          });
        }
      } else {
        GlobalVariables.showLoader.value = true;

        ApiBaseHelper.patchMethod(
            url: Urls.changeCustomerStatus(servicemanDetails.value.id!),
            body: {'status': UserStatuses.active.name,}
        ).then((value) {
          GlobalVariables.showLoader.value = false;

          if(Get.isRegistered<CustomerListViewModel>()) {
            servicemanListViewModel = Get.find<ServicemenListViewModel>();
            final customerListIndex = servicemanListViewModel.allServicemenList.indexWhere((element) => element.id == servicemanDetails.value.id);
            if(customerListIndex != -1) {
              servicemanListViewModel.allServicemenList.add(servicemanDetails.value);
              servicemanListViewModel.allServicemenList.sort((a,b) => a.createdAt!.compareTo(b.createdAt!));
              servicemanListViewModel.visibleAllServicemenList.clear();
              servicemanListViewModel.visibleAllServicemenList.addAll(servicemanListViewModel.allServicemenList);
              servicemanListViewModel.refresh();
              servicemanListViewModel.servicemenAnalyticalData.value..active = servicemanListViewModel.servicemenAnalyticalData.value.active! + 1
                ..inActive = servicemanListViewModel.servicemenAnalyticalData.value.inActive! - 1;
            }
          }

          if(Get.isRegistered<SuspendedCustomersListViewModel>() && servicemanDetails.value.status == UserStatuses.suspended) {
            suspendedServicemanListViewModel = Get.find<SuspendedServicemanListViewModel>();
            final servicemenListIndex = suspendedServicemanListViewModel.suspendedServicemen.indexWhere((element) => element.id == servicemanDetails.value.id);
            if(servicemenListIndex != -1) {
              suspendedServicemanListViewModel.suspendedServicemen.removeAt(servicemenListIndex);
              suspendedServicemanListViewModel.suspendedServicemen.refresh();
            }
          }
          if(value.success!) {
            servicemanDetails.value.status = UserStatuses.active;
            servicemanDetails.refresh();
            Get.back();
            showSnackBar(message: value.message!, success: true);
          } else {
            showSnackBar(message: value.message!, success: false);
          }
        });
    }
  }
}