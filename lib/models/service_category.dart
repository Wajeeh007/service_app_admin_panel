import 'package:service_app_admin_panel/models/sub_service_category.dart';

class ServiceCategory {

  String? id;
  String? name;
  int? associatedSubServices;
  List<ServiceSubCategory>? subServices;
  bool? status;
  String? image;

  ServiceCategory({
    this.id,
    this.name,
    this.status,
    this.associatedSubServices,
    this.subServices,
    this.image
  });

}