import 'package:service_app_admin_panel/models/address.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';
import 'package:service_app_admin_panel/utils/constants.dart';

import 'customer.dart';

class Order {

  String? id;
  Customer? customerDetails;
  Serviceman? serviceManDetails;
  Address? addressDetails;
  OrderStatus? orderStatus;
  DateTime? orderDateTime;

  Order({
    this.id,
    this.customerDetails,
    this.serviceManDetails,
    this.addressDetails,
    this.orderStatus,
    this.orderDateTime
  });
}