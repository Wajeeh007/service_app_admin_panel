import 'translation_keys.dart' as key;

class English {

  Map<String, String> get translations => {

    /// Dashboard
    key.dashboard: 'Dashboard',

    /// Side Panel
      /// Zone Setup
      key.zoneSetup: 'Zone Setup',

      /// Order Management
      key.orderManagement: 'Order Management',
      key.orders: 'Orders',

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

    /// Dashboard Screen
    key.welcomeAdmin: 'Welcome Admin',
    key.monitorYourBusinessStatistics: 'Monitor your business statistics',
    key.activeCustomers: 'Active Customers',
    key.activeServicemen: 'Active Servicemen',
    key.totalOrders: 'Total Orders',
    key.totalEarnings: 'Total Earnings',
    key.zoneWiseOrders: 'Zone-Wise Orders',
    key.adminEarningStatistics: 'Admin Earning Statistics',
    key.noZoneSelected: 'No Zone Selected',
    key.logout: 'Logout',
    /// Dashboard Screen End ///

    /// Zone Setup Screen
    key.instructions: 'Instructions',
    key.zoneName: 'Zone Name',
    key.zoneList: 'Zone List',
    key.zoneSetupInstructions: '\t• Create Zones By Clicking On Map And Connect The Dots Together.\n\n\t• Use The Drag Map To Find Proper Area\n\n\t• Click the Icon to start pin points in the map and connect them to draw a zone. Minimum 3 points required ',
    key.searchZone: 'Search Zone',
    key.orderVolume: 'Order Volume',
    /// Zone Setup End ///

    /// Orders List Screen
    key.ordersList: 'Orders List',
    key.allOrders: 'All Orders',
    key.pending: 'Pending',
    key.accepted: 'Accepted',
    key.ongoing: 'Ongoing',
    key.cancelled: 'Cancelled',
    key.completed: 'Completed',
    key.disputes: 'Disputes',
    key.pendingRequest: 'Pending Request',
    key.acceptedRequest: 'Accepted Request',
    key.searchOrder: 'Search Order',
    key.commission: 'Commission',
    key.totalAmount: 'Total Amount',
    key.paymentStatus: 'Payment Status',
    key.orderStatus: 'Order Status',
    key.customerName: 'Customer Name',
    key.reason: 'Reason',
    key.serviceman: 'Serviceman',
    key.customer: 'Customer',
    /// Order List Screen End ///

    /// General
    key.fieldIsRequired: 'Field is required',
    key.invalidEmail: 'Invalid email',
    key.save: 'Save',
    key.search: 'Search',
    key.page: 'Page',
    key.of: 'of',
    key.status: 'Status',
    key.actions: 'Actions',
    key.noDataAvailable: 'No Data Available',
    key.date: 'Date',
  };

}