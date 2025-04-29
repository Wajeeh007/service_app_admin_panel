import 'translation_keys.dart' as key;

class English {

  Map<String, String> get translations => {

    /// Dashboard
    key.dashboard: 'Dashboard',

    /// Zone Setup
    key.zoneSetup: 'Zone Setup',

    /// Order Management
    key.orderManagement: 'Order Management',

    /// Customer Management
    key.customerManagement: 'Customer Management',
    key.customerList: 'Customers List',
    key.suspendedCustomers: 'Suspended Customers',

    /// Service Man Management
    key.serviceManManagement: 'Serviceman Management',
    key.suspendedServiceMen: 'Suspended Servicemen',
    key.newRequests: 'New Requests',
    key.acceptedServiceMen: 'Accepted Servicemen',

    /// Service Management
    key.serviceManagement: 'Service Management',
    key.servicesList: 'Services List',
    key.subServicesList: 'Sub-Services List',
    key.itemsList: 'Items List',

    /// Withdraws
    key.withdraws: 'Withdraw',
    key.withdrawRequests: 'Withdraw Requests',

    /// Settings
    key.businessSetup: 'Business Setup',
    key.settings: 'Settings',
  };

}