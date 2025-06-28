class AnalyticalData {

  int? total;
  int? active;
  int? inActive;

  AnalyticalData({this.total, this.active, this.inActive});

  AnalyticalData.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    active = json['active'] ?? 0;
    inActive = json['in_active'] ?? 0;
  }

}