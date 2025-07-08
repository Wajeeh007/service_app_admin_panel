import 'package:service_app_admin_panel/utils/constants.dart';

class Customer {

  String? id;
  String? name;
  String? phoneNo;
  String? email;
  String? profileImage;
  double? rating;
  Gender? gender;
  bool? status;
  bool? isVerified;
  bool? accountDeleted;
  int? totalOrders;
  double? totalSpent;
  String? adminNote;
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
    this.adminNote,
    this.createdAt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    phoneNo = "+${json['phone_number']}";
    email = json['email'];
    rating = double.tryParse(json['rating']);
    status = json['status'] == 1 ? true : false;
    gender = json['gender'] == 'male' ? Gender.male : json['gender'] == 'female' ? Gender.female : Gender.other;
    isVerified = json['is_verified'] == 1 ? true : false;
    accountDeleted = json['account_deleted'] == 1 ? true : false;
    profileImage = json['profile_image'];
    totalOrders = json['total_orders'];
    totalSpent = double.tryParse(json['total_spent']);
    adminNote = json['note'];
    createdAt = DateTime.parse(json['created_at']);
  }
}