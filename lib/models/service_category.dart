class ServiceCategory {

  String? id;
  String? name;
  String? desc;
  int? associatedSubServices;
  bool? status;
  String? image;
  DateTime? createdAt;

  ServiceCategory({
    this.id,
    this.name,
    this.desc,
    this.status,
    this.associatedSubServices,
    this.image,
    this.createdAt
  });

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    desc = json['desc'];
    status = json['status'] == 1 ? true : false;
    associatedSubServices = json['total_associated_services'];
    image = json['image'];
    createdAt = json['createdAt'];
  }

}