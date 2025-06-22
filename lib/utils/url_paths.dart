class Urls {

  static const testEnvironment = 'http://localhost:5000/api';
  static const prodEnvironment = '';

  static const baseURL = testEnvironment;

  static const zoneBaseUrl = '/zones';
  static const serviceBaseUrl = '/services';
  static const subServiceBaseUrl = '/sub_services';
  static const itemsBaseUrl = '/service_items';

  /// Zone Setup

  static String editZone(String id) {
    return '$zoneBaseUrl/$id';
  }

  static String changeZoneStatus(String id) {
    return '$zoneBaseUrl/change_status/$id';
  }

  static String deleteZone(String id) {
    return '$zoneBaseUrl/$id';
  }

  static const String addNewZone = '$zoneBaseUrl/add';
  static const String getAllZones = '$zoneBaseUrl/get';

  /// Service Management
    /// Services
    static const String addNewService = '$serviceBaseUrl/add';
    static const String getServices = '$serviceBaseUrl/get';

    static String changeServiceStatus(String id) {
      return '$serviceBaseUrl/change_status/$id';
    }

    static String deleteService(String id) {
      return '$serviceBaseUrl/$id';
    }

    static String editService(String id) {
      return '$serviceBaseUrl/$id';
    }
    /// Services End ///

    /// Sub-Services ///
    static const String getSubServices = '$subServiceBaseUrl/get';
    static const String addNewSubService = '$subServiceBaseUrl/add';

    static String changeSubServiceStatus(String id) {
      return '$subServiceBaseUrl/change_status/$id';
    }

    static String deleteSubService(String id) {
      return '$subServiceBaseUrl/$id';
    }

    static String editSubService(String id) {
      return '$subServiceBaseUrl/$id';
    }

    /// Sub-Services End ///

    /// Items ///
    static const String getItems = '$itemsBaseUrl/get';
    static const String addItem = '$itemsBaseUrl/add';

    static String changeItemStatus(String id) {
      return '$itemsBaseUrl/change_status/$id';
    }

    static String deleteItem(String id) {
      return '$itemsBaseUrl/$id';
    }

    static String editItem(String id) {
      return '$itemsBaseUrl/$id';
    }
}