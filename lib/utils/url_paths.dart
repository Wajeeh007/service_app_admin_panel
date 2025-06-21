class Urls {

  static const testEnvironment = 'http://localhost:5000/api';
  static const prodEnvironment = '';

  static const baseURL = testEnvironment;

  static const zoneBaseUrl = '/zones';
  static const serviceBaseUrl = '/services';
  static const subServiceBaseUrl = '/sub_services';

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
}