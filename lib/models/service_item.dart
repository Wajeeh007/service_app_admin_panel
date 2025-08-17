class ServiceItem {

  String? id;
  String? subServiceId;
  String? serviceId;
  String? name;
  String? subServiceName;
  bool? status;
  double? price;
  String? image;
  String? serviceName;
  DateTime? createdAt;
  
  ServiceItem({
    this.id,
    this.subServiceId,
    this.serviceId,
    this.name,
    this.subServiceName,
    this.status,
    this.price,
    this.image,
    this.serviceName,
    this.createdAt
  });

  ServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    serviceId = json['service_id'].toString();
    subServiceId = json['sub_service_id'].toString();
    subServiceName = json['sub_service_name'];
    name = json['name'];
    price = json['price'] != null ? double.tryParse(json['price']) : 0.0;
    status = json['status'] == 1 ? true : false;
    image = json['image'];
    serviceName = json['service_name'];
    createdAt = json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null;
  }
}