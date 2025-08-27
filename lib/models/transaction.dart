import 'package:service_app_admin_panel/utils/constants.dart';

class Transaction {

  String? id;
  DateTime? transactionDate;
  double? totalAmount;
  double? commission;
  TransactionPaymentStatus? paymentStatus;

  Transaction({
    this.id,
    this.transactionDate,
    this.totalAmount,
    this.commission,
    this.paymentStatus,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionDate = DateTime.parse(json['created_at']);
    totalAmount = json['total_amount'] != null ? double.parse(json['total_amount']) : null;
    commission = json['commission'] != null ? double.parse(json['commission']) : null;
    paymentStatus = json['payment_status'] != null ? TransactionPaymentStatus.values.firstWhere((element) => element.name == json['payment_status']) : null;

  }
}