import 'package:service_app_admin_panel/utils/constants.dart';

class Customer {

  String? id;
  String? name;
  String? phoneNo;
  String? email;
  String? profileImage;
  double? rating;
  Gender? gender;
  UserStatuses? status;
  bool? isVerified;
  bool? accountDeleted;
  int? totalOrders;
  double? totalSpent;
  String? suspensionNote;
  DateTime? createdAt;

  Customer({
    this.id,
    this.name,
    this.phoneNo,
    this.rating,
    this.email,
    this.profileImage,
    this.status,
    this.gender,
    this.accountDeleted,
    this.isVerified,
    this.totalOrders,
    this.totalSpent,
    this.suspensionNote,
    this.createdAt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    phoneNo = json['phone'];
    email = json['email'];
    rating = json['rating'] != null ? double.tryParse(json['rating']) : null;
    status = json['status'] != null ? UserStatuses.values.firstWhere((element) => element.name.toLowerCase().trim() == json['status'].toString().toLowerCase().trim()) : UserStatuses.active;
    gender = json['gender'] != null ? Gender.values.firstWhere((element) => element.name.toLowerCase().trim() == json['gender'].toString().toLowerCase().trim()) : Gender.male;
    isVerified = json['is_verified'] == 1 ? true : false;
    accountDeleted = json['account_deleted'] == 1 ? true : false;
    profileImage = json['profile_image'];
    totalOrders = json['total_orders'];
    totalSpent = json['total_spent'] != null ? double.tryParse(json['total_spent']) : null;
    suspensionNote = json['suspension_note'];
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
  }
}