class ZoneModel {

  int? id;
  String? name;
  bool? status;
  String? polygon;
  DateTime? createdAt;
  DateTime? updatedAt;

  ZoneModel({
    this.id,
    this.status,
    this.createdAt,
    this.name,
    this.polygon,
    this.updatedAt
  });

}