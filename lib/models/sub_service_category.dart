import 'service_item.dart';

class ServiceSubCategory {

  String? id;
  String? name;
  bool? status;
  int? associatedItems;
  List<ServiceItem>? items;
  String? image;

  ServiceSubCategory({
    this.id,
    this.name,
    this.status,
    this.associatedItems,
    this.items,
    this.image
  });

}