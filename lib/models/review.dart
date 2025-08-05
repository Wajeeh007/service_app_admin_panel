class Review {

  String? id;
  String? customerId;
  String? servicemanId;
  String? servicemanName;
  String? customerName;
  String? customerRemarks;
  double? ratingByCustomer;
  String? servicemanRemarks;
  double? ratingByServiceman;
  String? orderId;
  DateTime? customerReviewDate;
  DateTime? servicemanReviewDate;

  Review({
    this.id,
    this.customerId,
    this.servicemanId,
    this.customerRemarks,
    this.ratingByCustomer,
    this.servicemanRemarks,
    this.ratingByServiceman,
    this.orderId,
    this.servicemanName,
    this.customerName,
    this.servicemanReviewDate,
    this.customerReviewDate,
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
    customerName = json['customer_name'];
    servicemanName = json['serviceman_name'];
    customerReviewDate = json['customer_review_date'] != null ? DateTime.tryParse(json['customer_review_date']) : DateTime.now();
    servicemanReviewDate = json['serviceman_review_date'] != null ? DateTime.tryParse(json['serviceman_review_date']) : DateTime.now();
  }
}