class Review {

  String? id;
  String? customerId;
  String? servicemanId;
  String? customerRemarks;
  double? ratingByCustomer;
  String? servicemanRemarks;
  double? ratingByServiceman;
  String? orderId;

  Review({
    this.id,
    this.customerId,
    this.servicemanId,
    this.customerRemarks,
    this.ratingByCustomer,
    this.servicemanRemarks,
    this.ratingByServiceman,
    this.orderId,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    servicemanId = json['serviceman_id'];
    customerRemarks = json['customer_remarks'];
    ratingByCustomer = json['rating_by_customer'] != null ? double.tryParse(json['rating_by_customer']) : null;
    servicemanRemarks = json['serviceman_remarks'];
    ratingByServiceman = json['rating_by_serviceman'] != null ? double.tryParse(json['rating_by_serviceman']) : null;
    orderId = json['order_id'];

  }
}