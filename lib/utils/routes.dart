import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/dashboard/dashboard_view.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_setup_view.dart';

class Routes {

  static const dashboard = '/dashboard';
  static const zoneSetup = '/zoneSetup';

  static final pages = [

    GetPage(name: dashboard, page: () => DashboardView()),
    GetPage(name: zoneSetup, page: () => ZoneSetupView())

  ];
}