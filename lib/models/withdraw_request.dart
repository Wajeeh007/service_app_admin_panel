import 'package:service_app_admin_panel/languages/translation_keys.dart';

import '../utils/constants.dart';

class WithdrawRequest {

  String? id;
  String? servicemanId;
  String? withdrawMethodId;
  String? servicemanName;
  String? withdrawMethodName;
  String? servicemanAccountId;
  double? amount;
  WithdrawRequestStatus? status;
  String? receiptUrl;
  String? note;
  DateTime? createdAt;
  DateTime? transferDate;
  String? transactionId;

  WithdrawRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    servicemanId = json['serviceman_id'].toString();
    withdrawMethodId = json['withdraw_method_id'].toString();
    servicemanName = json['serviceman_name'];
    withdrawMethodName = json['withdraw_method_name'];
    servicemanAccountId = json['account_id'];
    amount = double.tryParse(json['amount']);
    status = json['status'] == 'pending' ? WithdrawRequestStatus.pending : json['status'] == 'approved' ? WithdrawRequestStatus.approved : json['status'] == 'settled' ? WithdrawRequestStatus.settled : WithdrawRequestStatus.denied;
    receiptUrl = json['receipt'];
    note = json['note'];
    createdAt = DateTime.tryParse(json['created_at']);
    transferDate = json['transfer_date'] != null ? DateTime.tryParse(json['transfer_date']) : null;
    transactionId = json['transaction_id'];
  }
}