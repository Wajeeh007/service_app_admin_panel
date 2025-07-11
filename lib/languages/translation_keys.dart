/// Dashboard
const dashboard = 'dashboard';

/// Side Panel
  /// Zone Setup
  const zoneSetup = 'zoneSetup';

  /// Order Management
  const orderManagement = 'orderManagement',
      orders = 'orders';

  /// Customer Management
  const customerManagement = 'customerManagement',
      customersList = 'customerList',
      suspendedCustomers = 'deletedCustomers';

  /// Serviceman Management
  const serviceManManagement = 'serviceManManagement',
      newRequests = 'newRequests',
      suspendedServiceMen = 'suspendedServiceMen',
      acceptedServiceMen = 'acceptedServiceMen';

  /// Service Management
  const serviceManagement = 'serviceManagement',
      servicesList = 'servicesList',
      subServicesList = 'subServicesList',
      itemsList = 'itemsList';

  /// Withdraws
  const withdraws = 'withdraws',
      methods = 'methods',
      requests = 'requests';

  /// Settings
  const settings = 'business_setup',
      businessSetup = 'businessSetup';

/// Side Panel End

/// Dashboard
const welcomeAdmin = 'welcomeAdmin',
    monitorYourBusinessStatistics = 'monitorYourBusinessStatistics',
    activeCustomers = 'activeCustomers',
    activeServicemen = 'activeServicemen',
    totalOrders = 'totalOrders',
    totalEarnings = 'totalEarnings',
    zoneWiseOrders = 'zoneWiseOrders',
    adminEarningStatistics = 'adminEarningStatistics',
    noZoneSelected = 'noZoneSelected',
    logout = 'logout';
/// Dashboard End ///

/// Zone Setup Screen
const instructions = 'instructions',
    zoneName = 'zoneName',
    description = 'description',
    zoneList = 'zoneList',
    zoneSetupInstructions = 'zoneSetupInstructions',
    searchZone = 'searchZone',
    orderVolume = 'orderVolume',
    veryLow = 'veryLow',
    low = 'low',
    medium = 'medium',
    high = 'high',
    veryHigh = 'veryHigh';
/// Zone Setup End ///

/// Orders List Screen
const ordersList = 'ordersList',
    allOrders = 'allOrders',
    pending = 'pending',
    accepted = 'accepted',
    ongoing = 'ongoing',
    cancelled = 'cancelled',
    completed = 'completed',
    disputed = 'disputed',
    totalAmount = 'totalAmount',
    commission = 'commission',
    paymentStatus = 'paymentStatus',
    orderStatus = 'orderStatus',
    customerName = 'customerName',
    reason = 'reason',
    serviceman = 'serviceman',
    customer = 'customer',
    paid = 'paid',
    unpaid = 'unpaid';
/// Orders List Screen End ///

/// Customer Management ///
  /// Customer List Screen
  const customersAnalyticalData = 'customersAnalyticalData',
      totalCustomers = 'totalCustomers',
      totalSpent = 'totalSpent',
      gender = 'gender',
      searchCustomer = 'searchCustomer';
  /// Customer List Screen End ///

  /// Suspended Customer's List Screen
  const adminNote = 'adminNote';
  /// Suspended Customer's List Screen End ///
/// Customer Management End ///

/// Serviceman Management ///
  /// New Requests List Screen ///
  const identificationNo = 'identificationNo',
      dateOfExpiry = 'dateOfExpiry',
      timeOfRequest = 'timeOfRequest';
  /// New Requests List Screen End ///

  /// Active servicemen list screen ///
  const earning = 'earning',
      servicemenList = 'servicemenList',
      servicemenAnalyticalData = 'servicemenAnalyticsData',
      totalServicemen = 'totalServicemen',
      suspendedServicemen = 'suspendedServicemen';
  /// Active servicemen list screen end ///

  const searchServiceman = 'searchServiceman';
/// Serviceman Management End ///

/// Service Management ///
  /// Services Listing Screen
  const image = 'image',
      services = 'services',
      serviceInfo = 'serviceInfo',
      serviceName = 'serviceName',
      serviceDesc = 'serviceDesc',
      typeBriefServiceDesc = 'typeBriefServiceDesc',
      subServices = 'subServices',
      searchService = 'searchService';
  /// Services Listing Screen End ///

  /// Edit Service ///
  const editService = 'editService';
  /// Edit Service End ///

  /// Sub Services Listing Screen ///
  const searchSubService = 'searchSubService',
      subServiceInfo = 'subServiceInfo',
      subServiceName = 'subServiceName',
      serviceType = 'serviceType',
      chooseSubService = 'chooseSubService',
      associatedItems = 'associatedItems';
  /// Sub Services Listing Screen End ///

  /// Edit Sub-Service ///
  const editSubService = 'editSubService';
  /// Edit Sub-Service End ///

  /// Items Listing Screen ///
  const addItemDetails = 'addItemDetails',
      searchItem = 'searchItem',
      itemName = 'itemName',
      price = 'price',
      subServiceType = 'subServiceType',
      service = 'service',
      subService = 'subService',
      serviceItemInfo = 'serviceItemInfo';
  /// Items Listing Screen End ///

  /// Edit Item ///
  const editItem = 'editItem';
  ///  Edit Item End ///

/// Service Management End ///

/// Withdraws ///

  /// Withdraw Methods ///
  const methodsList = 'methodsList',
    addMethod = 'addNewMethod',
    searchMethod = 'searchMethod',
    setupMethodInfo = 'setupMethodInfo',
    text = 'text',
    number = 'number',
    email = 'email',
    methodName = 'methodName',
    makeMethodDefault = 'makeMethodDefault',
    selectFieldType = 'selectFieldType',
    inputFieldType = 'inputFieldType',
    fieldName = 'fieldName',
    placeholderText = 'placeholderText',
    saveInformation = 'saveInformation',
    fieldType = 'fieldType',
    isDefault = 'isDefault';
  /// Withdraw Methods End ///

  /// Withdraw Requests ///

  const approved = 'approved',
    settled = 'settled',
    denied = 'denied',
    amount = 'amount',
    method = 'method',
    searchByServiceman = 'searchByServiceman',
    accountId = 'accountId',
    approve = 'approve',
    decline = 'decline',
    settle = 'settle',
    view = 'view',
      transferDate = 'transferDate',
    transactionId = 'transactionId',
    provideReasonForDecliningRequest = 'provideReasonForDecliningRequest',
    provideDetailsOfTransaction = 'provideDetailsOfTransaction',
    uploadReceipt = 'uploadReceipt',
    cont = 'continue';

  /// Withdraw Requests End ///

/// Withdraws End ///

/// Business Setup ///

  /// Settings ///
  const businessInfo = 'businessInfo';
  /// Settings End ///

/// Business Setup End ///

/// General
const fieldIsRequired = 'fieldIsRequired',
    invalidEmail = 'invalidEmail',
    save = 'save',
    search = 'search',
    page = 'page',
    of = 'of',
    status = 'status',
    actions = 'actions',
    date = 'date',
    requestDate = 'requestDate',
    noDataAvailable = 'noDataAvailable',
    all = 'all',
    active = 'active',
    inactive = 'inactive',
    name = 'name',
    contactInfo = 'contactInfo',
    typeHere = 'typeHere',
    saveInfo = 'saveInfo',
    uploadFile = 'uploadFile',
    fileInstructions = 'fileInstructions',
    searchOrder = 'searchOrder',
    createdDate = 'createdDate',
    error = 'error',
    success = 'success',
    cancel = 'cancel',
    retry = 'retry',
    areYouSure = 'areYouSure',
    thisActionIsIrreversible = 'thisActionIsIrreversible',
    deletionConfirmationMessage = 'deletionConfirmationMessage',
    suspensionConfirmationMessage = 'suspensionConfirmationMessage',
    yes = 'yes',
    no = 'no',
    male = 'male',
    female = 'female',
    other = 'other',
    sl = 'sl';

/// Success Messages ///
const zoneCreated = 'zoneAdded',
    zoneEdited = 'zoneEdited';
/// Success Messages End ///

/// Errors
const addServiceError = 'addServiceError',
    addSubServiceImage = 'addSubServiceImage',
    addItemSubServiceType = 'addItemSubServiceType',
    addItemImage = 'addItemImage',
    zoneDetailsNotChanged = 'zoneDetailsNotChanged',
    unableToReachClient = 'unableToReachClient',
    noInternetError = 'noInternetError',
    formatExceptionError = 'formatExceptionError',
    timeOutException = 'timeOutException',
    generalApiError = 'generalApiError',
    errorFetchingZones = 'errorFetchingZones',
    errorChangingStatus = 'errorChangingStatus',
    addAreaPolygon = 'addAreaPolygon',
    noInfoChanged = 'noDataChanged',
    clientExceptionError = 'clientExceptionError',
    addReceiptImageToProceed = 'addReceiptImageToProceed';
/// Errors End ///