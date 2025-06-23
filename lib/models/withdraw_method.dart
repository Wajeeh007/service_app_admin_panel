import 'package:service_app_admin_panel/utils/constants.dart';

class WithdrawMethod {

  String? id;
  String? name;
  String? fieldName;
  WithdrawMethodFieldType? fieldType;
  String? placeholderText;
  bool? isDefault;
  bool? status;
  DateTime? createdAt;

  WithdrawMethod({
    this.id,
    this.name,
    this.fieldName,
    this.fieldType,
    this.placeholderText,
    this.isDefault,
    this.status,
    this.createdAt
  });

  WithdrawMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    fieldName = json['field_name'];
    fieldType = json['field_type'] == 'text' ? WithdrawMethodFieldType.text : json['field_type'] == 'number' ? WithdrawMethodFieldType.number : WithdrawMethodFieldType.email;
    placeholderText = json['placeholder_text'];
    isDefault = json['is_default'] == 1 ? true : false;
    status = json['status'] == 1 ? true : false;
    createdAt = DateTime.parse(json['created_at']);

  }

}