class AnalyticalData {

  int? total;
  int? active;
  int? inActive;
  int? pending;
  int? accepted;
  int? ongoing;
  int? completed;
  int? cancelled;
  int? disputed;

  AnalyticalData({
    this.total,
    this.active,
    this.inActive,
    this.pending,
    this.accepted,
    this.ongoing,
    this.completed,
    this.cancelled,
    this.disputed
  });

  AnalyticalData.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    active = json['active'] ?? 0;
    inActive = json['in_active'] ?? 0;
    pending = json['pending'] ?? 0;
    accepted = json['accepted'] ?? 0;
    ongoing = json['ongoing'] ?? 0;
    completed = json['completed'] ?? 0;
    cancelled = json['cancelled'] ?? 0;
  }

}