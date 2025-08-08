import 'package:service_app_admin_panel/models/service_item.dart';

import '../utils/constants.dart';

class Serviceman {

  String? id;
  String? name;
  String? phoneNo;
  double? rating;
  String? email;
  String? zoneId;
  double? longitude;
  double? latitude;
  double? earnings;
  int? totalOrders;
  String? profileImage;
  String? idCardFront;
  String? idCardBack;
  Gender? gender;
  UserStatuses? status;
  bool? isVerified;
  bool? accountDeleted;
  String? identificationNo;
  String? suspensionNote;
  String? selfNote;
  double? withdrawableAmount;
  double? withdrawnAmount;
  double? totalEarning;
  List<ServiceItem>? services;
  DateTime? createdAt;
  DateTime? identificationExpiry;

  Serviceman({
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
    this.createdAt,
    this.idCardBack,
    this.idCardFront,
    this.latitude,
    this.longitude,
    this.zoneId,
    this.totalOrders,
    this.earnings,
    this.suspensionNote,
    this.identificationNo,
    this.identificationExpiry,
    this.selfNote,
    this.withdrawableAmount,
    this.withdrawnAmount,
    this.totalEarning,
    this.services
  });

  Serviceman.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    phoneNo = json['phone'];
    rating = json['rating'] != null ? double.tryParse(json['rating']) : 0.0;
    email = json['email'];
    zoneId = json['zone_id'].toString();
    longitude = json['longitude'] != null ? double.tryParse(json['longitude']) : 0.0;
    latitude = json['latitude'] != null ? double.tryParse(json['latitude']) : 0.0;
    profileImage = json['profile_image'];
    idCardFront = json['id_card_front'];
    idCardBack = json['id_card_back'];
    gender = json['gender'] != null ? Gender.values.firstWhere((element) => element.name == json['gender']) : null;
    status = json['status'] != null ? UserStatuses.values.firstWhere((element) => element.name == json['status'].toString().toLowerCase().trim()) : null;
    isVerified = json['is_verified'] == 1 ? true : false;
    accountDeleted = json['account_deleted'] == 1 ? true : false;
    earnings = json['earnings'] != null ? double.tryParse(json['earnings']) : 0.0;
    totalOrders = json['total_orders'] ?? 0;
    identificationNo = json['identification_number'];
    createdAt = json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null;
    identificationExpiry = json['identification_expiry'] != null ? DateTime.tryParse(json['identification_expiry']) : null;
    suspensionNote = json['suspension_note'] ?? '';
    selfNote = json['note'] ?? '';
    withdrawableAmount = json['withdrawable_amount'] != null ? double.tryParse(json['withdrawable_amount']) : 0.0;
    withdrawnAmount = json['withdrawn_amount'] != null ? double.tryParse(json['withdrawn_amount']) : 0.0;
    totalEarning = json['total_earning'] != null ? double.tryParse(json['total_earning']) : 0.0;
    if(services != null) {
      services = [];
      json['service_items'].forEach((element) {
        services?.add(ServiceItem.fromJson(element));
      });

    }
  }
}