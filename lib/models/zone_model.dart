import 'package:service_app_admin_panel/utils/constants.dart';

class ZoneModel {

  int? id;
  String? name;
  String? desc;
  bool? status;
  String? polylines;
  ZoneOrderVolume? orderVolume;
  DateTime? createdAt;
  DateTime? updatedAt;

  ZoneModel({
    this.id,
    this.status,
    this.createdAt,
    this.name,
    this.desc,
    this.orderVolume,
    this.polylines,
    this.updatedAt
  });

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'] == 0 ? false : true;
    name = json['name'];
    desc = json['desc'];
    polylines = json['polylines'];
    orderVolume = switch (json['order_vol']) {
      'very_low' => ZoneOrderVolume.veryLow,
      'low' => ZoneOrderVolume.low,
      'medium' => ZoneOrderVolume.medium,
      'high' => ZoneOrderVolume.high,
      'very_high' => ZoneOrderVolume.veryHigh,
      null => ZoneOrderVolume.veryLow,
      // TODO: Handle this case.
      Object() => throw UnimplementedError(),
    };
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['desc'] = desc;
    data['status'] = status != null && status! ? 1 : 0;
    data['polylines'] = polylines;
    data['order_vol'] = switch (orderVolume) {
      ZoneOrderVolume.veryLow => 'very_low',
      ZoneOrderVolume.low => 'low',
      ZoneOrderVolume.medium => 'medium',
      ZoneOrderVolume.high => 'high',
      ZoneOrderVolume.veryHigh => 'very_high',
      null => 'very_low',
    };
    return data;
  }

}