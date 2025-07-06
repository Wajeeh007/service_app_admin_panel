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
  static const _serviceMenBaseUrl = '/servicemen';
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
    static const String _methodsBaseUrl = 'methods';
    static const String getWithdrawMethods = '$_withdrawsBaseUrl/$_methodsBaseUrl/get';
    static const String addWithdrawMethod = '$_withdrawsBaseUrl/$_methodsBaseUrl/add';

    static String changeWithdrawMethodStatus(String id) {
      return '$_withdrawsBaseUrl/$_methodsBaseUrl/change_status/$id';
    }

    static String deleteWithdrawMethod(String id) {
      return '$_withdrawsBaseUrl/$_methodsBaseUrl/$id';
    }

    static String editWithdrawMethod(String id) {
      return '$_withdrawsBaseUrl/$_methodsBaseUrl/$id';
    }
    /// Withdraw Methods End ///

    /// Withdraw Requests ///
    static const String _requestsBaseUrl = 'requests';
    static String getWithdrawRequests = '$_withdrawsBaseUrl/$_requestsBaseUrl/get';

    /// Withdraw Requests End ///
  /// Withdraws End ///

  /// Customer Management ///
    /// Customers List ///
    static const String getCustomers = '$_customersBaseUrl/get';
    static const String getCustomersStats = '$_customersBaseUrl/get_stats';

  /// Customer Management End ///

  /// Serviceman Management ///

    /// Serviceman List ///
    static const String getServicemen = '$_serviceMenBaseUrl/get';
    static const String getServicemenStats = '$_serviceMenBaseUrl/get_stats';
    /// Serviceman List End ///

    /// New Servicemen Requests
    static const String getNewRequests = '$_serviceMenBaseUrl/get_new_requests';

    /// New Servicemen Requests End ///

    /// Suspended Servicemen ///
    static const String getSuspendedServicemen = '$_serviceMenBaseUrl/get_suspended';
    /// Suspended Servicemen End ///

  /// Serviceman Management End ///
}