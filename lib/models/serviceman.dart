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
  bool? status;
  bool? isVerified;
  bool? accountDeleted;
  String? identificationNo;
  String? adminNote;
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
    this.adminNote,
    this.identificationNo,
    this.identificationExpiry
  });

  Serviceman.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    phoneNo = "+${json['phone_number']}";
    rating = json['rating'] != null ? double.tryParse(json['rating']) : 0.0;
    email = json['email'];
    zoneId = json['zone_id'].toString();
    longitude = json['longitude'] != null ? double.tryParse(json['longitude']) : 0.0;
    latitude = json['latitude'] != null ? double.tryParse(json['latitude']) : 0.0;
    profileImage = json['profile_image'];
    idCardFront = json['id_card_front'];
    idCardBack = json['id_card_back'];
    gender = json['gender'] != null ? Gender.values.firstWhere((element) => element.name == json['gender']) : null;
    status = json['status'] == 1 ? true : false;
    isVerified = json['is_verified'] == 1 ? true : false;
    accountDeleted = json['account_deleted'] == 1 ? true : false;
    earnings = json['earnings'] != null ? double.tryParse(json['earnings']) : 0.0;
    totalOrders = json['total_orders'] ?? 0;
    identificationNo = json['identification_number'];
    createdAt = json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null;
    identificationExpiry = json['identification_expiry'] != null ? DateTime.tryParse(json['identification_expiry']) : null;
    adminNote = json['note'] ?? '';
  }
}