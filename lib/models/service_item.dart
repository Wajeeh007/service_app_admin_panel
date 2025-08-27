import 'package:service_app_admin_panel/models/service_category.dart';
import 'package:service_app_admin_panel/models/sub_service.dart';

class ServiceItem {

  String? id;
  String? name;
  SubService? subService;
  bool? status;
  double? price;
  String? image;
  ServiceCategory? service;
  DateTime? createdAt;
  
  ServiceItem({
    this.id,
    this.name,
    this.subService,
    this.status,
    this.price,
    this.image,
    this.service,
    this.createdAt
  });

  ServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    subService = json['sub_service'] != null ? SubService.fromJson(json['sub_service']) : null;
    name = json['name'];
    price = json['price'] != null ? double.tryParse(json['price']) : 0.0;
    status = json['status'] == 1 ? true : false;
    image = json['image'];
    service = json['service'] != null ? ServiceCategory.fromJson(json['service']) : null;
    createdAt = json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null;
  }
}