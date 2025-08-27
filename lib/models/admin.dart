import 'package:service_app_admin_panel/utils/constants.dart';

class Admin {

  String? id;
  String? name;
  String? email;
  UserStatuses? status;
  String? profileImage;
  Gender? gender;
  String? suspensionNote;
  DateTime? createdAt;
  String? roleId;
  String? adminProfileId;

  Admin({
    this.id,
    this.name,
    this.email,
    this.status,
    this.profileImage,
    this.gender,
    this.suspensionNote,
    this.createdAt,
    this.roleId,
    this.adminProfileId
  });

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    status = json['status'] != null ? UserStatuses.values.firstWhere((element) => element.name.toLowerCase() == json['status'].toString().toLowerCase().trim()) : null;
    profileImage = json['profile_image'];
    gender = json['gender'] != null ? Gender.values.firstWhere((element) => element.name.toLowerCase() == json['gender'].toString().toLowerCase().trim()) : null;
    suspensionNote = json['suspension_note'];
    createdAt = json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null;
    roleId = json['role_id'];
    adminProfileId = json['admin_profile_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['gender'] = gender?.name;
    data['status'] = status?.name;
    data['profile_image'] = profileImage;
    data['suspension_note'] = suspensionNote;
    data['created_at'] = createdAt?.toIso8601String();
    data['role_id'] = roleId;
    data['admin_profile_id'] = adminProfileId;
    return data;
  }
}