class ServiceItem {

  String? id;
  String? subServiceId;
  String? serviceId;
  String? name;
  String? subServiceName;
  bool? status;
  double? price;
  String? image;
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
    this.createdAt
  });

  ServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    serviceId = json['service_id'].toString();
    subServiceId = json['sub_service_id'].toString();
    subServiceName = json['sub_service_name'];
    name = json['name'];
    price = json['price'];
    status = json['status'] == 1 ? true : false;
    image = json['image'];
    createdAt = json['createdAt'];
  }
}