import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/customer.dart';
import 'package:service_app_admin_panel/models/order.dart';
import 'package:service_app_admin_panel/models/review.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../models/transaction.dart';
import '../../../utils/routes.dart';

class CustomerDetailsViewModel extends GetxController with SingleGetTickerProviderMixin {

  /// Controller(s) & Form keys ///
  ScrollController scrollController = ScrollController();
  late TabController mainTabController;
  late TabController reviewsTabController;

  TextEditingController ordersSearchController = TextEditingController();
  /// Controller(s) & Form Keys End ///

  /// String for customer ID ///
  String customerId = 'dc0ac075-01b6-4c56-9f1b-60559c0ed188';

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

  List<String> ratingPercentageBarTexts = [
    'Excellent',
    'Good',
    'Average',
    'Below Average',
    'Poor'
  ];

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
    // if(args == null || args.isEmpty) {
    //   Get.offAllNamed(Routes.customersList);
    // } else {
    //   GlobalVariables.showLoader.value = true;
      // customerId = args['customerId'];
      // _fetchCustomer();
      animateSidePanelScrollController(scrollController, routeName: Routes.customersList);
    // }
    _fetchCustomerDetailsAndActivity();
    super.onReady();
  }

  void _fetchCustomerDetailsAndActivity() async {
    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;
    final customerDetails = ApiBaseHelper.getMethod(url: Urls.getCustomer(customerId));
    // final customerActivity = ApiBaseHelper.getMethod(url: Urls.getCustomerActivityStats(customerId));

    final responses = Future.wait([customerDetails,
      // customerActivity
    ]);
  }

  void fetchCustomerOrders() {
    ApiBaseHelper.getMethod(url: Urls.getCustomerOrders(customerDetails.value.id!)).then((value) {
      if(value.success!) {
        allCustomerOrders.clear();
        final data = value.data as List;
        allCustomerOrders.addAllIf(data.isNotEmpty, data.map((e) => Order.fromJson(e)));
        visibleCustomerOrders.value = allCustomerOrders;
        visibleCustomerOrders.refresh();
      }
    });
  }
}