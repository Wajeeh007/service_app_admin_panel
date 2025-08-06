import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/populate_lists.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/customer.dart';
import 'package:service_app_admin_panel/models/order.dart';
import 'package:service_app_admin_panel/models/review.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_details/review_stats_model.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../languages/translation_keys.dart' as lang_key;
import '../../../models/transaction.dart';
import '../../../utils/routes.dart';

class CustomerDetailsViewModel extends GetxController with SingleGetTickerProviderMixin {

  /// Controller(s) & Form keys ///
  ScrollController scrollController = ScrollController();
  late TabController mainTabController;
  late TabController reviewsTabController;

  TextEditingController ordersSearchController = TextEditingController();
  /// Controller(s) & Form Keys End ///
  
  /// Customer Object
  Rx<Customer> customerDetails = Customer().obs;

  /// Customer Orders lists
  List<Order> allCustomerOrders = <Order>[];
  RxList<Order> visibleCustomerOrders = <Order>[].obs;

  /// Reviews Lists
  RxList<Review> reviewsByServiceman = <Review>[].obs;
  RxList<Review> reviewsToServiceman = <Review>[].obs;

  /// Transactions List
  RxList<Transaction> transactions = <Transaction>[].obs;

  /// Reviews tab view section height
  RxDouble reviewsVisibilityHeight = 0.0.obs;

  /// Customer activity stats data
  RxMap<String, dynamic> activityStats = <String, dynamic>{}.obs;

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
  int reviewsByServicemenLimit = 10;
  int reviewsToServicemenLimit = 10;
  int ordersLimit = 10;
  int transactionsLimit = 10;
  RxInt reviewsByServicemanPage = 0.obs;
  RxInt reviewsToServicemanPage = 0.obs;
  RxInt transactionsPage = 0.obs;
  RxInt ordersPage = 0.obs;

  @override
  void onInit() {
    mainTabController = TabController(length: 4, vsync: this);
    reviewsTabController = TabController(length: 2, vsync: this);
    reviewsVisibilityHeight.value = 270 + (reviewsByServiceman.length * 40);
    GlobalVariables.listHeight.value = 200;
    // tabController.addListener(() {})
    super.onInit();
  }

  @override
  void onReady() {
    Map<String, dynamic>? args = Get.arguments;
    if(args == null || args.isEmpty) {
      Get.offAllNamed(Routes.customersList);
    } else {
      GlobalVariables.showLoader.value = true;
      customerDetails.value = args['customerDetails'];
      _fetchCustomerData();
      animateSidePanelScrollController(scrollController, routeName: Routes.customersList);
    }
    super.onReady();
  }

  void _fetchCustomerData() async {
    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;
    final getCustomerDetails = ApiBaseHelper.getMethod(url: Urls.getCustomer(customerDetails.value.id!));
    final getCustomerActivity = ApiBaseHelper.getMethod(url: Urls.getCustomerActivityStats(customerDetails.value.id!));
    final getCustomerOrders = ApiBaseHelper.getMethod(url: "${Urls.getCustomerOrders(customerDetails.value.id!)}?limit=$ordersLimit&page=${ordersPage.value}");
    // final getCustomerTransactions = ApiBaseHelper.getMethod(url: "${Urls.getCustomerTransactions(customerDetails.value.id!)}?limit=$transactionsLimit&page=${transactionsPage.value}");
    final getCustomerReviewsByServicemen = ApiBaseHelper.getMethod(url: "${Urls.getCustomerReviewsByServicemen(customerDetails.value.id!)}?limit=$reviewsByServicemenLimit&page=${reviewsByServicemanPage.value}");
    final getCustomerReviewsToServicemen = ApiBaseHelper.getMethod(url: "${Urls.getCustomerReviewsToServicemen(customerDetails.value.id!)}?limit=$reviewsToServicemenLimit&page=${reviewsToServicemanPage.value}");
    final getCustomerRatingStats = ApiBaseHelper.getMethod(url: Urls.getCustomerRatingStats(customerDetails.value.id!));
    
    final responses = await Future.wait([
      getCustomerDetails,
      getCustomerActivity,
      getCustomerOrders,
      // getCustomerTransactions,
      getCustomerReviewsByServicemen,
      getCustomerReviewsToServicemen,
      getCustomerRatingStats,
    ]);

    if(responses[0].success! && responses[0].data != null) customerDetails.value = Customer.fromJson(responses[0].data!);
    if(responses[1].success! && responses[1].data != null) activityStats.value = responses[1].data!;
    if(responses[2].success! && responses[2].data != null) populateLists(allCustomerOrders, responses[2].data, visibleCustomerOrders, (dynamic json) => Order.fromJson(json));
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
      reviewsToServiceman.addAllIf(data.isNotEmpty, data.map((e) => Review.fromJson(e)));
    }

    if(responses[5].success! && responses[5].data != null) reviewStats.value = ReviewStats.fromJson(responses[5].data!);

    if(responses.isEmpty || responses.every((element) => !element.success!)) {
      showSnackBar(message: "${lang_key.generalApiError.tr}. ${lang_key.retry.tr}", success: false);
    }

    GlobalVariables.showLoader.value = false;
  }

  /// API to fetch customer orders on pressing the refresh button on the orders list.
  void fetchCustomerOrders() {
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper.getMethod(url: Urls.getCustomerOrders(customerDetails.value.id!)).then((value) {
      GlobalVariables.showLoader.value = false;
      if(value.success!) populateLists(allCustomerOrders, value.data, visibleCustomerOrders, (dynamic json) => Order.fromJson(json));
    });
  }

  /// API to fetch customer transactions on pressing the refresh button on the transactions list.
  void fetchCustomerTransactions() {

    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(url: Urls.getCustomerTransactions(customerDetails.value.id!)).then((value) {
      if(value.success!) {
        GlobalVariables.showLoader.value = false;
        transactions.clear();
        final data = value.data as List;
        transactions.addAll(data.map((e) => Transaction.fromJson(e)));
        transactions.refresh();
      }
    });
  }

  /// API to fetch reviews related to customer
  void fetchReviews(bool reviewsByCustomer) {
    GlobalVariables.showLoader.value = true;

    ApiBaseHelper.getMethod(
        url: reviewsByCustomer ?
        "${Urls.getCustomerReviewsToServicemen(customerDetails.value.id!)}?limit=$reviewsToServicemenLimit&page=${reviewsToServicemanPage.value}"
            : "${Urls.getCustomerReviewsByServicemen(customerDetails.value.id!)}?limit=$reviewsByServicemenLimit&page=${reviewsByServicemanPage.value}"
    ).then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        if(reviewsByCustomer) {
          reviewsToServiceman.clear();
          final data = value.data as List;
          reviewsToServiceman.addAll(data.map((e) => Review.fromJson(e)));
          reviewsToServiceman.refresh();
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
}