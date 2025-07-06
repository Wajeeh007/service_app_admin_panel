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
  DateTime? createdAt;
  
  WithdrawRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    servicemanId = json['serviceman_id'].toString();
    withdrawMethodId = json['withdraw_method_id'].toString();
    servicemanName = json['serviceman_name'];
    withdrawMethodName = json['withdraw_method_name'];
    servicemanAccountId = json['account_id'];
    amount = double.tryParse(json['amount']);
    status = json['status'] == 'pending' ? WithdrawRequestStatus.pending : json['status'] == 'approved' ? WithdrawRequestStatus.approved : json['status'] == 'settled' ? WithdrawRequestStatus.settled : WithdrawRequestStatus.denied;
    createdAt = DateTime.tryParse(json['created_at']);

  }
}