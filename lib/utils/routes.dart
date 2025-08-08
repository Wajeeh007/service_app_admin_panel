import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_details/customer_details_view.dart';
import 'package:service_app_admin_panel/screens/customer_management/customer_list/customers_list_view.dart';
import 'package:service_app_admin_panel/screens/customer_management/suspended_customers_list/suspended_customers_list_view.dart';
import 'package:service_app_admin_panel/screens/dashboard/dashboard_view.dart';
import 'package:service_app_admin_panel/screens/order_management/order_management_view.dart';
import 'package:service_app_admin_panel/screens/service_management/items/edit_item/edit_item_view.dart';
import 'package:service_app_admin_panel/screens/service_management/services/edit_service/edit_service_view.dart';
import 'package:service_app_admin_panel/screens/service_management/sub_services/edit_sub_service/edit_sub_service_view.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/new_requests/new_requests_view.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/serviceman_details/serviceman_details_view.dart';
import 'package:service_app_admin_panel/screens/serviceman_management/suspended_servicemen_list/suspended_serviceman_list_view.dart';
import 'package:service_app_admin_panel/screens/withdraw/edit_withdraw_method/edit_withdraw_method_view.dart';
import 'package:service_app_admin_panel/screens/withdraw/withdraw_requests/withdraw_requests_view.dart';
import 'package:service_app_admin_panel/screens/zone_setup/edit_zone/edit_zone_view.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_list_and_addition/zone_list_and_addition_view.dart';

import '../screens/service_management/items/items_list/items_list_view.dart';
import '../screens/service_management/services/service_list/service_list_view.dart';
import '../screens/service_management/sub_services/sub_service_list/sub_services_list_view.dart';
import '../screens/serviceman_management/servicemen_list/servicemen_list_view.dart';
import '../screens/settings/business_setup/business_setup_view.dart';
import '../screens/withdraw/withdraw_methods_list/withdraw_methods_list_view.dart';

class Routes {

  static const baseScreen = '/baseScreen';
  static const dashboard = '/dashboard';
  static const zoneListAndAddition = '/zoneListAndAddition';
  static const editZone = '/editZone';
  static const orders = '/orderManagement';
  static const customersList = '/customersList';
  static const suspendedCustomersList = '/suspendedCustomersList';
  static const customerDetails = '/customerDetails';
  static const newServicemanRequests = '/newServicemanRequests';
  static const servicemenList = '/activeServicemanList';
  static const suspendedServicemanList = '/suspendedServicemanList';
  static const servicemanDetails = '/servicemanDetails';
  static const servicesList = '/servicesList';
  static const editService = '/editService';
  static const subServicesList = '/subServicesList';
  static const editSubService = '/editSubService';
  static const itemsList = '/itemsList';
  static const editItem = '/editItem';
  static const withdrawRequests = '/withdrawRequests';
  static const withdrawMethods = '/withdrawMethods';
  static const editWithdrawMethod = '/editWithdrawMethod';
  static const businessSetup = '/businessSetup';

  static final pages = [

    // GetPage(name: baseScreen, page: () => BaseScreenView(),)
    GetPage(name: dashboard, page: () => DashboardView()),
    GetPage(name: zoneListAndAddition, page: () => ZoneListAndAdditionView()),
    GetPage(name: editZone, page: () => EditZoneView()),
    GetPage(name: orders, page: () => OrderManagementView()),
    GetPage(name: customersList, page: () => CustomersListView()),
    GetPage(name: suspendedCustomersList, page: () => SuspendedCustomersListView()),
    GetPage(name: customerDetails, page: () => CustomerDetailsView()),
    GetPage(name: newServicemanRequests, page: () => NewRequestsView()),
    GetPage(name: servicemenList, page: () => ServiceMenListView()),
    GetPage(name: suspendedServicemanList, page: () => SuspendedServicemanListView()),
    GetPage(name: servicemanDetails, page: () => ServicemanDetailsView()),
    GetPage(name: servicesList, page: () => ServiceListView()),
    GetPage(name: editService, page: () => EditServiceView()),
    GetPage(name: subServicesList, page: () => SubServicesListView()),
    GetPage(name: editSubService, page: () => EditSubServiceView()),
    GetPage(name: itemsList, page: () => ItemsListView()),
    GetPage(name: editItem, page: () => EditItemView()),
    GetPage(name: withdrawMethods, page: () => WithdrawMethodsListView()),
    GetPage(name: editWithdrawMethod, page: () => EditWithdrawMethodView()),
    GetPage(name: withdrawRequests, page: () => WithdrawRequestsView()),
    GetPage(name: businessSetup, page: () => BusinessSetupView()),

  ];
}