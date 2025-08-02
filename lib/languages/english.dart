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
      key.customersList: 'Customers List',
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
      key.withdraws: 'Withdraws',
      key.requests: 'Requests',
      key.methods: 'Methods',

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
    key.description: 'Description',
    key.zoneList: 'Zone List',
    key.zoneSetupInstructions: '\t• Create Zones By Clicking On Map And Connect The Dots Together.\n\n\t• Use The Drag Map To Find Proper Area\n\n\t• Click the Icon to start pin points in the map and connect them to draw a zone. Minimum 3 points required ',
    key.searchZone: 'Search Zone',
    key.orderVolume: 'Order Volume',
    key.veryLow: 'Very Low',
    key.low: 'Low',
    key.medium: 'Medium',
    key.high: 'High',
    key.veryHigh: 'Very High',
    /// Zone Setup End ///

    /// Orders List Screen
    key.ordersList: 'Orders List',
    key.allOrders: 'All Orders',
    key.pending: 'Pending',
    key.accepted: 'Accepted',
    key.ongoing: 'Ongoing',
    key.cancelled: 'Cancelled',
    key.completed: 'Completed',
    key.disputed: 'Disputed',
    key.commission: 'Commission',
    key.totalAmount: 'Total Amount',
    key.paymentStatus: 'Payment Status',
    key.orderStatus: 'Order Status',
    key.customerName: 'Customer Name',
    key.reason: 'Reason',
    key.serviceman: 'Serviceman',
    key.customer: 'Customer',
    key.paid: 'Paid',
    key.unpaid: 'Un-Paid',
    /// Order List Screen End ///

    /// Customer Management ///
      /// Customers List Screen ///
      key.customersAnalyticalData: 'Customers Analytical Data',
      key.totalCustomers: 'Total Customers',
      key.totalSpent: 'Total Spent',
      key.gender: 'Gender',
      key.male: 'Male',
      key.female: 'Female',
      key.other: 'Other',
      key.searchCustomer: 'Search Customer',
      /// Customers List Screen End ///

      /// Suspended Customers List Screen
      key.adminNote: 'Admin Note',
      /// Suspended Customers List Screen End ///

      /// Customer Details Screen ///
      key.customerInfo: 'Customer Information',
      key.customerActivityRate: 'Customer Activity Rate',
      key.averageActivityRate: 'Average Activity Rate',
      key.averageSpending: 'Average Spending',
      key.positiveReviewRate: 'Positive Review Rate',
      key.successRate: 'Success Rate',
      key.cancellationRate: 'Cancellation Rate',
      key.customerOrderDetails: 'Customer Order Details',
      key.totalCompletedOrders: 'Total Completed Orders',
      key.totalCancelledOrders: 'Total Cancelled Orders',
      key.highestAmountOrder: 'Highest Amount Order',
      key.lowestAmountOrder: 'Lowest Amount Order',
      key.overView: 'Overview',
      key.reviews: 'Reviews',
      key.transactions: 'Transactions',
      key.customerRating: 'Customer Rating',
      key.reviewFromServiceman: 'Review From Serviceman',
      key.reviewGivenToServiceman: 'Review Given To Serviceman',
      /// Customer Details Screen End ///


  /// Customer Management End ///

    /// Serviceman Management ///
      /// New Requests List Screen ///
      key.identificationNo: 'Identification No',
      key.dateOfExpiry: 'Date Of Expiry',
      key.timeOfRequest: 'Time Of Request',
      /// New Requests List Screen End ///

      /// Active servicemen list screen ///
      key.earning: 'Earning',
      key.servicemenList: 'Servicemen List',
      key.servicemenAnalyticalData: 'Servicemen Analytical Data',
      key.totalServicemen: 'Total Servicemen',
      key.suspendedServicemen: 'Suspended Servicemen',
      key.enterReasonForSuspension: 'Enter reason for suspension',
      /// Active servicemen list screen end ///

    key.searchServiceman: 'Search Serviceman',
    /// Serviceman Management End ///

    /// Service Management ///
      /// Services Listing Screen
      key.image: 'Image',
      key.services: 'Services',
      key.serviceInfo: 'Service Information',
      key.serviceName: 'Service Name',
      key.serviceDesc: 'Service Description',
      key.typeBriefServiceDesc: 'Type a brief description of the service...',
      key.subServices: 'Sub-Services',
      key.searchService: 'Search Service',
      key.associatedItems: 'Associated Items',
      /// Services Listing Screen End ///

      /// Edit Service ///
      key.editService: 'Edit Service',
      /// Edit Service End ///

      /// Sub Services Listing Screen ///
      key.searchSubService: 'Search Sub-Service',
      key.subServiceInfo: 'Sub-Service Information',
      key.subServiceName: 'Sub-Service Name',
      key.chooseSubService: 'Choose Sub-Service',
      /// Sub Services Listing Screen End ///

      /// Edit Sub-Service ///
      key.editSubService: 'Edit Sub-Service',
      /// Edit Sub-Service End ///

      /// Items listing screen ///
      key.addItemDetails: 'Add Items Details',
      key.searchItem: 'Search Item',
      key.itemName: 'Item Name',
      key.price: 'Price',
      key.subServiceType: 'Sub-Service Type',
      key.service: 'Service',
      key.subService: 'Sub-Service',
      key.serviceItemInfo: 'Service Item Info',
      /// Items listing screen end ///

      /// Edit Item ///
      key.editItem: 'Edit Item',
      /// Edit Item End ///

    /// Service Management End ///

    /// Withdraws ///

      /// Withdraw Methods ///
      key.methodsList: 'Methods List',
      key.searchMethod: 'Search Method',
      key.addMethod: 'Add Method',
      key.setupMethodInfo: 'Setup Method Info',
      key.text: 'Text',
      key.number: 'Number',
      key.email: 'Email',
      key.methodName: 'Method Name',
      key.makeMethodDefault: 'Make method default',
      key.selectFieldType: 'Select Field Type',
      key.placeholderText: 'Placeholder Text',
      key.inputFieldType: 'Input Field Type',
      key.fieldName: 'Field Name',
      key.saveInformation: 'Save Information',
      key.fieldType: 'Field Type',
      key.isDefault: 'Is Default',
      /// Withdraw Methods End ///

      /// Withdraw Requests ///
      key.approved: 'Approved',
      key.settled: 'Settled',
      key.denied: 'Denied',
      key.amount: 'Amount',
      key.method: 'Method',
      key.searchByServiceman: 'Search By Serviceman',
      key.accountId: 'Account ID',
      key.approve: 'Approve',
      key.decline: 'Decline',
      key.settle: 'Settle',
      key.view: 'View',
      key.transactionId: 'Transaction ID',
      key.provideReasonForDecliningRequest: 'If you want to decline this request, please provide a reason.\n\nThis reason shall be shown to the serviceman',
      key.provideDetailsOfTransaction: 'Provide the following details of transaction',
      key.uploadReceipt: 'Upload Receipt',
      key.cont: 'Continue',
      /// Withdraw Requests End ///
    /// Withdraws End ///

    /// Business Setup ///

      /// Settings ///
      key.businessInfo: 'Business Information',
      /// Settings End ///

    /// Business Setup End ///

    /// General
    key.save: 'Save',
    key.search: 'Search',
    key.page: 'Page',
    key.of: 'of',
    key.status: 'Status',
    key.actions: 'Actions',
    key.noDataAvailable: 'No Data Available',
    key.date: 'Date',
    key.requestDate: 'Request Date',
    key.transferDate: 'Transfer Date',
    key.active: 'Active',
    key.inactive: 'Inactive',
    key.all: 'All',
    key.name: 'Name',
    key.contactInfo: 'Contact Info',
    key.typeHere: 'Type Here',
    key.saveInfo: 'Save Info',
    key.uploadFile: 'Upload File',
    key.fileInstructions: 'File Format - jpg .jpeg .png Image Size - Maximum Size 5 MB.',
    key.createdDate: 'Creation Date',
    key.searchOrder: 'Search Order',
    key.error: 'Error',
    key.success: 'Success',
    key.cancel: 'Cancel',
    key.retry: 'Retry',
    key.areYouSure: 'Are You Sure?',
    key.thisActionIsIrreversible: 'This action is irreversible. Proceed with caution.',
    key.deletionConfirmationMessage: 'This action is permanent and cannot be reversed. Do you wish to proceed?',
    key.suspensionConfirmationMessage: 'This user\'s account will be suspended and they\'ll be unable to use their account. Do you wish to proceed?',
    key.yes: 'Yes',
    key.no: 'No',
    key.sl: 'SL',
    key.suspended: 'Suspended',
    key.note: 'Note',
    key.suspend: 'Suspend',
    key.rating: 'Rating',
    key.review: 'Review',

    /// Success Messages ///

      /// Zone Setup ///

      key.zoneCreated: 'Zone Created Successfully',
      key.zoneEdited: 'Zone Edited Successfully',

      /// Zone Setup End ///

    /// Success Messages End ///
    
    /// Errors
    key.fieldIsRequired: 'Field is required',
    key.invalidEmail: 'Invalid email',
    key.addServiceError: 'Add service type to save sub-service category',
    key.addSubServiceImage: 'Add sub-service image to save information',
    key.addItemImage: 'Add Item image to save information',
    key.addItemSubServiceType: 'Add Item sub-service type to save information',
    key.zoneDetailsNotChanged: 'No details changed. Click on Cancel to go back.',
    key.unableToReachClient: 'Unable to reach server.',
    key.noInternetError: 'No Internet Connection',
    key.formatExceptionError: 'Unable to handle the request',
    key.timeOutException: 'Server took too long to respond',
    key.generalApiError: 'Something went wrong',
    key.errorFetchingZones: 'Error fetching zones. Please refresh page.',
    key.errorChangingStatus: 'Error changing status. Please retry.',
    key.addAreaPolygon: 'Add area polygon to proceed',
    key.noInfoChanged: 'No information changed to update.',
    key.clientExceptionError: 'Server unreachable.',
    key.addReceiptImageToProceed: 'Add receipt image to proceed',
    key.locationServiceDisabled: 'Location services disabled',
    key.locationPermissionsDenied: 'Location permissions denied',
    key.locationPermissionsPermanentlyDenied: 'Location permissions are permanently denied, we cannot request permissions.',
    /// Errors End ///
  };

}