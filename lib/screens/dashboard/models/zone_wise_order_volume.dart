class ZoneWiseOrderVolume {

  String? id;
  String? zoneName;
  int? totalOrders;
  double? percentage;

  ZoneWiseOrderVolume({
    this.id,
    this.percentage,
    this.zoneName,
    this.totalOrders
  });

  ZoneWiseOrderVolume.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneName = json['name'];
    totalOrders = json['total_orders'] != null ? int.tryParse(json['total_orders']) : null;
    percentage = json['order_rate'];
  }
}