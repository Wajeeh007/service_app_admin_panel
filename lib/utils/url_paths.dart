class Urls {

  static const testEnvironment = 'http://localhost:5000/api';
  static const prodEnvironment = '';

  static const baseURL = testEnvironment;

  static const _zoneBaseUrl = '/zones';
  static const _serviceBaseUrl = '/services';
  static const _subServiceBaseUrl = '/sub_services';
  static const _itemsBaseUrl = '/service_items';
  static const _withdrawsBaseUrl = '/withdraw';
  static const _customersBaseUrl = '/customers';
  static const _servicemenBaseUrl = '/servicemen';
  static const _ordersBaseUrl = '/orders';
  static const _transactionsBaseUrl = '/transactions';
  static const _reviewsBaseUrl = '/reviews';
  static const _dashboardBaseUrl = '/dashboard';
  /// Zone Setup

  static String editZone(String id) {
    return '$_zoneBaseUrl/$id';
  }

  static String changeZoneStatus(String id) {
    return '$_zoneBaseUrl/change_status/$id';
  }

  static String deleteZone(String id) {
    return '$_zoneBaseUrl/$id';
  }

  static const String addNewZone = '$_zoneBaseUrl/add';
  static const String getAllZones = '$_zoneBaseUrl/get';

  /// Service Management
    /// Services
    static const String addNewService = '$_serviceBaseUrl/add';
    static const String getServices = '$_serviceBaseUrl/get';

    static String changeServiceStatus(String id) {
      return '$_serviceBaseUrl/change_status/$id';
    }

    static String deleteService(String id) {
      return '$_serviceBaseUrl/$id';
    }

    static String editService(String id) {
      return '$_serviceBaseUrl/$id';
    }
    /// Services End ///

    /// Sub-Services ///
    static const String getSubServices = '$_subServiceBaseUrl/get';
    static const String addNewSubService = '$_subServiceBaseUrl/add';

    static String changeSubServiceStatus(String id) {
      return '$_subServiceBaseUrl/change_status/$id';
    }

    static String deleteSubService(String id) {
      return '$_subServiceBaseUrl/$id';
    }

    static String editSubService(String id) {
      return '$_subServiceBaseUrl/$id';
    }

    /// Sub-Services End ///

    /// Items ///
    static const String getItems = '$_itemsBaseUrl/get';
    static const String addItem = '$_itemsBaseUrl/add';

    static String changeItemStatus(String id) {
      return '$_itemsBaseUrl/change_status/$id';
    }

    static String deleteItem(String id) {
      return '$_itemsBaseUrl/$id';
    }

    static String editItem(String id) {
      return '$_itemsBaseUrl/$id';
    }

    /// Items End ///

  /// Withdraws ///
    /// Withdraw Methods ///
    static const String _methodsBaseUrl = '/methods';
    static const String getWithdrawMethods = '$_withdrawsBaseUrl$_methodsBaseUrl/get';
    static const String addWithdrawMethod = '$_withdrawsBaseUrl$_methodsBaseUrl/add';

    static String changeWithdrawMethodStatus(String id) {
      return '$_withdrawsBaseUrl$_methodsBaseUrl/change_status/$id';
    }

    static String deleteWithdrawMethod(String id) {
      return '$_withdrawsBaseUrl$_methodsBaseUrl/$id';
    }

    static String editWithdrawMethod(String id) {
      return '$_withdrawsBaseUrl$_methodsBaseUrl/$id';
    }
    /// Withdraw Methods End ///

    /// Withdraw Requests ///
    static const String _requestsBaseUrl = 'requests';
    static String getWithdrawRequests = '$_withdrawsBaseUrl/$_requestsBaseUrl/get';

    static String updateWithdrawRequest(String id) {
      return '$_withdrawsBaseUrl/$_requestsBaseUrl/$id';
    }

    /// Withdraw Requests End ///
  /// Withdraws End ///

  /// Customer Management ///
    /// Customers List ///
    static const String getCustomers = '$_customersBaseUrl/get';
    static const String getCustomersStats = '$_customersBaseUrl/stats';

    static String changeCustomerStatus(String id) {
      return '$_customersBaseUrl/change_status/$id';
    }

    static String getCustomer(String id) {
      return '$_customersBaseUrl/$id';
    }

    static String getCustomerActivityStats(String id) {
      return '$_customersBaseUrl/activity/$id';
    }

  /// Customer Management End ///

  /// Serviceman Management ///
    static const String getServicemen = '$_servicemenBaseUrl/get';

    /// Serviceman List ///

      static const String getServicemenStats = '$_servicemenBaseUrl/stats';

      static String changeServicemanStatus(String id) {
        return '$_servicemenBaseUrl/change_status/$id';
      }
    /// Serviceman List End ///

    /// New Servicemen Requests
      static const String getNewRequests = '$_servicemenBaseUrl/new_requests';

    /// New Servicemen Requests End ///

    /// Suspended Servicemen ///
      static const String getSuspendedServicemen = '$_servicemenBaseUrl/get_suspended';
    /// Suspended Servicemen End ///

    /// Serviceman Details ///
      static String getServiceman(String id) {
        return '$_servicemenBaseUrl/$id';
      }
    
      static String getServicemanOrders(String id) {
        return '$_ordersBaseUrl/$id';
      }
    
      static String getServicemanActivityStats(String id) {
        return '$_servicemenBaseUrl/activity/$id';
      }

      static String getServicemanServices(String id) {
        return '$_servicemenBaseUrl/services/$id';
      }
    /// Serviceman Details End ///
  
  /// Serviceman Management End ///

  /// Orders Management ///
    /// Orders List ///
    static const String getOrders = '$_ordersBaseUrl/get';
    static const String getOrdersStats = '$_ordersBaseUrl/stats';
    /// Orders List End ///

    /// Order Details ///
    static String getOrder(String id) {
      return '$_ordersBaseUrl/$id';
    }
    /// Order Details End ///

    static String getUserOrders(String id) {
      return '$_ordersBaseUrl/user/$id';
    }
  /// Orders Management End ///

  /// Transactions ///
  static String getCustomerTransactions(String id) {
    return '$_transactionsBaseUrl/customer/$id';
  }
  /// Transactions End ///

  /// Reviews ///
  static String getCustomerReviewsByServicemen(String id) {
    return '$_reviewsBaseUrl/review_to/customer/$id';
  }

  static String getCustomerReviewsToServicemen(String id) {
    return '$_reviewsBaseUrl/review_by/customer/$id';
  }

  static String getCustomerRatingStats(String id) {
    return '$_reviewsBaseUrl/customer/rating_stats/$id';
  }

  static String getServicemanReviewsByCustomer(String id) {
    return '$_reviewsBaseUrl/review_to/serviceman/$id';
  }

  static String getServicemanReviewsToCustomer(String id) {
    return '$_reviewsBaseUrl/review_by/serviceman/$id';
  }

  static String getServicemanRatingStats(String id) {
    return '$_reviewsBaseUrl/serviceman/rating_stats/$id';
  }
  /// Reviews End ///

  /// Dashboard ///
  static String getZoneWiseOrderVolume(String timePeriod) {
      return '$_dashboardBaseUrl/zone_stats?time_period=$timePeriod';
  }

  static const String getUserStatsForDashboard = '$_dashboardBaseUrl/user_stats';
  /// Dashboard End ///
}