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
    this.identificationNo,
    this.identificationExpiry
  });

  Serviceman.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    phoneNo = "+${json['phone_number']}";
    rating = double.tryParse(json['rating']) ?? 0.0;
    email = json['email'];
    zoneId = json['zoneId'].toString();
    longitude = json['longitude'] != null ? double.tryParse(json['longitude']) : 0.0;
    latitude = json['latitude'] != null ? double.tryParse(json['latitude']) : 0.0;
    profileImage = json['profileImage'];
    idCardFront = json['idCardFront'];
    idCardBack = json['idCardBack'];
    gender = json['gender'] == 'male' ? Gender.male : json['gender'] == 'female' ? Gender.female : Gender.other;
    status = json['status'] == 1 ? true : false;
    isVerified = json['isVerified'] == 1 ? true : false;
    accountDeleted = json['accountDeleted'] == 1 ? true : false;
    earnings = json['earnings'] != null ? double.tryParse(json['earnings']) : 0.0;
    totalOrders = json['total_orders'] ?? 0;
    identificationNo = json['identification_number'];
    createdAt = DateTime.tryParse(json['created_at']);
    identificationExpiry = DateTime.tryParse(json['identification_expiry']);
  }
}