import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_list/customers_list_view.dart';
import 'package:service_app_admin_panel/screens/dashboard/dashboard_view.dart';
import 'package:service_app_admin_panel/screens/order_management/order_management_view.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_setup_view.dart';

class Routes {

  static const dashboard = '/dashboard';
  static const zoneSetup = '/zoneSetup';
  static const orders = '/orderManagement';
  static const customersList = '/customersList';

  static final pages = [

    GetPage(name: dashboard, page: () => DashboardView()),
    GetPage(name: zoneSetup, page: () => ZoneSetupView()),
    GetPage(name: orders, page: () => OrderManagementView()),
    GetPage(name: customersList, page: () => CustomersListView()),

  ];
}