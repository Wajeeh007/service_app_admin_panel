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
  double? totalAmount;
  double? commissionAmount;
  bool? paymentStatus;

  Order({
    this.id,
    this.customerDetails,
    this.serviceManDetails,
    this.addressDetails,
    this.status,
    this.orderDateTime,
    this.createdAt,
    this.note,
    this.totalAmount,
    this.commissionAmount,
    this.paymentStatus,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    customerDetails = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    serviceManDetails = json['serviceman'] != null ? Serviceman.fromJson(json['serviceman']) : null;
    addressDetails = json['address_details'] != null ? Address.fromJson(json['address_details']) : null;
    status = OrderStatus.values.firstWhere((element) => element.name.toLowerCase().trim() == json['status'].toString().toLowerCase().trim());
    orderDateTime = json['date_and_time'] != null ? DateTime.parse(json['date_and_time']) : null;
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    note = json['note'];
    totalAmount = json['total_amount'] != null ? double.tryParse(json['total_amount']) : 0.0;
    commissionAmount = json['commission_amount'] != null ? double.tryParse(json['commission_amount']) : 0.0;
    paymentStatus = json['payment_status'] == 0 ? false : true;
  }
}