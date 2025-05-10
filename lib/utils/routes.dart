import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_list/customers_list_view.dart';
import 'package:service_app_admin_panel/screens/customer_management/suspended_customers_list/suspended_customers_list_view.dart';
import 'package:service_app_admin_panel/screens/dashboard/dashboard_view.dart';
import 'package:service_app_admin_panel/screens/order_management/order_management_view.dart';
import 'package:service_app_admin_panel/screens/service_management/service_list/service_list_view.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/new_requests/new_requests_view.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/suspended_servicemen_list/suspended_serviceman_list_view.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_setup_view.dart';

import '../screens/serviceman_management/active_serviceman_list/active_serviceman_list_view.dart';

class Routes {

  static const dashboard = '/dashboard';
  static const zoneSetup = '/zoneSetup';
  static const orders = '/orderManagement';
  static const customersList = '/customersList';
  static const suspendedCustomersList = '/suspendedCustomersList';
  static const newServicemanRequests = '/newServicemanRequests';
  static const activeServicemanList = '/activeServicemanList';
  static const suspendedServicemanList = '/suspendedServicemanList';
  static const servicesList = '/servicesList';

  static final pages = [

    GetPage(name: dashboard, page: () => DashboardView()),
    GetPage(name: zoneSetup, page: () => ZoneSetupView()),
    GetPage(name: orders, page: () => OrderManagementView()),
    GetPage(name: customersList, page: () => CustomersListView()),
    GetPage(name: suspendedCustomersList, page: () => SuspendedCustomersListView()),
    GetPage(name: newServicemanRequests, page: () => NewRequestsView()),
    GetPage(name: activeServicemanList, page: () => ActiveServiceManListView()),
    GetPage(name: suspendedServicemanList, page: () => SuspendedServicemanListView()),
    GetPage(name: servicesList, page: () => ServiceListView()),

  ];
}