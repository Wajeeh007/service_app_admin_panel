import 'package:service_app_admin_panel/models/address.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';
import 'package:service_app_admin_panel/utils/constants.dart';

import 'customer.dart';

class Order {

  String? id;
  Customer? customerDetails;
  Serviceman? serviceManDetails;
  Address? addressDetails;
  OrderStatus? status;
  DateTime? orderDateTime;
  DateTime? createdAt;
  String? note;

  Order({
    this.id,
    this.customerDetails,
    this.serviceManDetails,
    this.addressDetails,
    this.status,
    this.orderDateTime,
    this.createdAt,
    this.note
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerDetails = json['customer_details'] != null ? Customer.fromJson(json['customer_details']) : null;
    serviceManDetails = json['service_man_details'] != null ? Serviceman.fromJson(json['service_man_details']) : null;
    addressDetails = json['address_details'] != null ? Address.fromJson(json['address_details']) : null;
    status = OrderStatus.values.firstWhere((element) => element.name.toLowerCase().trim() == json['status'].toString().toLowerCase().trim());
    orderDateTime = json['order_date_time'] != null ? DateTime.parse(json['order_date_time']) : null;
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    note = json['note'];
  }
}