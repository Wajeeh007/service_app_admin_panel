class UserSummary {

  int? totalActiveCustomers;
  int? totalActiveServicemen;
  int? totalOrders;
  int? totalEarning;

  UserSummary({
    this.totalActiveCustomers,
    this.totalActiveServicemen,
    this.totalOrders,
    this.totalEarning,
  });

  UserSummary.fromJson(Map<String, dynamic> json) {
    totalActiveCustomers = json['total_active_customers'];
    totalActiveServicemen = json['total_active_servicemen'];
    totalOrders = json['total_orders'];
    totalEarning = json['total_earning'];
  }
}