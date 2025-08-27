import 'service_item.dart';

class SubService {

  String? id;
  String? serviceId;
  String? serviceName;
  String? name;
  bool? status;
  int? associatedItems;
  List<ServiceItem>? items;
  String? image;
  DateTime? createdAt;

  SubService({
    this.id,
    this.serviceId,
    this.serviceName,
    this.name,
    this.status,
    this.associatedItems,
    this.items,
    this.image,
    this.createdAt
  });

  SubService.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    serviceId = json['service_id'].toString();
    serviceName = json['service_name'];
    name = json['name'];
    status = json['status'] == 1 ? true : false;
    associatedItems = json['total_associated_items'];
    image = json['image'];
    createdAt = json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null;
  }

}