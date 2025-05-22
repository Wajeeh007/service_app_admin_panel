class Urls {

  static const testEnvironment = 'http://localhost:5000/api';
  static const prodEnvironment = '';

  static const baseURL = testEnvironment;

  /// Zone Setup

  static String editZone(String id) {
    return '/zones/edit_zone/$id';
  }

  static String changeZoneStatus(String id) {
    return '/zones/change_status/$id';
  }

  static String deleteZone(String id) {
    return '/zones/$id';
  }

  static const String addNewZone = '/zones/add_zone';
  static const String getAllZones = '/zones/get_zones';


}